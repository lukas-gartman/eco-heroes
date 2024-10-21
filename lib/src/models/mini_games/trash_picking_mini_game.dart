import 'dart:math';
import '../interactive_objects/trash.dart';
import '../mini_game.dart';
import 'package:bonfire/bonfire.dart';

class TrashPickingMiniGame extends MiniGame {
  final int numberOfTrashCans;
  final double mapWidth;
  final double mapHeight;
  final double tileSize;
  final double minDistance; // Minimum distance between trash cans
  late List<Vector2> trashPositions;

  TrashPickingMiniGame({
    required this.numberOfTrashCans,
    required this.mapWidth,
    required this.mapHeight,
    required this.tileSize,
    this.minDistance = 2, // Default minimum distance
  });

  @override
  void start() {
    trashPositions = generateRandomPositions();
    // Here you can add logic to initialize the game, such as spawning trash cans
    print("Trash picking mini-game started with positions: $trashPositions");
  }

  @override
  void update() {
    // TODO: implement update
  }

  @override
  void end() {
    // TODO: implement end
  }

  List<Vector2> generateRandomPositions() {
    final List<Vector2> positions = [];
    final random = Random();

    while (positions.length < numberOfTrashCans) {
      // Generate a new random position within the bounds of the map
      double x = random.nextDouble() * (mapWidth); // Adjusted to be between 0 and mapWidth (320)
      double y = random.nextDouble() * (mapHeight); // Adjusted to be between 0 and mapHeight (320)
      Vector2 newPosition = Vector2(x, y);

      // Check if the new position is valid before adding it
      if (_isPositionValid(newPosition, positions)) {
        positions.add(newPosition); // Add valid position
      }
      // If the position is invalid, the loop continues and a new position is generated
    }

    return positions;
  }

  // Check if the new position is valid
  bool _isPositionValid(Vector2 newPosition, List<Vector2> existingPositions) {
    for (Vector2 position in existingPositions) {
      // Check the distance to existing positions
      if ((newPosition - position).length < minDistance) {
        return false; // Too close to an existing position
      }
    }
    return true; // Valid position
  }
}
