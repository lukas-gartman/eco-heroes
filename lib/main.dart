import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';

void main() {
  runApp(const EcoHeroes());
}

class EcoHeroes extends StatelessWidget {
  const EcoHeroes({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BonfireWidget(
      playerControllers: [
        Joystick(
          directional: JoystickDirectional(),
        )
      ],
      player: SimplePlayer(
        position: Vector2(100, 100),
        size: Vector2(32, 32),
        animation: SimpleDirectionAnimation(
          idleRight: SpriteAnimation.load(
            'player_idle_right.png',
            SpriteAnimationData.sequenced(
              amount: 1,
              stepTime: 0.1,
              textureSize: Vector2(32, 32),
            ),
          ),
          runRight: SpriteAnimation.load(
            'player_run_right.png',
            SpriteAnimationData.sequenced(
              amount: 4,
              stepTime: 0.1,
              textureSize: Vector2(32, 32),
            ),
          ),
        ),
      ),
      map: WorldMapByTiled(
        WorldMapReader.fromAsset('eco-heroes.tmj'),
      ),
      cameraConfig: CameraConfig(
        moveOnlyMapArea: true,
        zoom: 1.75,
      ),
    );
  }
}
