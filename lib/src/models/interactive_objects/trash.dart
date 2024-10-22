import 'package:bonfire/bonfire.dart';


class Trash extends GameDecoration with Sensor {
  
  Trash(Vector2 position,)
      : super.withSprite(
          sprite: Sprite.load('trash.png'), // Load the trash can sprite
          position: position, // Set the position on the map
          size: Vector2(32, 32), // Set the size of the trash can
        );

  @override
  void update(double dt) {
    super.update(dt);
  }

  // Method to handle interaction and print information
  void interact() {
    print(this);
    removeFromParent();
  }


  
}
