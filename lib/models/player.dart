import 'package:hive/hive.dart';

part 'player.g.dart';

@HiveType(typeId: 0)
class Player extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late int score;

  Player(this.name, this.score);
}
