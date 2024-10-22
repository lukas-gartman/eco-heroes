import 'dart:math';
import 'package:flutter/widgets.dart';

import '../interactive_objects/trash.dart';
import '../mini_game.dart';
import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/src/models/proximity_checker.dart';
import 'package:bonfire/bonfire.dart';

class TrashPickingMiniGame extends MiniGame {
  final int numberOfTrashCans;
  final double mapWidth;
  final double mapHeight;
  final double tileSize;
  final double minDistance; // Minimum distance between trash cans
  late List<Trash> trashCans;
  late ProximityChecker proximityChecker; // Proximity checker instance
  final double proximityRange = 50; // Define your proximity range

  TrashPickingMiniGame({
    required this.numberOfTrashCans,
    required this.mapWidth,
    required this.mapHeight,
    required this.tileSize,
    this.minDistance = 2,
  });

  @override
  void start() {
    trashCans = generateRandomTrashCans();
    proximityChecker = ProximityChecker(
      trashCans: trashCans,
      proximityRange: proximityRange,
      showInteractButton: ValueNotifier(false), // Initialize the button state
    );
    // Here you can add logic to initialize the game, such as spawning trash cans
    print("Trash picking mini-game started with positions: $trashCans");
  }

  @override
  void update(Vector2 playerPosition) {
    // Call the proximity checker in each update with the player's position
    proximityChecker.checkProximity(playerPosition);
  }

  @override
  void end() {
    // TODO: implement end
  }

  List<Trash> generateRandomTrashCans() {
    final List<Trash> trashList = [];
    final random = Random();

    while (trashList.length < numberOfTrashCans) {
      // Generate a new random position within the bounds of the map
      double x = random.nextDouble() * (mapWidth); // Adjusted to be between 0 and mapWidth (320)
      double y = random.nextDouble() * (mapHeight); // Adjusted to be between 0 and mapHeight (320)
      Vector2 position = Vector2(x, y);
      
      Trash newTrashCan = Trash(position);
      
      trashList.add(newTrashCan); // Add valid position
    }

    return trashList;
  }
}
