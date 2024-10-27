import 'package:bonfire/bonfire.dart';

import '../enums/interaction_type.dart';
import '../interactive_object.dart';

class RecyclingBins extends InteractiveObject {
  @override
  InteractionType get interactionType => InteractionType.recycle;

  RecyclingBins({required super.position})
    : super(size: Vector2(54, 29), sprite: Sprite.load('bins.png')); // original 541x293

  @override
  void interact() {
    print(this);
  }
}