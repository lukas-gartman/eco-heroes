import 'package:bonfire/bonfire.dart';

abstract class InteractiveObject extends GameDecoration with Sensor {
  InteractiveObject({ required super.position, required super.size, required Future<Sprite> super.sprite })
    : super.withSprite();
  
  void interact();
}