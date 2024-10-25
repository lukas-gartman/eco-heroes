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
  static const int numberOfHoles = 8;

  late List<Hole> holes;
  late List<SquirrelNPC> squirrels;
  List<InteractiveObject> combinedList = [];
  final double proximityRange = 40;
  int collectedTrash = 0;
  bool isStart = true;
  bool isCompleted = false;

  ChoppedForrestMiniGame(super.onCompleted);

  

  @override
  List<GameObject> get objects => combinedList;//Changed to combinedList from trashCans

  @override
  GameMap get map => WorldMapByTiled(WorldMapReader.fromAsset('maps/chopped_down_forrest/choppedDownForrest.tmj'), forceTileSize: Vector2.all(tileSize));

  @override
  void start() {
    squirrels = generateNPCs(); //Currently only creates one squirrel
    holes = generateRandomTrashCans(); 
    
    combinedList.addAll(squirrels);
    combinedList.addAll(holes);
    
    //Create a combined list with trashcans and NPCs
    super.proximityChecker = ProximityChecker(
      objects: combinedList,
      proximityRange: proximityRange,
      inProximityWith: ValueNotifier(null), // Initialize the button state
    );
    print("Trash picking mini-game started with positions: $holes");
  }

  @override
  void update(BuildContext context, Vector2 playerPosition) {
    if (isCompleted) return;
    if (isStart) {
      isStart = false;
      TalkDialog.show(context, GameDialog.trashPickingIntroDialog());
      return;
    }
    
    super.proximityChecker.checkProximity(playerPosition); // Call the proximity checker in each update with the player's position
    if (holes.isEmpty) {
      isCompleted = true;
      TalkDialog.show(context, GameDialog.trashPickingEndDialog(), onFinish: () => super.onCompleted());
    }
  }

  List<Hole> generateRandomTrashCans() {

    //To save time for submission, statically generate 8 positions of Holes

    final List<Hole> holeList = [];

    holeList.add(Hole(position: Vector2(71, 145)));
    holeList.add(Hole(position: Vector2(184, 292)));
    holeList.add(Hole(position: Vector2(312, 466)));
    holeList.add(Hole(position: Vector2(458, 132)));
    holeList.add(Hole(position: Vector2(501, 381)));
    holeList.add(Hole(position: Vector2(239, 534)));
    holeList.add(Hole(position: Vector2(366, 289)));
    holeList.add(Hole(position: Vector2(555, 472)));

    return holeList;
  }

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

      /*When interacting with a hole it should.
      1. Remove the hole
      2. Replace where the hole was with a tree / seed
      3. Have some sort of count down until its done

      */
      object.interact();
      holes.remove(object);
      collectedTrash++;
      proximityChecker.removeObject(object);
      print('Removed trash can at position: ${object.position}');
    }
    
    if (object is SquirrelNPC) {
      object.interact();
      TalkDialog.show(context, GameDialog.trashPickingSquirrelInteract(numberOfHoles - collectedTrash));
      //print("Hello, im a squirrel. Please help us clean up!");
    }
  }
}
