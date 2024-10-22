import 'package:bonfire/bonfire.dart';

abstract class MiniGame {
  void start();
  void end();
  void update(Vector2 playerPosition);
}