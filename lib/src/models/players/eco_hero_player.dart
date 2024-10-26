import 'package:bonfire/bonfire.dart';

class EcoHeroPlayer extends SimplePlayer {

  EcoHeroPlayer(Vector2 position)
      : super(
          position: position, 
          size: Vector2.all(32),
          speed: 200,
          animation: PlayerSpriteSheet.simpleDirectionAnimation,
      );

   Vector2 getPosition(){
      print(position);
      return position;
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
