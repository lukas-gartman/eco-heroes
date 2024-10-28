import 'dart:math';
import 'package:eco_heroes/src/models/interactive_objects/hole.dart';
import 'package:flutter/widgets.dart';
import 'package:bonfire/bonfire.dart';

import '../dialog.dart';
import '../interactive_object.dart';
import '../interactive_objects/squirrel_npc.dart';
import '../mini_game.dart';
import '../proximity_checker.dart';

class ChoppedForrestMiniGame extends MiniGame {
  static const double tileSize = 16;
  static const double mapWidth = 640;
  static const double mapHeight = 640;
  static const int numberOfHoles = 8; //Not dynamic in this, if this is changed remember to change in method generateHoles();

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
  List<GameObject> get objects => combinedList; //Changed to combinedList from trashCans

  @override
  GameMap get map => _showMap1 ? _map1 : _map2;

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
      
      TalkDialog.show(context, GameDialog.plantingEndDialog(), onFinish: () => super.onCompleted());
    }
  }

  List<Hole> generateHoles() {

    //To save time for submission, statically generate 8 positions of Holes

    final List<Hole> holeList = [];

    holeList.add(Hole(position: Vector2(71, 145)));
    holeList.add(Hole(position: Vector2(184, 240)));
    holeList.add(Hole(position: Vector2(112, 466)));
    holeList.add(Hole(position: Vector2(458, 132)));
    holeList.add(Hole(position: Vector2(501, 381)));
    holeList.add(Hole(position: Vector2(239, 534)));
    holeList.add(Hole(position: Vector2(398, 231)));
    holeList.add(Hole(position: Vector2(555, 472)));

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
