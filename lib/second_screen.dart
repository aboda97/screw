import 'package:flutter/material.dart';
import 'package:screw_app/add_score_to_bottom_sheet.dart';
import 'package:screw_app/app_constants.dart';

class ScoreBoard extends StatefulWidget {
  final int numberOfPlayers;
  final List<String> playerNames;

  const ScoreBoard({
    Key? key,
    required this.numberOfPlayers,
    required this.playerNames,
  }) : super(key: key);

  @override
  State<ScoreBoard> createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  List<List<int>> playerScores = [];

  void addScore(List<int> scores) {
    setState(() {
      playerScores.add(scores);
    });
  }

  void removeLastRound() {
    setState(() {
      if (playerScores.isNotEmpty) {
        playerScores.removeLast();
      }
    });
  }

  void doubleScores(List<int> scores) {
    setState(() {
      playerScores.add(scores.map((score) => score * 2).toList());
      // for (int i = 0; i < playerScores.length; i++) {
      //   for (int j = 0; j < widget.numberOfPlayers; j++) {
      //     playerScores[i][j] *= 2;
      //   }
      // }
    });
  }

  void clearScores() {
    setState(() {
      playerScores.clear();
    });
  }

  void handleAddScore() async {
    await showModalBottomSheet(
      backgroundColor: AppColor.kPrimaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      context: context,
      builder: (context) {
        return AddToModalBottomSheet(
          numberOfPlayers: widget.numberOfPlayers,
          playerNames: widget.playerNames,
          addScoreCallback: addScore,
          removeLastRoundCallback: removeLastRound,
          doubleScoresCallback: doubleScores,
        );
      },
    );
  }

  // void handleResetScores() {
  //   setState(() {
  //     playerScores.clear();
  //   });
  // }

//------------- Basic Func
  // Widget buildDataTable() {
  //   return DataTable(
  //     headingTextStyle: const TextStyle(
  //       fontWeight: FontWeight.bold,
  //       color: Colors.white,
  //       fontSize: 16,
  //     ),
  //     dataTextStyle: const TextStyle(
  //       color: Colors.white,
  //       fontSize: 16,
  //     ),
  //     headingRowColor: MaterialStateColor.resolveWith((states) =>
  //         AppColor.kBackgroundTableHead), // Red color for heading row
  //     border: TableBorder.all(
  //         color: Colors.white), // White border color for the entire DataTable
  //     columns: [
  //       for (int i = 0; i < widget.numberOfPlayers; i++)
  //         DataColumn(label: Text(widget.playerNames[i])),
  //     ],
  //     rows: playerScores.isNotEmpty
  //         ? List.generate(
  //             playerScores.length + 1, // +1 for the total row
  //             (index) {
  //               if (index == playerScores.length) {
  //                 return DataRow(
  //                   cells: [
  //                     for (int i = 0; i < widget.numberOfPlayers; i++)
  //                       DataCell(
  //                         Text(
  //                           '${playerScores.fold(0, (sum, list) => sum + (list[i]))}',
  //                         ),
  //                       ),
  //                   ],
  //                 );
  //               } else {
  //                 List<DataCell> cells = [];
  //                 for (int i = 0; i < widget.numberOfPlayers; i++) {
  //                   cells.add(DataCell(Text('${playerScores[index][i]}')));
  //                 }
  //                 return DataRow(cells: cells);
  //               }
  //             },
  //           )
  //         : [
  //             DataRow(
  //               cells: List.generate(
  //                 widget.numberOfPlayers,
  //                 (index) => DataCell(
  //                   Text(''),
  //                 ),
  //               ),
  //             ),
  //           ],
  //   );
  // }

//-----------------Green Color
  // Widget buildDataTable() {
  //   return DataTable(
  //     headingTextStyle: const TextStyle(
  //       fontWeight: FontWeight.bold,
  //       color: Colors.white,
  //       fontSize: 16,
  //     ),
  //     dataTextStyle: const TextStyle(
  //       color: Colors.white,
  //       fontSize: 16,
  //     ),
  //     headingRowColor: MaterialStateColor.resolveWith(
  //         (states) => AppColor.kBackgroundTableHead),
  //     border: TableBorder.all(color: Colors.white),
  //     columns: [
  //       for (int i = 0; i < widget.numberOfPlayers; i++)
  //         DataColumn(label: Text(widget.playerNames[i])),
  //     ],
  //     rows: playerScores.isNotEmpty
  //         ? List.generate(
  //             playerScores.length + 1,
  //             (index) {
  //               if (index == playerScores.length) {
  //                 return DataRow(
  //                   cells: [
  //                     for (int i = 0; i < widget.numberOfPlayers; i++)
  //                       DataCell(
  //                         Text(
  //                           '${playerScores.fold(0, (sum, list) => sum + (list[i]))}',
  //                         ),
  //                       ),
  //                   ],
  //                 );
  //               } else {
  //                 int minScore =
  //                     playerScores[index].reduce((a, b) => a < b ? a : b);
  //                 List<DataCell> cells = [];
  //                 for (int i = 0; i < widget.numberOfPlayers; i++) {
  //                   int score = playerScores[index][i];
  //                   cells.add(DataCell(
  //                     Container(
  //                       // Set green background color for the smallest score
  //                       color: score == minScore ? Colors.green : null,
  //                       child: Text('$score'),
  //                     ),
  //                   ));
  //                 }
  //                 return DataRow(cells: cells);
  //               }
  //             },
  //           )
  //         : [
  //             DataRow(
  //               cells: List.generate(
  //                 widget.numberOfPlayers,
  //                 (index) => const DataCell(
  //                   Text(''),
  //                 ),
  //               ),
  //             ),
  //           ],
  //   );
  // }

  Widget buildDataTable() {
    return DataTable(
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
        for (int i = 0; i < widget.numberOfPlayers; i++)
          DataColumn(
            label: Align(
              alignment: Alignment.center,
              child: Text(widget.playerNames[i]),
            ),
          ),
      ],
      rows: playerScores.isNotEmpty
          ? List.generate(
              playerScores.length + 1, // +1 for the total row
              (index) {
                if (index == playerScores.length) {
                  // Last row for total
                  return DataRow(
                    cells: [
                      for (int i = 0; i < widget.numberOfPlayers; i++)
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
                  // Regular data rows
                  List<DataCell> cells = [];
                  for (int i = 0; i < widget.numberOfPlayers; i++) {
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
                  widget.numberOfPlayers,
                  (index) => DataCell(
                    Align(
                      alignment: Alignment.center,
                      child: Text(''),
                    ),
                  ),
                ),
              ),
            ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'فلسطين حرة',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: handleAddScore,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: clearScores,
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 18,
          ),
          const Center(
            child: Text(
              'Swipe to See Other Results',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: buildDataTable(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
