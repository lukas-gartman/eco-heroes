import 'dart:math' as math;

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import '../../models/players/eco_hero_player.dart';

class GamePage extends StatelessWidget {
  final double tileSize = 16;

  const GamePage({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double maxSize = math.max(size.width, size.height);
    return BonfireWidget(
      playerControllers: [
        Joystick(directional: JoystickDirectional()),
      ],
      cameraConfig: CameraConfig(zoom: maxSize / (tileSize * 20)),
      map: WorldMapByTiled(
        WorldMapReader.fromAsset('eco-heroes.tmj'),
        forceTileSize: Vector2.all(tileSize),
      ),
      player: EcoHeroPlayer(Vector2(40, 40)),
    );
  }
}