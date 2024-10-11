import 'dart:ui';
import 'game_object.dart';

abstract class MiniGame {
  final List<GameObject> gameObjects = [];

  void update(double dt);
  void render(Canvas canvas);
  void start();
  bool isComplete();
  
  void addGameObject(GameObject gameObject) {
    gameObjects.add(gameObject);
  }

  void removeGameObject(GameObject gameObject) {
    gameObjects.remove(gameObject);
  }
}