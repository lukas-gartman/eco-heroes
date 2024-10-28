import 'package:bonfire/bonfire.dart';

class EcoHeroPlayer extends SimplePlayer {
  List<Rect>? collisionAreas = [];
  Vector2 previousPosition = Vector2.zero();

  EcoHeroPlayer(Vector2 position, { this.collisionAreas })
      : super(
          position: position, 
          size: Vector2.all(32),
          speed: 150,
          animation: PlayerSpriteSheet.simpleDirectionAnimation,
      );

  Vector2 getPosition() {
    return position;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (position.x < 0) position.x = 0;
    if (position.y < 0) position.y = 0;
    if (position.x > gameRef.map.getMapSize().x - width)  position.x = gameRef.map.getMapSize().x - width;
    if (position.y > gameRef.map.getMapSize().y - height) position.y = gameRef.map.getMapSize().y - height;

    if (collisionAreas != null) {
      for (var area in collisionAreas!) {
        if (area.containsPoint(position)) {
          position = previousPosition;
          break;
        }
      }
    }

    previousPosition = position.clone();
  }
}

class PlayerSpriteSheet {
 
  static Future<SpriteAnimation> get idleRight => SpriteAnimation.load(
        "player/eco_hero_idle.png",
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );
    static Future<SpriteAnimation> get idleLeft => SpriteAnimation.load(
        "player/eco_hero_idle.png",
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  static Future<SpriteAnimation> get runRight => SpriteAnimation.load(
        "player/eco_hero_run_right.png",
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );
  static Future<SpriteAnimation> get runLeft => SpriteAnimation.load(
        "player/eco_hero_run_left.png",
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );
  static Future<SpriteAnimation> get runUp => SpriteAnimation.load(
        "player/eco_hero_run_up.png",
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );
  static Future<SpriteAnimation> get runDown => SpriteAnimation.load(
        "player/eco_hero_run_down.png",
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  static SimpleDirectionAnimation get simpleDirectionAnimation =>
      SimpleDirectionAnimation(
        idleRight: idleRight,
        idleLeft: idleLeft,
        runRight: runRight,
        runLeft: runLeft,
        runUp: runUp,
        runDown: runDown,
      );
}