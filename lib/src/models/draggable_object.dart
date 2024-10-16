import 'game_object.dart';

abstract class DraggableObject extends GameObject {
  DraggableObject(super.pos, super.size);
  
  void onStartDrag();
  void onDragUpdate();
  void onEndDrag();
}
