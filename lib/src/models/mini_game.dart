import 'package:bonfire/bonfire.dart';
import 'package:flutter/widgets.dart';

import 'proximity_checker.dart';

abstract class MiniGame {
  final void Function() onCompleted;
  late final ProximityChecker proximityChecker;

  List<GameObject> get objects;
  GameMap get map;
  List<Rect> get collisionAreas => [];

  MiniGame(this.onCompleted);

  void start();
  void update(BuildContext context, Vector2 playerPosition);
  void interactWithObject(BuildContext context, GameObject object);
}