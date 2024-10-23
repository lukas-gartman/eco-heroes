import 'package:eco_heroes/src/models/mini_games/trash_picking_mini_game.dart';

import 'src/models/mini_game.dart';

class GameManager {
  final void Function() onMiniGameSwitch;
  List<MiniGame> _miniGames = [];
  late MiniGame _currentMiniGame;

  GameManager(this.onMiniGameSwitch);

  MiniGame get miniGame => _currentMiniGame;

  void init() {
    _miniGames = [
      TrashPickingMiniGame(onMiniGameCompleted),
      TrashPickingMiniGame(onMiniGameCompleted),
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
    }
  }
}