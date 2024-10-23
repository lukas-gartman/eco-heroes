import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/src/models/interactive_object.dart';
import 'package:eco_heroes/src/models/mini_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'game_manager.dart';
import 'src/models/players/eco_hero_player.dart';
import 'interact_button.dart';
import 'src/models/dialog.dart';

class Game extends StatefulWidget {
  @override
  GameState createState() => GameState();
}

class GameState extends State<Game> with TickerProviderStateMixin {
  late GameManager gameManager;
  late MiniGame miniGame;
  late EcoHeroPlayer player;
  late Ticker _ticker;
  ValueNotifier<bool> showInteractButton = ValueNotifier(false); // Button visibility

  @override
  void initState() {
    super.initState();
    _showIntroDialog(); // kommentera ut för att slippa introdialog

    gameManager = GameManager(onMiniGameSwitch);
    gameManager.init();
    miniGame = gameManager.miniGame;
    miniGame.start();
    player = EcoHeroPlayer(Vector2(40, 40));

    _ticker = Ticker((elapsed) { // Call update on the mini-game each frame
      miniGame.update(context, player.position); // Update with player's position
    });
    _ticker.start();
  }

  Future<void> _showIntroDialog() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Small delay to ensure the screen loads
    await GameDialog.introDialog(context); // Show the dialog
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            BonfireWidget(
              key: Key(DateTime.now().toString()), // Force Bonfire to rebuild when the mini-game changes
              playerControllers: [
                Joystick(directional: JoystickDirectional()),
              ],
              cameraConfig: CameraConfig(
                zoom: 2,
              ),
              map: miniGame.map,
              player: player,
              components: miniGame.objects,
              debugMode: true,
            ),
            ValueListenableBuilder<bool>(
              valueListenable: miniGame.proximityChecker.inProximity,
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

  void onMiniGameSwitch() {
    setState(() {
      miniGame = gameManager.miniGame;
      miniGame.start();
      player.position = Vector2(40, 40);
    });
  }

  // Handle interact button press
  void _onInteract() {
    if (miniGame.proximityChecker.nearbyObject != null) {
      InteractiveObject objectToInteractWith = miniGame.proximityChecker.nearbyObject!;
      objectToInteractWith.interact();
      miniGame.removeObject(objectToInteractWith);
      print('Removed trash can at position: ${objectToInteractWith.position}');
    } else {
      print('No trash can nearby to interact with.');
    }  
  }
}
