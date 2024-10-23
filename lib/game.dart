import 'dart:math' as math;
import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Import Scheduler for Ticker
import 'src/models/interactive_objects/trash.dart';
import 'src/models/players/eco_hero_player.dart';
import 'src/models/mini_games/trash_picking_mini_game.dart'; // Import the mini-game class
import 'interact_button.dart'; // Import the interact button widget
import 'src/models/dialog.dart';

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
    _showIntroDialog(); // kommentera ut för att slippa introdialog
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

    Future<void> _showIntroDialog() async {
    await Future.delayed(Duration(milliseconds: 500)); // Small delay to ensure the screen loads
    await GameDialog.introDialog(context); // Show the dialog
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
    // Call the interact method on the nearby trash can
    // Call the interact method on the nearby trash can
  if (miniGame.proximityChecker.nearbyTrashCan != null) {
    Trash trashCanToRemove = miniGame.proximityChecker.nearbyTrashCan!;
    trashCanToRemove.interact(); // Call interact on the specific trash can
    miniGame.removeTrashCan(trashCanToRemove); // Remove the trash can from the game and the list
    print('Removed trash can at position: ${trashCanToRemove.position}'); // Log removal
  } else {
    print('No trash can nearby to interact with.');
  }
    
  }
}
