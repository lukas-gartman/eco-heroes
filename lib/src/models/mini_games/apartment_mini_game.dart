import 'package:eco_heroes/src/models/interactive_objects/lamps/floor_lamp.dart';
import 'package:eco_heroes/src/models/interactive_objects/lamps/table_lamp.dart';
import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';

import '../dialog.dart';
import '../interactive_object.dart';
import '../interactive_objects/lamp.dart';
import '../mini_game.dart';
import '../proximity_checker.dart';
import 'end_games/quiz_mini_game.dart';

class ApartmentMiniGame extends MiniGame {
  static const double tileSize = 16 * 2;
  static const double mapWidth = tileSize * 22;
  static const double mapHeight = tileSize * 32;
  final double proximityRange = 40;
  bool isStart = true;
  bool isGameCompleted = false;

  ApartmentMiniGame({required super.onCompleted, super.cutScene});

  final List<Lamp> _lamps = [
    TableLamp(position: Vector2(425, 560)),
    FloorLamp(position: Vector2(533, 700)),
    TableLamp(position: Vector2(485, 964)),
    TableLamp(position: Vector2(586, 964)),
    FloorLamp(position: Vector2(490, 818)),
    FloorLamp(position: Vector2(377, 831)),
    FloorLamp(position: Vector2(245, 964)),
    TableLamp(position: Vector2(38, 950)),
    TableLamp(position: Vector2(176, 967)),
    TableLamp(position: Vector2(35, 771)),
    TableLamp(position: Vector2(17, 703)),
    TableLamp(position: Vector2(17, 608)),
    TableLamp(position: Vector2(319, 727)),
    FloorLamp(position: Vector2(346, 427)),
    FloorLamp(position: Vector2(249, 415)),
    TableLamp(position: Vector2(170, 454)),
    FloorLamp(position: Vector2(325, 530)),
    FloorLamp(position: Vector2(26, 346)),
    FloorLamp(position: Vector2(166, 346)),
    TableLamp(position: Vector2(51, 181)),
    TableLamp(position: Vector2(27, 0)),
    TableLamp(position: Vector2(312, 808)),
  ];

  @override
  GameMap get map => WorldMapByTiled(WorldMapReader.fromAsset('maps/apartment/apartment.tmj'), forceTileSize: Vector2.all(tileSize));
  @override
  Color get lighting => Colors.black.withOpacity(0.5);
  @override
  List<GameObject> get objects => _lamps;
  @override
  Vector2 get playerStartPosition => Vector2(635, 628);
  @override
  List<Rect> get collisionAreas => [
    // Walls
    const Rect.fromLTRB(589, 718, 704, 736),
    const Rect.fromLTRB(588, 640, 606, 737),
    const Rect.fromLTRB(582, 508, 606, 598),
    const Rect.fromLTRB(389, 516 ,606, 532),
    const Rect.fromLTRB(463, 380, 487, 528),
    const Rect.fromLTRB(245, 377, 477, 397),
    const Rect.fromLTRB(314, 379, 330, 514),
    const Rect.fromLTRB(193, 505, 272, 517),
    const Rect.fromLTRB(243, 302, 263, 390),
    const Rect.fromLTRB(114, 300, 262, 319),
    const Rect.fromLTRB(189, 309, 200, 511),
    const Rect.fromLTRB(388, 519, 400, 796),
    const Rect.fromLTRB(274, 777, 402, 807),
    const Rect.fromLTRB(464, 648, 605, 676),
    const Rect.fromLTRB(461, 778, 672, 800),
    const Rect.fromLTRB(658, 797, 704, 972),
    const Rect.fromLTRB(468, 970, 660, 986),
    const Rect.fromLTRB(463, 911, 473, 974),
    const Rect.fromLTRB(463, 659, 469, 733),
    const Rect.fromLTRB(459, 783, 471, 870),
    const Rect.fromLTRB(0, 970, 704, 1024),
    const Rect.fromLTRB(187, 846, 203, 992),
    const Rect.fromLTRB(0, 777, 212, 802),
    const Rect.fromLTRB(187, 581, 197, 733),
    const Rect.fromLTRB(0, 580, 199, 593),
    const Rect.fromLTRB(0, 299, 57, 319),
    const Rect.fromLTRB(173, 0, 194, 326),
    const Rect.fromLTRB(0, 108, 114, 127),

    const Rect.fromLTRB(492, 891, 568, 1024), // bottom right bed
    const Rect.fromLTRB(257, 685, 296, 774), // middle lounge couch 1
    const Rect.fromLTRB(287, 750, 392, 800), // middle lounge couch 2
    const Rect.fromLTRB(0, 621, 92, 685),    // middle left bed
    const Rect.fromLTRB(30, 0, 100, 66),     // top bed
  ];

  @override
  void start() {
    super.proximityChecker = ProximityChecker(
      objects: _lamps,
      proximityRange: proximityRange,
      inProximityWith: ValueNotifier(null),
    );
  }

  @override
  void update(BuildContext context, Vector2 playerPosition) {
    if (isStart) {
      super.update(context, playerPosition);

      isStart = false;
      TalkDialog.show(context, GameDialog.apartmentIntroDialog());
      return;
    }

    super.proximityChecker.checkProximity(playerPosition); // Call the proximity checker in each update with the player's position

    if (_lamps.every((lamp) => !lamp.lampOn) && !isGameCompleted) {
      isGameCompleted = true;
      TalkDialog.show(context, GameDialog.apartmentEndDialog(), onFinish: () {
        Future.microtask(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuizMiniGame(onQuizMiniGameCompleted: () => super.onCompleted())),
          );
        });
      });
    }
  }

  @override
  void interactWithObject(BuildContext context, GameObject object) {
    if (object is InteractiveObject) {
      object.interact();
    }
  }
}