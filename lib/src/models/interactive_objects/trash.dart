import 'package:bonfire/bonfire.dart';

class Trash extends GameDecoration with Sensor{
  final void Function (bool isNearby) onPlayerProximity;
  
  Trash(Vector2 position, {required this.onPlayerProximity})
    : super.withSprite(
        sprite: Sprite.load('trash.png'), // Load the trash can sprite
        position: position, // Set the position on the map
        size: Vector2(32, 32), // Set the size of the trash can
      );
 
  @override
  void update(double dt){
    super.update(dt);

    if(gameRef.player != null){
      double distanceToPlayer = this.position.distanceTo(gameRef.player!.position);

      if (distanceToPlayer < 10) {
          onPlayerProximity(true);
          
        }else{
          onPlayerProximity(false);
          
        }
    }
  }
  

}