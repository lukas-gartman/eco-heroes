import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/src/models/enums/interaction_type.dart';
import 'package:eco_heroes/src/models/interactive_object.dart';
import 'package:flutter/widgets.dart';

class Hole extends InteractiveObject {
  @override
  InteractionType get interactionType => InteractionType.clean;

  Hole({required super.position})
      : super(size: Vector2(32, 32), sprite: Sprite.load('trash.png'));

  Future<void> changeSprite() async {
    // Load the new sprite
    sprite = await Sprite.load('planted_tree.png');
  }

  @override
  void interact() {
    changeSprite(); // Replace with your new sprite path
  }
}
