import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/src/models/interactive_object.dart';

class SquirrelNPC extends InteractiveObject {
  SquirrelNPC({required super.position})
    : super(size: Vector2(32, 32), sprite: Sprite.load('squirrel.png'));

  @override
  void interact() {
    
  }

  
  

}
