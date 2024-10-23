import 'package:eco_heroes/src/models/mini_games/trash_picking_mini_game.dart';

import 'src/models/mini_game.dart';

class GameManager {
  final void Function() onMiniGameSwitch;
  List<MiniGame> _miniGames = [];
  late MiniGame _currentMiniGame;

  GameManager(this.onMiniGameSwitch);

  MiniGame get miniGame => _currentMiniGame;

  void init() {
    const double tileSize = 16;
    const double mapWidth = 320;
    const double mapHeight = 320;
    const int numberOfTrashCans = 1;

    _miniGames = [
      TrashPickingMiniGame(onMiniGameCompleted, numberOfTrashCans: numberOfTrashCans, mapWidth: mapWidth, mapHeight: mapHeight, tileSize: tileSize),
      TrashPickingMiniGame(onMiniGameCompleted, numberOfTrashCans: numberOfTrashCans, mapWidth: mapWidth, mapHeight: mapHeight, tileSize: tileSize),
    ];

    _currentMiniGame = _miniGames.removeAt(0);
    // _currentMiniGame.start();
  }
  
  void onMiniGameCompleted() {
    print('Mini game completed: $_currentMiniGame');
    if (_miniGames.isNotEmpty) {
      _currentMiniGame = _miniGames.removeAt(0);
      onMiniGameSwitch();
    } else {
      print('All mini games completed.');
      return;
    }
  }
}