import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/src/models/interactive_object.dart';

class Trash extends InteractiveObject {
  Trash({required super.position})
    : super(size: Vector2(32, 32), sprite: Sprite.load('trash.png'));

  @override
  void interact() {
    print(this);
    removeFromParent();
  }
}
