import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/enums/interaction_type.dart';
import 'package:eco_heroes/interactive_objects/interactive_object.dart';
import 'package:flame_audio/flame_audio.dart';

class SquirrelNPC extends InteractiveObject with Movement, RandomMovement {
  @override
  InteractionType get interactionType => InteractionType.talk;

  SquirrelNPC({required super.position}) : super(size: Vector2(32, 32), sprite: Sprite.load('squirrel.png'));

  @override
  void update(double dt) {
    super.update(dt);

    runRandomMovement(dt, minDistance: 5, maxDistance: 10);
  }

  @override
  void interact() {
    FlameAudio.play('effects/squirrel.wav');
    print("Interacting with the squirrel");
  }
}
