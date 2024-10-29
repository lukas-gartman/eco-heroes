import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/enums/interaction_type.dart';
import 'package:eco_heroes/interactive_objects/interactive_object.dart';

class Hole extends InteractiveObject {
  @override
  InteractionType get interactionType => InteractionType.plant;

  Hole({required super.position})
      : super(size: Vector2(32, 32), sprite: Sprite.load('hole.png'));

  Future<void> changeSprite() async {
    // Load the new sprite
    sprite = await Sprite.load('sprout.png');
  }

  @override
  void interact() {
    changeSprite(); // Replace with your new sprite path
  }
}
