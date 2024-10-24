import 'package:eco_heroes/src/models/mini_games/trash_picking_mini_game.dart';

import 'src/models/cut_scene.dart';
import 'src/models/dialog.dart';
import 'src/models/mini_game.dart';

class GameSegment {
  final CutScene? cutScene;
  final MiniGame miniGame;

  GameSegment({this.cutScene, required this.miniGame});
}

class GameManager {
  final void Function() onMiniGameSwitch;
  List<GameSegment> _gameSegments = [];
  late GameSegment _currentGameSegment;
  GameSegment get gameSegment => _currentGameSegment;

  GameManager(this.onMiniGameSwitch);

  void init() {
    _gameSegments = [
      GameSegment(cutScene: CutScene(opacity: 50, dialog: GameDialog.introDialog()), miniGame: TrashPickingMiniGame(onMiniGameCompleted)),
      GameSegment(cutScene: CutScene(opacity: 15, dialog: GameDialog.introDialog()), miniGame: TrashPickingMiniGame(onMiniGameCompleted)),
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
    }
  }
}