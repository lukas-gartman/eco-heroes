import '../interactive_objects/trash.dart';
import '../mini_game.dart';

import 'package:bonfire/bonfire.dart';

class TrashPickingMiniGame extends MiniGame {
  int _trashPickedUpCount = 0;
  int _totalTrashCount = 0;

  @override
  void render(Canvas canvas) {
    // TODO: implement render
  }

  @override
  void update(double dt) {
    // TODO: implement update
  }

  @override
  void start() {
    for (int i = 0; i < 10; i++) {
      Vector2 pos = Vector2(10.0 + i, 10);
      Vector2 size = Vector2(2.0, 2.0);

      addGameObject(Trash(pos, size));
      _totalTrashCount++;
    }
  }

  @override
  bool isComplete() {
    // Check if all trash has been picked up or time has run out
    return _trashPickedUpCount >= _totalTrashCount;
  }
}