import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int selectedPlayers = 2; // Default value
  List<TextEditingController> nameControllers = [];

  @override
  void initState() {
    super.initState();
    nameControllers = List.generate(
      selectedPlayers,
      (index) => TextEditingController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screw'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Swipe to choose the number of players'),
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  int numberOfPlayers = index + 2;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPlayers = numberOfPlayers;
                        nameControllers = List.generate(
                          selectedPlayers,
                          (index) => TextEditingController(),
                        );
                      });
                    },
                    child: Container(
                      width: 50,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedPlayers == numberOfPlayers
                            ? Colors.blue
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '$numberOfPlayers',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text('Please enter names'),
            Column(
              children: List.generate(
                selectedPlayers,
                (index) => TextFormField(
                  controller: nameControllers[index],
                  decoration: InputDecoration(
                    labelText: 'Player ${index + 1}',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the second screen with the selected players and names
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondScreen(
                      numberOfPlayers: selectedPlayers,
                      playerNames: nameControllers
                          .map((controller) => controller.text)
                          .toList(),
                    ),
                  ),
                );
              },
              child: Text('Go to the scoreboard screen'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  final int numberOfPlayers;
  final List<String> playerNames;

  SecondScreen({required this.numberOfPlayers, required this.playerNames});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
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

  void doubleScores() {
    setState(() {
      for (int i = 0; i < playerScores.length; i++) {
        for (int j = 0; j < widget.numberOfPlayers; j++) {
          playerScores[i][j] *= 2;
        }
      }
    });
  }

  void clearScores() {
    setState(() {
      playerScores.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screw'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return AddScoreBottomSheet(
                    numberOfPlayers: widget.numberOfPlayers,
                    playerNames: widget.playerNames,
                    addScoreCallback: addScore,
                    removeLastRoundCallback: removeLastRound,
                    doubleScoresCallback: doubleScores,
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: clearScores,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text('Swipe to see other results'),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: [
                  for (int i = 0; i < widget.numberOfPlayers; i++)
                    DataColumn(label: Text(widget.playerNames[i])),
                ],
                rows: List.generate(
                  playerScores.length + 1, // +1 for the total row
                  (index) {
                    if (index == playerScores.length) {
                      return DataRow(
                        cells: [
                          for (int i = 0; i < widget.numberOfPlayers; i++)
                            DataCell(
                              Text(
                                '${playerScores.isNotEmpty ? playerScores.fold(0, (sum, list) => sum + list[i]) : 0}',
                              ),
                            ),
                        ],
                      );
                    } else {
                      List<DataCell> cells = [];
                      for (int i = 0; i < widget.numberOfPlayers; i++) {
                        cells.add(DataCell(Text('${playerScores[index][i]}')));
                      }
                      return DataRow(cells: cells);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddScoreBottomSheet extends StatefulWidget {
  final int numberOfPlayers;
  final List<String> playerNames;
  final Function(List<int>) addScoreCallback;
  final VoidCallback removeLastRoundCallback;
  final VoidCallback doubleScoresCallback;

  AddScoreBottomSheet({
    required this.numberOfPlayers,
    required this.playerNames,
    required this.addScoreCallback,
    required this.removeLastRoundCallback,
    required this.doubleScoresCallback,
  });

  @override
  _AddScoreBottomSheetState createState() => _AddScoreBottomSheetState();
}

class _AddScoreBottomSheetState extends State<AddScoreBottomSheet> {
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.numberOfPlayers,
      (index) => TextEditingController(),
    );
  }

  void doubleScores() {
    setState(() {
      for (int i = 0; i < controllers.length; i++) {
        int currentScore = int.tryParse(controllers[i].text) ?? 0;
        controllers[i].text = (currentScore * 2).toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Add scores'),
          for (int i = 0; i < widget.numberOfPlayers; i++)
            TextFormField(
              controller: controllers[i],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: widget.playerNames[i],
              ),
            ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  List<int> scores = controllers
                      .map((controller) => int.tryParse(controller.text) ?? 0)
                      .toList();
                  widget.addScoreCallback(scores);
                  Navigator.pop(context);
                },
                child: Text('Add'),
              ),
              ElevatedButton(
                onPressed: widget.removeLastRoundCallback,
                child: Text('إحذف اخر جولة'),
              ),
              ElevatedButton(
                onPressed: doubleScores,
                child: Text('Double Scores'),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              //   child: Text('Cancel'),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
