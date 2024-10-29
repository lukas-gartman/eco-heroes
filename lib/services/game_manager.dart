import 'package:flutter/material.dart';

import '../widgets/cut_scene.dart';
import '../helpers/dialog.dart';
import '../mini_games/mini_game.dart';

import '../mini_games/apartment_mini_game.dart';
import '../mini_games/chopped_forest_mini_game.dart';
import '../mini_games/nice_looking_forest_mini_game.dart';
import '../mini_games/trash_picking_mini_game.dart';

class GameManager {
  final void Function([bool, CutScene?]) onMiniGameSwitch;
  List<MiniGame> _miniGames = [];
  late MiniGame _currentMiniGame;
  MiniGame get miniGame => _currentMiniGame;

  GameManager(this.onMiniGameSwitch);

  void init() {
    _miniGames = [
      TrashPickingMiniGame(
        cutScenes: [
          CutScene(opacity: 0, dialog: GameDialog.introMeetTheHeroPart1(), cityHasBeenSaved: true),
          CutScene(opacity: 50, dialog: GameDialog.introMeetTheHeroPart2()),
        ],
        onCompleted: onMiniGameCompleted
      ),
      ChoppedForestMiniGame(cutScenes: [CutScene(opacity: 25, dialog: GameDialog.introForestAttack())], onCompleted: onMiniGameCompleted),
      NiceLookingForestMiniGame(onCompleted: onMiniGameCompleted),
      ApartmentMiniGame(cutScenes: [CutScene(opacity: 0, dialog: GameDialog.introHouseSabotageDialog())], onCompleted: onMiniGameCompleted),
    ];

    _currentMiniGame = _miniGames.removeAt(0);
  }
  
  void onMiniGameCompleted() {
    print('Mini game completed: $_currentMiniGame');
    if (_miniGames.isNotEmpty) {
      _currentMiniGame = _miniGames.removeAt(0);
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
            shadows: [Shadow(offset: Offset(4.0, 4.0), blurRadius: 6.0, color: Colors.black)],
          ),
        ),
      );
      
      onMiniGameSwitch(true, CutScene(opacity: 0, dialog: GameDialog.cityIsSavedDialog(), cityHasBeenSaved: true, onScreenWidget: textWidget));
    }
  }
}