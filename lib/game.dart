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

  // A single ValueNotifier to track the overall visibility of the interact button
  ValueNotifier<bool> showInteractButton = ValueNotifier(false);
  
  // Store the reference of the closest trash can
  Trash? closestTrashCan;
  
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

      // Track the current proximity state of each trash can
      List<bool> proximityStates = List.filled(numberOfTrashCans, false);

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
                    
                    // Update closest trash can reference
                    if (isNearby) {
                      closestTrashCan = Trash(
                        position, 
                        onPlayerProximity: (val) {},
                        index: index,
                      );
                    } else if (closestTrashCan?.index == index) {
                      closestTrashCan = null; // Reset if player is not near any trash can
                    }
                  },
                  index: index, // Pass index to Trash constructor
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
    // Call the interact method of the closest trash can, if it exists
    // 
    if (closestTrashCan != null) {
      closestTrashCan!.interact();
    } else {
      print('No trash can nearby to interact with.');
    }
  }
}
