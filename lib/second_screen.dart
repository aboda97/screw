import 'package:flutter/material.dart';
import 'package:screw_app/add_score_to_bottom_sheet.dart';
import 'package:screw_app/app_constants.dart';
import 'package:screw_app/dash_board_screen.dart';
import 'package:screw_app/models/player_score.dart';

/*
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
  List<ScoreTable> scoreTables = [];

  Future<void> showSaveConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.kAppBarColor,
          title: const Center(
            child: Text(
              'تأكيد الحفظ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          content: const Text('هل أنت متأكد من حفظ البيانات؟'),
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.kBackgroundTableHead,
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('لا'),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.kLoserPlayerColor,
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DashBoardScreen(
                            playerScores: scoreTables
                                .map((table) => table.playerScores)
                                .expand((scores) =>
                                    scores) // Flatten the list of lists
                                .toList(),
                            playerNames: widget.playerNames,
                          ),
                        ),
                      );
                    },
                    child: const Text('نعم'),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void addScore(List<int> scores) {
    setState(() {
      scoreTables.last.playerScores.add(scores);
    });
  }

  void removeLastRound() {
    setState(() {
      if (scoreTables.isNotEmpty && scoreTables.last.playerScores.isNotEmpty) {
        scoreTables.last.playerScores.removeLast();
      }
    });
  }

  void doubleScores(List<int> scores) {
    setState(() {
      scoreTables.last.playerScores
          .add(scores.map((score) => score * 2).toList());
    });
  }

  void clearScores() {
    setState(() {
      scoreTables.clear();
    });
  }

  void addTable(List<int> scores) {
    final newTable = ScoreTable(
      playerScores: [scores],
      playerNames: widget.playerNames,
    );

    setState(() {
      scoreTables.add(newTable);
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

    addTable([]); // Initialize an empty table when adding a new score
  }

  Widget buildTable(ScoreTable scoreTable) {
    return SingleChildScrollView(
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
            for (int i = 0; i < widget.numberOfPlayers; i++)
              DataColumn(
                label: Align(
                  alignment: Alignment.center,
                  child: Text(scoreTable.playerNames[i]),
                ),
              ),
          ],
          rows: scoreTable.playerScores.isNotEmpty
              ? List.generate(
                  scoreTable.playerScores.length + 1,
                  (index) {
                    if (index == scoreTable.playerScores.length) {
                      return DataRow(
                        cells: [
                          for (int i = 0; i < widget.numberOfPlayers; i++)
                            DataCell(
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Total: ${scoreTable.playerScores.fold(0, (sum, list) => sum + (list[i]))}',
                                ),
                              ),
                            ),
                        ],
                      );
                    } else {
                      List<DataCell> cells = [];
                      for (int i = 0; i < widget.numberOfPlayers; i++) {
                        cells.add(DataCell(
                          Align(
                            alignment: Alignment.center,
                            child: Text('${scoreTable.playerScores[index][i]}'),
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
            onPressed: () {
              showSaveConfirmationDialog();
            },
            icon: const Icon(
              Icons.save_alt_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
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
            child: ListView.builder(
              itemCount: scoreTables.length,
              itemBuilder: (context, index) {
                return buildTable(scoreTables[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:screw_app/add_score_to_bottom_sheet.dart';
import 'package:screw_app/app_constants.dart';
import 'package:screw_app/dash_board_screen.dart';
import 'package:screw_app/models/player.dart';

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

//-------- Save data
  void saveDataToHive(List<List<int>> scores, List<String> names) {
    for (int rowIndex = 0; rowIndex < scores.length; rowIndex++) {
      final List<int> rowScores = scores[rowIndex];
      for (int colIndex = 0; colIndex < names.length; colIndex++) {
        final player = Player(names[colIndex], rowScores[colIndex]);
        scoresBox.add(player);
      }
    }
  }

//--------Show Dialog and move to dashboard screen
  Future<void> showSaveConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.kAppBarColor,
          title: const Center(
            child: Text(
              'تأكيد الحفظ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          content: const Text('هل أنت متأكد من حفظ البيانات؟'),
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: AppColor.kBackgroundTableHead,
                      borderRadius: BorderRadius.circular(
                        12,
                      )),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('لا'),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColor.kLoserPlayerColor,
                      borderRadius: BorderRadius.circular(
                        12,
                      )),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DashBoardScreen(
                            playerScores: playerScores,
                            playerNames: widget.playerNames,
                          ),
                        ),
                      );
                      saveDataToHive(playerScores, widget.playerNames);
                    },
                    child: const Text('نعم'),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

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
                  (index) => const DataCell(
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
            onPressed: () {
              showSaveConfirmationDialog();
            },
            icon: const Icon(
              Icons.save_alt_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
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
