import 'package:flutter/material.dart';
import 'package:screw_app/app_constants.dart';

class DashBoardScreen extends StatelessWidget {
  final List<List<int>> playerScores;
  final List<String> playerNames;

  const DashBoardScreen({
    Key? key,
    required this.playerScores,
    required this.playerNames,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
                dataTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => AppColor.kBackgroundTableHead),
                border: TableBorder.all(color: Colors.white),
                columns: [
                  for (int i = 0; i < playerNames.length; i++)
                    DataColumn(
                      label: Align(
                        alignment: Alignment.center,
                        child: Text(playerNames[i]),
                      ),
                    ),
                ],
                rows: playerScores.isNotEmpty
                    ? List.generate(
                        playerScores.length + 1,
                        (index) {
                          if (index == playerScores.length) {
                            return DataRow(
                              cells: [
                                for (int i = 0; i < playerNames.length; i++)
                                  DataCell(
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Total: ${playerScores.fold(0, (sum, list) => sum + (list[i]))}',
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          } else {
                            List<DataCell> cells = [];
                            for (int i = 0; i < playerNames.length; i++) {
                              cells.add(DataCell(
                                Align(
                                  alignment: Alignment.center,
                                  child: Text('${playerScores[index][i]}'),
                                ),
                              ));
                            }
                            return DataRow(cells: cells);
                          }
                        },
                      )
                    : [
                        DataRow(
                          cells: List.generate(
                            playerNames.length,
                            (index) => const DataCell(
                              Align(
                                alignment: Alignment.center,
                                child: Text(''),
                              ),
                            ),
                          ),
                        ),
                      ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
