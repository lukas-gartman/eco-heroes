import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/src/models/enums/interaction_type.dart';
import 'package:eco_heroes/src/models/interactive_object.dart';

class Trash extends InteractiveObject {
  @override
  InteractionType get interactionType => InteractionType.clean;

  Trash({required super.position})
    : super(size: Vector2(32, 32), sprite: Sprite.load('trash.png'));

  @override
  void interact() {
    print(this);
    removeFromParent();
  }
}
