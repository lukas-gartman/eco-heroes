import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';

import '../helpers/dialog.dart';
import 'mini_game.dart';
import '../services/proximity_checker.dart';

class NiceLookingForestMiniGame extends MiniGame {
  static const double tileSize = 16;
  static const double mapWidth = 640;
  static const double mapHeight = 640;

  bool isStart = true;
  bool isCompleted = false;

  NiceLookingForestMiniGame({required super.onCompleted, super.cutScenes});

  @override
  GameMap get map => WorldMapByTiled(WorldMapReader.fromAsset('maps/chopped_down_forrest/niceLookingForrest.tmj'), forceTileSize: Vector2.all(tileSize));

  @override
  double get mapZoom => 1.5;

  @override
  List<GameObject> get objects => [];

  @override
  Vector2 get playerStartPosition => Vector2(300, 300);

  @override
  void start() {
    super.proximityChecker = ProximityChecker(
      objects: [],
      proximityRange: 0,
      inProximityWith: ValueNotifier(null),
    );
  }

  @override
  void update(BuildContext context, Vector2 playerPosition) {
    if (isStart) {
      super.update(context, playerPosition);

      isStart = false;
      TalkDialog.show(context, GameDialog.plantingEndDialog(), backgroundColor: Colors.transparent, onFinish: () => super.onCompleted());
      return;
    }
  }

  @override
  void interactWithObject(BuildContext context, GameObject object) { }
}
