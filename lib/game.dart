import 'dart:math' as math;
import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/src/models/interactive_objects/trash.dart';
import 'package:flutter/material.dart';
import 'src/models/players/eco_hero_player.dart';

class Game extends StatelessWidget {
  final double tileSize = 16;
  // ValueNotifier to track when to show the interact button
  ValueNotifier<bool> showInteractButton = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double maxSize = math.max(size.width, size.height);
    return LayoutBuilder(builder: (context, constraints) {
      return Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            BonfireWidget(
              playerControllers: [
                Joystick(directional: JoystickDirectional()),
              ],
              cameraConfig: CameraConfig(zoom: maxSize / (tileSize * 20)),
              map: WorldMapByTiled(
                WorldMapReader.fromAsset('eco-heroes.tmj'),
                forceTileSize: Vector2.all(tileSize),
              ),
              player: EcoHeroPlayer(Vector2(40, 40)),
              components: [
                Trash(
                  Vector2(100, 100), // Position of the trash can
                  onPlayerProximity: (bool isNearby) {
                    // Update ValueNotifier based on proximity
                    showInteractButton.value = isNearby;
                  },
                ),
              ],
            ),

            // ValueListenableBuilder to listen to changes and show/hide button
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
                    : SizedBox.shrink(); // If not nearby, hide button
              },
            ),
          ],
        ),
      );
    });
  }

  // Interaction logic when button is pressed
  void _onInteract() {
    // Add your interaction logic here, e.g., opening a dialog or triggering an event.
    print('Player interacted with the trash can!');
  }
}
