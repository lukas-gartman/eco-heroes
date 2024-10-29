import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/enums/interaction_type.dart';

abstract class InteractiveObject extends GameDecoration with Sensor {
  InteractionType get interactionType;
  InteractiveObject({ required super.position, required super.size, required Future<Sprite> super.sprite })
    : super.withSprite();
  
  void interact();
}