import 'package:eco_heroes/src/models/mini_games/apartment_mini_game.dart';
import 'package:eco_heroes/src/models/mini_games/chopped_forrest_mini_game.dart';
import 'package:eco_heroes/src/models/mini_games/trash_picking_mini_game.dart';
import 'package:flutter/material.dart';

import 'src/models/cut_scene.dart';
import 'src/models/dialog.dart';
import 'src/models/mini_game.dart';

class GameSegment {
  final CutScene? cutScene;
  final MiniGame miniGame;

  GameSegment({this.cutScene, required this.miniGame});
}

class GameManager {
  final void Function([bool, CutScene?]) onMiniGameSwitch;
  List<GameSegment> _gameSegments = [];
  late GameSegment _currentGameSegment;
  GameSegment get gameSegment => _currentGameSegment;

  GameManager(this.onMiniGameSwitch);

  void init() {
    _gameSegments = [
      GameSegment(cutScene: CutScene(opacity: 50, dialog: GameDialog.introMeetTheHero()), miniGame: TrashPickingMiniGame(onMiniGameCompleted)),
      GameSegment(cutScene: CutScene(opacity: 25, dialog: GameDialog.introForestAttack()), miniGame: ChoppedForrestMiniGame(onMiniGameCompleted)),
      GameSegment(cutScene: CutScene(opacity: 0,  dialog: GameDialog.introHouseSabotageDialog()), miniGame: ApartmentMiniGame(onMiniGameCompleted)),
    ];

    _currentGameSegment = _gameSegments.removeAt(0);
  }
  
  void onMiniGameCompleted() {
    print('Mini game completed: $_currentGameSegment');
    if (_gameSegments.isNotEmpty) {
      _currentGameSegment = _gameSegments.removeAt(0);
      onMiniGameSwitch();
    } else {
      print('All mini games completed.');
      const Widget textWidget = Center(
        child: Text(
          'The city has been saved!',
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(offset: Offset(1.5, 1.5), blurRadius: 3.0, color: Colors.black)],
          ),
        ),
      );
      onMiniGameSwitch(true, CutScene(opacity: 0, dialog: GameDialog.cityIsSavedDialog(), cityHasBeenSaved: true, onScreenWidget: textWidget,));
    }
  }
}