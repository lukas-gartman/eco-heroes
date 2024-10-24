import 'dart:math';
import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/src/models/interactive_object.dart';

class SquirrelNPC extends InteractiveObject {
  final double movementRange = 10.0; // Range of movement
  final double movementSpeed = 0.5;  // Speed of movement
  late Vector2 originalPosition;     // Store the original spawn position
  bool movingLeft = true;            // Control movement direction
  final Random random = Random();    // Random instance for random behavior

  SquirrelNPC({required Vector2 position}) : super(
      position: position,
      size: Vector2(32, 32),
      sprite: Sprite.load('squirrel.png')) {
    originalPosition = position.clone(); // Store initial spawn position
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Random movement logic
    _randomMovement(dt);
  }

  void _randomMovement(double dt) {
    // Calculate movement direction
    if (movingLeft) {
      // Move left within the range
      position.x -= movementSpeed;
      if (position.x <= originalPosition.x - movementRange) {
        movingLeft = false; // Switch to moving right
      }
    } else {
      // Move right within the range
      position.x += movementSpeed;
      if (position.x >= originalPosition.x + movementRange) {
        movingLeft = true; // Switch to moving left
      }
    }

    // You can also add some random vertical movement if desired:
    // double verticalMovement = (random.nextDouble() * 2 - 1) * movementSpeed;
    // position.y += verticalMovement;
  }

  @override
  void interact() {
    // Interaction logic for talking to the squirrel
    print("Interacting with the squirrel");
  }
}
