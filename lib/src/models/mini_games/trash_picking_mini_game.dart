import 'dart:math';
import 'package:flutter/widgets.dart';

import '../dialog.dart';
import '../interactive_objects/trash.dart';
import '../mini_game.dart';
import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/src/models/proximity_checker.dart';

class TrashPickingMiniGame extends MiniGame {
  static const double tileSize = 16;
  static const double mapWidth = 320;
  static const double mapHeight = 320;
  static const int numberOfTrashCans = 5;

  late List<Trash> trashCans;
  final double proximityRange = 40;
  bool isCompleted = false;

  TrashPickingMiniGame(super.onCompleted);

  @override
  List<GameObject> get objects => trashCans;

  @override
  GameMap get map => WorldMapByTiled(WorldMapReader.fromAsset('eco-heroes.tmj'));

  @override
  void start() {
    trashCans = generateRandomTrashCans(numberOfTrashCans);
    super.proximityChecker = ProximityChecker(
      objects: trashCans,
      proximityRange: proximityRange,
      inProximity: ValueNotifier(false), // Initialize the button state
    );
    print("Trash picking mini-game started with positions: $trashCans");
  }

  @override
  void update(BuildContext context, Vector2 playerPosition) {
    if (isCompleted) return;
    
    super.proximityChecker.checkProximity(playerPosition); // Call the proximity checker in each update with the player's position
    if (trashCans.isEmpty) {
      isCompleted = true;
      TalkDialog.show(context, GameDialog.trashPickingEndDialog(), onFinish: () => super.onCompleted());
    }
  }

  List<Trash> generateRandomTrashCans(int numberOfTrashCans) {
    final List<Trash> trashList = [];
    final random = Random();

    while (trashList.length < numberOfTrashCans) {
      // Generate a new random position within the bounds of the map
      double x = random.nextDouble() * (mapWidth); // Adjusted to be between 0 and mapWidth (320)
      double y = random.nextDouble() * (mapHeight); // Adjusted to be between 0 and mapHeight (320)
      Vector2 position = Vector2(x, y);
      
      Trash newTrashCan = Trash(position: position);
      trashList.add(newTrashCan);
    }

    return trashList;
  }

  @override
  void removeObject(GameObject object) {
    if (object is Trash) {
      trashCans.remove(object);
    }
  }
}
