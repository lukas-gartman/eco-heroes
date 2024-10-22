import 'dart:math' as math;
import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Import Scheduler for Ticker
import 'src/models/players/eco_hero_player.dart';
import 'src/models/mini_games/trash_picking_mini_game.dart'; // Import the mini-game class
import 'interact_button.dart'; // Import the interact button widget

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin { // Add TickerProviderStateMixin
  final double tileSize = 16;
  final double mapWidth = 320; // Set according to your map's width
  final double mapHeight = 320; // Set according to your map's height
  final int numberOfTrashCans = 5;

  late TrashPickingMiniGame miniGame;
  late EcoHeroPlayer player; // Declare player
  late Ticker _ticker; // Declare a Ticker
  ValueNotifier<bool> showInteractButton = ValueNotifier(false); // Button visibility

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
    player = EcoHeroPlayer(Vector2(40, 40)); // Initialize player

    // Initialize the Ticker
    _ticker = Ticker((elapsed) {
      // Call update on the mini-game each frame
      miniGame.update(player.position); // Update with player's position
    });
    _ticker.start(); // Start the ticker
  }

  @override
  void dispose() {
    _ticker.dispose(); // Dispose the ticker
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (miniGame.trashCans.isEmpty) {
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
              player: player,
              components: miniGame.trashCans, // Spawn the trash cans
            ),
            ValueListenableBuilder<bool>(
              valueListenable: miniGame.proximityChecker.showInteractButton,
              builder: (context, isVisible, child) {
                return InteractButton(
                  isVisible: isVisible,
                  onPressed: _onInteract,
                );
              },
            ),
          ],
        ),
      );
    });
  }

  // Handle interact button press
  void _onInteract() {
    // Here you can add interaction logic if needed
  }
}
