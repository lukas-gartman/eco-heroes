import 'dart:math';
import 'package:eco_heroes/src/models/interactive_objects/recycling_bins.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bonfire/bonfire.dart';

import '../dialog.dart';
import '../interactive_objects/trash.dart';
import '../interactive_object.dart';
import '../interactive_objects/squirrel_npc.dart';
import '../mini_game.dart';
import '../proximity_checker.dart';

class TrashPickingMiniGame extends MiniGame {
  static const double tileSize = 16;
  static const double mapWidth = 640;
  static const double mapHeight = 640;
  static const int numberOfTrashCans = 5;

  late List<Trash> trashCans;
  late List<SquirrelNPC> squirrels;
  RecyclingBins recyclingBins = RecyclingBins(position: Vector2(189, 260));
  List<InteractiveObject> combinedList = [];
  final double proximityRange = 40;
  int collectedTrash = 0;
  bool isStart = true;
  bool isCompleted = false;

  TrashPickingMiniGame(super.onCompleted);

  @override
  List<GameObject> get objects => combinedList;//Changed to combinedList from trashCans

  @override
  GameMap get map => WorldMapByTiled(WorldMapReader.fromAsset('maps/trash_picking/ParkArea.tmj'), forceTileSize: Vector2.all(tileSize));

  @override
  void start() {
    squirrels = generateNPCs(); //Currently only creates one squirrel
    trashCans = generateRandomTrashCans(numberOfTrashCans); 
    
    combinedList.addAll(squirrels);
    combinedList.addAll(trashCans);
    combinedList.add(recyclingBins);
    
    //Create a combined list with trashcans and NPCs
    super.proximityChecker = ProximityChecker(
      objects: combinedList,
      proximityRange: proximityRange,
      inProximityWith: ValueNotifier(null), // Initialize the button state
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
      
      // Check if this new position is far enough from existing trash cans
      bool isValidPosition = true;

      for (Trash existingTrash in trashList) {
        if (position.distanceTo(existingTrash.position) < proximityRange+10) { //Added +10 so that there should always be some sort of space between trash.
          isValidPosition = false;
          break; // No need to check further if the new position is too close
        }
      }

      for (SquirrelNPC existingSquirrels in squirrels) {
        if(position.distanceTo(existingSquirrels.position) < proximityRange+10){
          isValidPosition = false;
          break; // No need to check further if the new position is too close
        }
      }

      if (position.distanceTo(recyclingBins.position) < proximityRange+10) {
        isValidPosition = false;
        break; // No need to check further if the new position is too close
      }

      if (isValidPosition) {
        trashList.add(Trash(position: position));
      }
    }

    return trashList;
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
    if (object is Trash) {
      object.interact();
      trashCans.remove(object);
      collectedTrash++;
      proximityChecker.removeObject(object);
      print('Removed trash can at position: ${object.position}');
    }
    
    if (object is SquirrelNPC) {
      object.interact();
      TalkDialog.show(context, GameDialog.trashPickingSquirrelInteract(numberOfTrashCans - collectedTrash));
      //print("Hello, im a squirrel. Please help us clean up!");
    }

    if (object is RecyclingBins) {
      object.interact();
      TalkDialog.show(context, GameDialog.trashPickingRecyclingInteract(numberOfTrashCans - collectedTrash));
    }
  }
}
