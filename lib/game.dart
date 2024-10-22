import 'dart:math' as math;
import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'src/models/players/eco_hero_player.dart';
import 'src/models/interactive_objects/trash.dart';
import 'package:eco_heroes/src/models/mini_game.dart'; // Import the abstract class
import 'package:eco_heroes/src/models/mini_games/trash_picking_mini_game.dart'; // Import the mini-game class
import 'package:eco_heroes/src/models/dialog.dart'; // Import your GameDialog class

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
    _showIntroDialog(); //kommentera ut den här för att slippa intro dialogen
    miniGame = TrashPickingMiniGame(
      numberOfTrashCans: numberOfTrashCans,
      mapWidth: mapWidth,
      mapHeight: mapHeight,
      tileSize: tileSize,
    );
    miniGame.start(); 
    // Start the mini-game and generate positions
  }

  // Method to show introductory dialog
  Future<void> _showIntroDialog() async {
    await Future.delayed(Duration(milliseconds: 500)); // Small delay to ensure the screen loads
    await GameDialog.introDialog(context); // Show the dialog
  }
  
  @override
  Widget build(BuildContext context) {
    // Ensure trash positions are generated before accessing them
    if (miniGame.trashPositions.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }


    // Track the current proximity state of each trash can
    List<bool> proximityStates = List.filled(numberOfTrashCans, false);

    return LayoutBuilder(builder: (context, constraints) {
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
              components: miniGame.trashPositions.asMap().entries.map((entry) {
                int index = entry.key;
                Vector2 position = entry.value;
                return Trash(
                  position, // Use the generated position
                  onPlayerProximity: (bool isNearby) {
                    // Update the individual trash can's proximity state
                    proximityStates[index] = isNearby;

                    // Update the overall button visibility
                    showInteractButton.value = proximityStates.any((state) => state);
                  },
                );
              }).toList(),
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
    print('Player interacted with a trash can!');
    GameDialog.minigameDialog1(context);
  }
}