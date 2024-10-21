import 'dart:math' as math;
import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'src/models/players/eco_hero_player.dart';
import 'src/models/interactive_objects/trash.dart';
import 'package:eco_heroes/src/models/mini_game.dart'; // Import the abstract class
import 'package:eco_heroes/src/models/mini_games/trash_picking_mini_game.dart'; // Import the mini-game class

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  final double tileSize = 16;
  final double mapWidth = 320; // Set according to your map's width
  final double mapHeight = 320; // Set according to your map's height
  final int numberOfTrashCans = 5;
  ValueNotifier<bool> showInteractButton = ValueNotifier(false);
  late TrashPickingMiniGame miniGame;

  @override
  void initState() {
    super.initState();
    miniGame = TrashPickingMiniGame(
      numberOfTrashCans: numberOfTrashCans,
      mapWidth: mapWidth,
      mapHeight: mapHeight,
      tileSize: tileSize,
    );
    miniGame.start(); // Start the mini-game and generate positions
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Ensure trash positions are generated before accessing them
      if (miniGame.trashPositions.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }

      return Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            BonfireWidget(
              playerControllers: [
                Joystick(directional: JoystickDirectional()),
              ],
              cameraConfig: CameraConfig(
                zoom: math.max(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height,
                ) / (tileSize * 20),
              ),
              map: WorldMapByTiled(
                WorldMapReader.fromAsset('eco-heroes.tmj'),
                forceTileSize: Vector2.all(tileSize),
              ),
              player: EcoHeroPlayer(Vector2(40, 40)),
              components: miniGame.trashPositions.map((position) => Trash(
                position, // Use the generated position
                onPlayerProximity: (bool isNearby) {
                  showInteractButton.value = isNearby;
                },
              )).toList(),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: showInteractButton,
              builder: (context, value, child) {
                return value
                    ? Positioned(
                        bottom: 50,
                        right: 50,
                        child: ElevatedButton(
                          onPressed: _onInteract,
                          child: Text('Interact'),
                        ),
                      )
                    : SizedBox.shrink();
              },
            ),
          ],
        ),
      );
    });
  }

  void _onInteract() {
    print('Player interacted with the trash can!');
  }
}
