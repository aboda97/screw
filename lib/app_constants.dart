import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:screw_app/models/player.dart';

class AppColor {
  static const kPrimaryColor = Color(0xFF24183e);
  static const kAppBarColor = Color(0xFF382c52);
  static const kActiveNumOfPlayers = Color(0xFFb88ba8);
  static const kNumOfPlayers = Color(0xFF8b4373);
  static const kBorderColor = Color(0xFFd78b33);
  static const kBackgroundTableHead = Color(0xFF65011b);
  static const kLoserPlayerColor = Colors.green;
}

Box<Player> scoresBox = Hive.box<Player>('scoresBox');
bool SocreBoxHasData = scoresBox.isNotEmpty;
