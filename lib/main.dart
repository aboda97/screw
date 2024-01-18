import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screw_app/app_constants.dart';
import 'package:screw_app/first_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:screw_app/models/player.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PlayerAdapter());
  scoresBox = await Hive.openBox<Player>('scoresBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const HomePage(),
    );
  }
}
