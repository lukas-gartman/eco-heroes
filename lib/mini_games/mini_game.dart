import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/widgets/cut_scene.dart';
import 'package:flutter/material.dart';

import '../services/proximity_checker.dart';

abstract class MiniGame {
  final void Function() onCompleted;
  final CutScene? cutScene;
  late final ProximityChecker proximityChecker;

  List<GameObject> get objects;
  GameMap get map;
  double get mapZoom => 2.0;
  Color get lighting => Colors.transparent;
  Vector2 get playerStartPosition => Vector2(40, 40);
  List<Rect> get collisionAreas => [];

  MiniGame({required this.onCompleted, this.cutScene});

  void start();
  void update(BuildContext context, Vector2 playerPosition) {
    if (cutScene != null) {
      Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => cutScene!),
        );
      });
    }
  }
  void interactWithObject(BuildContext context, GameObject object);
}