import 'package:bonfire/bonfire.dart';

import 'interactive_object.dart';
import '../enums/trash_type.dart';
import '../enums/interaction_type.dart';

abstract class Trash extends InteractiveObject {
  final TrashType trashType;
  final String spriteSrc;
  @override
  InteractionType get interactionType => InteractionType.clean;

  Trash({required this.trashType, required this.spriteSrc, required super.position})
    : super(size: Vector2(32, 32), sprite: Sprite.load(spriteSrc));

  @override
  void interact() {
    print(this);
    removeFromParent();
  }
}
