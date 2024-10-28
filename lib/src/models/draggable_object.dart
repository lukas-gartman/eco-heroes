import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class DraggableObject extends PositionComponent with DragCallbacks {
  DraggableObject(Vector2 position, Vector2 size) {
    this.position = position;
    this.size = size;
  }

  final Paint _paint = Paint();

  @override
  void render(Canvas canvas) {
    // Render a rectangle that changes color when dragged
    _paint.color = isDragged ? Colors.red : Colors.white;
    canvas.drawRect(size.toRect(), _paint);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta; // Update position as the object is dragged
  }
}
