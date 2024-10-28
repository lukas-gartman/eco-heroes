import 'dart:math';
import 'package:eco_heroes/src/models/interactive_objects/hole.dart';
import 'package:flutter/widgets.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flame_audio/flame_audio.dart';

import '../dialog.dart';
import '../interactive_object.dart';
import '../interactive_objects/squirrel_npc.dart';
import '../mini_game.dart';
import '../proximity_checker.dart';
class ChoppedForrestMiniGame extends MiniGame {
  static const double tileSize = 16;
  static const double mapWidth = 640;
  static const double mapHeight = 640;
  static const int numberOfHoles = 8;

  late List<Hole> holes;
  late List<SquirrelNPC> squirrels;

  List<InteractiveObject> combinedList = [];
  final double proximityRange = 40;
  int plantedSeeds = 0;
  bool isStart = true;
  bool isCompleted = false;

  final WorldMapByTiled _map1 = WorldMapByTiled(WorldMapReader.fromAsset('maps/chopped_down_forrest/choppedDownForrest.tmj'), forceTileSize: Vector2.all(tileSize));
  final WorldMapByTiled _map2 = WorldMapByTiled(WorldMapReader.fromAsset('maps/trash_picking/ParkArea.tmj'), forceTileSize: Vector2.all(tileSize));

  bool _showMap1 = true;

  ChoppedForrestMiniGame(super.onCompleted);

  @override
  GameMap get map => _showMap1 ? _map1 : _map2;

  @override
  List<GameObject> get objects => combinedList; //Changed to combinedList from trashCans
  
  @override
  Vector2 get playerStartPosition => Vector2(300, 300);
  
  @override
  List<Rect> get collisionAreas => [
    // Top left grass
    const Rect.fromLTRB(16, 0, 60, 15),
    const Rect.fromLTRB(65, 22, 110, 46),
    const Rect.fromLTRB(5, 86, 50, 114),
    const Rect.fromLTRB(75, 99, 125, 125),
    const Rect.fromLTRB(10, 210, 60, 238),
    const Rect.fromLTRB(115, 197, 160, 220),
    const Rect.fromLTRB(185, 207, 228, 238),
    const Rect.fromLTRB(150, 86, 190, 115),
    const Rect.fromLTRB(200, 83, 246, 110),
    const Rect.fromLTRB(170, 5, 216, 32),

    // Top right grass
    const Rect.fromLTRB(373, 50, 406, 75),
    const Rect.fromLTRB(480, 0, 520, 9),
    const Rect.fromLTRB(462, 51, 487, 76),
    const Rect.fromLTRB(546, 62, 583, 90),
    const Rect.fromLTRB(589, 15, 640, 47),
    const Rect.fromLTRB(381, 131, 412, 156),
    const Rect.fromLTRB(439, 159, 466, 188),
    const Rect.fromLTRB(544, 132, 571, 154),
    const Rect.fromLTRB(356, 223, 389, 251),
    const Rect.fromLTRB(494, 225, 523, 251),
    const Rect.fromLTRB(566, 227, 596, 249),

    // Bottom left grass
    const Rect.fromLTRB(14, 351, 58, 389),
    const Rect.fromLTRB(138, 335, 174, 369),
    const Rect.fromLTRB(203, 363, 251, 400),
    const Rect.fromLTRB(6, 428, 48, 470),
    const Rect.fromLTRB(106, 429, 159, 470),
    const Rect.fromLTRB(184, 458, 225, 502),
    const Rect.fromLTRB(47, 555, 92, 596),
    const Rect.fromLTRB(152, 541, 194, 578),
    const Rect.fromLTRB(224, 540, 262, 583),

    // Bottom right grass
    const Rect.fromLTRB(385, 347, 427, 384),
    const Rect.fromLTRB(490, 351, 526, 384),
    const Rect.fromLTRB(578, 383, 640, 416),
    const Rect.fromLTRB(364, 449, 398, 482),
    const Rect.fromLTRB(445, 429, 489, 466),
    const Rect.fromLTRB(397, 525, 443, 558),
    const Rect.fromLTRB(507, 560, 543, 594),
    const Rect.fromLTRB(590, 523, 640, 565),
  ];

  @override
  void start() {
    squirrels = generateNPCs(); //Currently only creates one squirrel
    holes = generateHoles(); 
    //plantedTrees = generateTrees();
    
    //Create a combined list with trashcans and NPCs
    combinedList.addAll(squirrels);
    combinedList.addAll(holes);

    super.proximityChecker = ProximityChecker(
      objects: combinedList,
      proximityRange: proximityRange,
      inProximityWith: ValueNotifier(null), // Initialize the button state
    );
  }

  @override
  void update(BuildContext context, Vector2 playerPosition) {
    if (isCompleted) return;
    if (isStart) {
      isStart = false;
      //Change intro dialogue 
      TalkDialog.show(context, GameDialog.plantingIntroDialogue());
      return;
    }
    
    super.proximityChecker.checkProximity(playerPosition); // Call the proximity checker in each update with the player's position
    if (plantedSeeds == numberOfHoles) {
      
      isCompleted = true;
      FlameAudio.play('minigame_success.wav');
      TalkDialog.show(context, GameDialog.plantingEndDialog(), onFinish: () => super.onCompleted());
    }
  }

  List<Hole> generateHoles() {
    List<Hole> holeList = [];

    bool isValidPosition(Vector2 position) {
      List<Rect> dirtPathAreas = [
        const Rect.fromLTRB(268, 0, 344, 640),
        const Rect.fromLTRB(0, 255, 640, 341),
      ];

      bool isFarFromObjects = holeList.every((obj) => position.distanceTo(obj.position) >= proximityRange * 2);
      bool isOutsideCollisionAreas = collisionAreas.every((rect) => !rect.inflate(proximityRange).contains(position.toOffset()));
      bool isOutsideDirtPathAreas = dirtPathAreas.every((rect) => !rect.contains(position.toOffset()));
      
      return isFarFromObjects && isOutsideCollisionAreas && isOutsideDirtPathAreas;
    }

    Vector2 generateRandomPosition() {
      final random = Random();
      Vector2 position;
      do {
        position = Vector2(random.nextDouble() * (mapWidth - proximityRange), random.nextDouble() * (mapHeight - proximityRange));
      } while (!isValidPosition(position));

      return position;
    }

    for (int i = 0; i < numberOfHoles; i++) {
      holeList.add(Hole(position: generateRandomPosition()));
    }

    return holeList;
  }

  

  //Currently only 1 squirrel
  List<SquirrelNPC> generateNPCs(){
    final List<SquirrelNPC> squirrelList = [];
    SquirrelNPC squirrel = SquirrelNPC(position: Vector2(100, 100));
    squirrelList.add(squirrel);
    return squirrelList;
  }

  //Edit this
  @override
  void interactWithObject(BuildContext context, GameObject object)  {
    if (object is Hole) {
      FlameAudio.play('success.wav');
      object.interact();
      proximityChecker.removeObject(object);
      plantedSeeds++;
      toggleMap();
      
    }
    
    if (object is SquirrelNPC) {
      object.interact();
      TalkDialog.show(context, GameDialog.plantingSquirrelDialog(numberOfHoles - plantedSeeds));
    }
  }

  void toggleMap(){
    setState(){
      _showMap1 = !_showMap1;
    }
  }
}
