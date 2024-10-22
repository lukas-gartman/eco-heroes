import 'dart:ui';
import 'package:bonfire/bonfire.dart';

import 'game_object.dart';

abstract class MiniGame {
  void start();
  void end();
  void update(Vector2 playerPosition);
}