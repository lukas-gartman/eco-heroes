import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import 'proximity_checker.dart';

abstract class MiniGame {
  final void Function() onCompleted;
  late final ProximityChecker proximityChecker;

  List<GameObject> get objects;
  GameMap get map;
  Color get lighting => Colors.transparent;
  Vector2 get playerStartPosition => Vector2(40, 40);
  List<Rect> get collisionAreas => [];

  MiniGame(this.onCompleted);

  void start();
  void update(BuildContext context, Vector2 playerPosition);
  void interactWithObject(BuildContext context, GameObject object);
}
