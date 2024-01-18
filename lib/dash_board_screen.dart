import 'package:flutter/material.dart';
import 'package:screw_app/app_constants.dart';

class DashBoardScreen extends StatefulWidget {
  final List<List<int>> playerScores;
  final List<String> playerNames;

  const DashBoardScreen({
    Key? key,
    required this.playerScores,
    required this.playerNames,
  }) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  List<List<int>> get playerScores => widget.playerScores;
  List<String> get playerNames => widget.playerNames;
  void clearDataTable() {
    setState(() {
      playerScores.clear();
      playerNames.clear();
    });
  }

  // void saveDataToHive() {
  //   for (int i = 0; i < playerNames.length; i++) {
  //     final player = Player(
  //         playerNames[i], playerScores.fold(0, (sum, list) => sum + (list[i])));
  //     scoresBox.add(player);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: playerNames.isEmpty && playerScores.isEmpty
          ? Container()
          : ListView(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
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
                          for (int i = 0; i < widget.playerNames.length; i++)
                            DataColumn(
                              label: Align(
                                alignment: Alignment.center,
                                child: Text(widget.playerNames[i]),
                              ),
                            ),
                        ],
                        rows: widget.playerScores.isNotEmpty
                            ? List.generate(
                                widget.playerScores.length + 1,
                                (index) {
                                  if (index == widget.playerScores.length) {
                                    return DataRow(
                                      cells: [
                                        for (int i = 0;
                                            i < widget.playerNames.length;
                                            i++)
                                          DataCell(
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Total: ${widget.playerScores.fold(0, (sum, list) => sum + (list[i]))}',
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  } else {
                                    List<DataCell> cells = [];
                                    for (int i = 0;
                                        i < widget.playerNames.length;
                                        i++) {
                                      cells.add(DataCell(
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                              '${widget.playerScores[index][i]}'),
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
                                    widget.playerNames.length,
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
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColor.kLoserPlayerColor),
                  ),
                  onPressed: () {
                    clearDataTable();

                    ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    );
                  },
                  child: const Text(
                    'حذف',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ]),
    );
  }
}
