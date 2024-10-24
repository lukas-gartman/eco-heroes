import 'dart:math';
import 'package:eco_heroes/src/models/interactive_object.dart';
import 'package:eco_heroes/src/models/interactive_objects/squirrelNPC.dart';
import 'package:flutter/widgets.dart';

import '../dialog.dart';
import '../interactive_objects/trash.dart';
import '../mini_game.dart';
import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/src/models/proximity_checker.dart';

class TrashPickingMiniGame extends MiniGame {
  static const double tileSize = 16;
  static const double mapWidth = 320;
  static const double mapHeight = 320;
  static const int numberOfTrashCans = 5;

  late List<Trash> trashCans;
  late List<SquirrelNPC> squirrels;
  List<InteractiveObject> combinedList = [];
  final double proximityRange = 40;
  int collectedTrash = 0;
  bool isStart = true;
  bool isCompleted = false;

  TrashPickingMiniGame(super.onCompleted);

  @override
  List<GameObject> get objects => combinedList;//Changed to combinedList from trashCans

  @override
  GameMap get map => WorldMapByTiled(WorldMapReader.fromAsset('eco-heroes.tmj'));

  @override
  void start() {
    trashCans = generateRandomTrashCans(numberOfTrashCans);
    squirrels = generateNPCs();
    
    combinedList.addAll(trashCans);
    combinedList.addAll(squirrels);
    //Create a combined list with trashcans and NPCs
    super.proximityChecker = ProximityChecker(
      objects: combinedList,
      proximityRange: proximityRange,
      inProximity: ValueNotifier(false), // Initialize the button state
    );
    print("Trash picking mini-game started with positions: $trashCans");
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
    if (trashCans.isEmpty) {
      isCompleted = true;
      TalkDialog.show(context, GameDialog.trashPickingEndDialog(), onFinish: () => super.onCompleted());
    }
  }

  List<Trash> generateRandomTrashCans(int numberOfTrashCans) {
    final List<Trash> trashList = [];
    final random = Random();

    while (trashList.length < numberOfTrashCans) {
      // Generate a new random position within the bounds of the map
      double x = random.nextDouble() * (mapWidth); // Adjusted to be between 0 and mapWidth (320)
      double y = random.nextDouble() * (mapHeight); // Adjusted to be between 0 and mapHeight (320)
      Vector2 position = Vector2(x, y);
      
      Trash newTrashCan = Trash(position: position);
      trashList.add(newTrashCan);
    }

    return trashList;
  }

  List<SquirrelNPC> generateNPCs(){
    final List<SquirrelNPC> squirrelList = [];
    SquirrelNPC squirrel = SquirrelNPC(position: Vector2(100, 100)); //Position of the Squirrel
    squirrelList.add(squirrel);
    return squirrelList;
  }


  //Edit this
  @override
  void interactObject(BuildContext context, GameObject object)  {
    

    if (object is Trash) {
      object.interact();
      trashCans.remove(object);
      collectedTrash++;
      print('Removed trash can at position: ${object.position}');
    }
    if (object is SquirrelNPC) {
      object.interact();
      TalkDialog.show(context, GameDialog.trashPickingSquirrelInteract(numberOfTrashCans - collectedTrash));
      //print("Hello, im a squirrel. Please help us clean up!");
    }
  }
}
