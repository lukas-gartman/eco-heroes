import 'game_object.dart';

abstract class InteractiveObject extends GameObject {
  InteractiveObject(super.pos, super.size);
  
  void onInteract();
}