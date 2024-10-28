import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/src/models/interactive_object.dart';
import 'package:eco_heroes/src/models/mini_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'game_manager.dart';
import 'src/models/cut_scene.dart';
import 'src/models/players/eco_hero_player.dart';
import 'interact_button.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  GameState createState() => GameState();
}

class GameState extends State<Game> with TickerProviderStateMixin {
  late GameManager gameManager;
  CutScene? cutScene;
  late MiniGame miniGame;
  late EcoHeroPlayer player;
  late Ticker _ticker;

  Key bonfireKey = Key(DateTime.now().toString());

  @override
  void initState() {
    super.initState();

    gameManager = GameManager(onMiniGameSwitch);
    gameManager.init();
    miniGame = gameManager.gameSegment.miniGame;
    cutScene = gameManager.gameSegment.cutScene;
    player = EcoHeroPlayer(miniGame.playerStartPosition, collisionAreas: miniGame.collisionAreas);
    miniGame.start();
    
    _ticker = Ticker((elapsed) { // Call update on the mini-game each frame
      miniGame.update(context, player.position); // Update with player's position
    });
    _ticker.start();
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
              key: bonfireKey, // Force Bonfire to rebuild when the mini-game changes
              playerControllers: [
                Joystick(directional: JoystickDirectional()),
                Keyboard(config: KeyboardConfig(directionalKeys: [KeyboardDirectionalKeys.wasd()])),
              ],
              cameraConfig: CameraConfig(zoom: 2),
              map: miniGame.map,
              player: player,
              components: miniGame.objects,
              lightingColorGame: miniGame.lighting,
              onReady: (value) => {
                if (cutScene != null) ...[
                  showDialog(context: context, builder: (BuildContext context) {
                    return Dialog.fullscreen(child: cutScene!);
                  }),
                ],
              },
            ),
            
            ValueListenableBuilder<InteractiveObject?>(
              valueListenable: miniGame.proximityChecker.inProximityWith,
              builder: (context, nearbyObject, _) {
                if (nearbyObject != null) {
                  return InteractButton(
                    interactionType: nearbyObject.interactionType,
                    onPressed: _onInteract, 
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      );
    });
  }

  void onMiniGameSwitch([bool noMoreGames = false, CutScene? cutScene]) {
    if (cutScene != null) {
      Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => cutScene!),
        );
      });
    }

    if (noMoreGames) {
      print('No more games to play.');
      return;
    }

    setState(() {
      cutScene = gameManager.gameSegment.cutScene;
      miniGame = gameManager.gameSegment.miniGame;
      miniGame.start();
      player = EcoHeroPlayer(miniGame.playerStartPosition, collisionAreas: miniGame.collisionAreas);
      bonfireKey = Key(DateTime.now().toString());
    });
  }

  // Handle interact button press
  void _onInteract() {
    
    if (miniGame.proximityChecker.inProximityWith.value != null) {
      InteractiveObject objectToInteractWith = miniGame.proximityChecker.inProximityWith.value!;
      miniGame.interactWithObject(context, objectToInteractWith);
    } else {
      print('No trash can nearby to interact with.');
    }  
  }
}
