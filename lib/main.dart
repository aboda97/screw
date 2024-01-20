import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screw_app/app_constants.dart';
import 'package:screw_app/first_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:screw_app/models/player.dart';
import 'package:screw_app/second_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PlayerAdapter());
  await Hive.openBox<Player>('scoresBox');

  List<List<int>> initialPlayerScores = [];
  List<String> initialPlayerNames = [];

  var scoresBox = Hive.box<Player>('scoresBox');
  Set<String> uniqueNames = Set<String>();

  for (var i = 0; i < scoresBox.length; i++) {
    var player = scoresBox.getAt(i);
    if (uniqueNames.add(player!.name)) {
      // Add the name to the set only if it's not already present
      initialPlayerScores.add([player.score]);
      initialPlayerNames.add(player.name);
    }
  }

  runApp(MyApp(
    initialPlayerScores: initialPlayerScores,
    initialPlayerNames: initialPlayerNames,
  ));
}

class MyApp extends StatefulWidget {
  final List<List<int>> initialPlayerScores;
  final List<String> initialPlayerNames;
  const MyApp({
    required this.initialPlayerScores,
    required this.initialPlayerNames,
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<List<int>> playerScores = [];
  int numberOfPlayers = 2;
  List<String> playerNames = [];

  @override
  void initState() {
    super.initState();
    playerScores = widget.initialPlayerScores;
    playerNames = widget.initialPlayerNames;
    numberOfPlayers = widget.initialPlayerNames.length;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColor.kPrimaryColor,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: AppColor.kPrimaryColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColor.kAppBarColor,
            centerTitle: true,
            elevation: 5,
            shadowColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          textTheme: GoogleFonts.alexandriaTextTheme(
              ThemeData.dark(useMaterial3: true).textTheme),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
          )),
      title: 'Screw',
      home: SocreBoxHasData
          ? ScoreBoard(
              numberOfPlayers: numberOfPlayers,
              playerNames: playerNames,
              playerScores: playerScores,
            )
          : const HomePage(),
    );
  }
}
