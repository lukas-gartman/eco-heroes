import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/interactive_objects/interactive_object.dart';
import 'package:eco_heroes/mini_games/mini_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../services/game_manager.dart';
import '../../widgets/cut_scene.dart';
import '../../players/eco_hero_player.dart';
import '../../widgets/interact_button.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> with TickerProviderStateMixin {
  late GameManager gameManager;
  late MiniGame miniGame;
  late EcoHeroPlayer player;
  late Ticker _ticker;

  Key bonfireKey = Key(DateTime.now().toString());

  @override
  void initState() {
    super.initState();

    gameManager = GameManager(onMiniGameSwitch);
    gameManager.init();
    miniGame = gameManager.miniGame;
    player = EcoHeroPlayer(miniGame.playerStartPosition, collisionAreas: miniGame.collisionAreas);
    miniGame.start();
    player = EcoHeroPlayer(Vector2(300, 300), collisionAreas: miniGame.collisionAreas);

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
          MaterialPageRoute(builder: (context) => cutScene),
        ).whenComplete(() {
          Navigator.pushReplacementNamed(context, '/');
        });
      });
    }

    setState(() {
      miniGame = gameManager.miniGame;
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
