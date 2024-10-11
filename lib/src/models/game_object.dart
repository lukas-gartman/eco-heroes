import 'package:bonfire/bonfire.dart';

abstract class GameObject {
  Vector2 pos;
  Vector2 size;
   
  GameObject(this.pos, this.size);

  void render(Canvas canvas);
}