import 'package:bonfire/bonfire.dart';

class EcoHeroPlayer extends SimplePlayer {

  EcoHeroPlayer(Vector2 position)
      : super(
          position: position, 
          size: Vector2.all(32),
          speed: 200,
          animation: PlayerSpriteSheet.simpleDirectionAnimation,
      );
}

class PlayerSpriteSheet {
 
  static Future<SpriteAnimation> get idleRight => SpriteAnimation.load(
        "player/knight_idle.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  static Future<SpriteAnimation> get runRight => SpriteAnimation.load(
        "player/knight_run.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  static SimpleDirectionAnimation get simpleDirectionAnimation =>
      SimpleDirectionAnimation(
        idleRight: idleRight,
        runRight: runRight,
      );
}
