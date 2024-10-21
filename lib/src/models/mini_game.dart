import 'dart:ui';
import 'game_object.dart';

abstract class MiniGame {
  void start();
  void end();
  void update();
}