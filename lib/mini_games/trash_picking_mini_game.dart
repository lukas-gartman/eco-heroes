import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flame_audio/flame_audio.dart';

import '../interactive_objects/recycling_bins.dart';
import '../interactive_objects/trash_objects/apple_trash.dart';
import '../interactive_objects/trash_objects/banana_trash.dart';
import '../interactive_objects/trash_objects/box_trash.dart';
import '../interactive_objects/trash_objects/cup_trash.dart';
import '../interactive_objects/trash_objects/egg_trash.dart';
import '../interactive_objects/trash_objects/magazine_trash.dart';
import '../interactive_objects/trash_objects/milk_trash.dart';
import '../interactive_objects/trash_objects/plastic_bag_trash.dart';
import '../helpers/dialog.dart';
import '../interactive_objects/trash.dart';
import '../interactive_objects/interactive_object.dart';
import '../interactive_objects/squirrel_npc.dart';
import 'mini_game.dart';
import '../services/proximity_checker.dart';
import 'end_games/recycling_mini_game.dart';

class TrashPickingMiniGame extends MiniGame {
  static const double tileSize = 16;
  static const double mapWidth = 640;
  static const double mapHeight = 640;

  late List<Trash> trashObjects;
  late List<SquirrelNPC> squirrels;
  RecyclingBins recyclingBins = RecyclingBins(position: Vector2(189, 260));

  List<InteractiveObject> interactableObjects = [];
  final double proximityRange = 40;

  int collectedTrash = 0;
  bool isStart = true;
  bool isRecyclingCompleted = false;
  bool isTrashPickingCompleted = false;

  TrashPickingMiniGame({required super.onCompleted, super.cutScene});

  @override
  GameMap get map => WorldMapByTiled(WorldMapReader.fromAsset('maps/trash_picking/ParkArea.tmj'), forceTileSize: Vector2.all(tileSize));
  @override
  List<GameObject> get objects => interactableObjects;
  @override
  Vector2 get playerStartPosition => Vector2(300, 300);
  @override
  List<Rect> get collisionAreas => [
    const Rect.fromLTRB(99, 86, 192, 182),   // Top water
    const Rect.fromLTRB(413, 402, 518, 507), // Bottom water
    const Rect.fromLTRB(90, 443, 117, 484),  // Bottom left bench
    const Rect.fromLTRB(139, 443, 171, 476), // Bottom fire
    const Rect.fromLTRB(190, 441, 213, 482), // Bottom right bench
    const Rect.fromLTRB(393, 110, 422, 144), // Top left bench 
    const Rect.fromLTRB(445, 102, 474, 140), // Top fire
    const Rect.fromLTRB(495, 103, 516, 145), // Top right bench
    const Rect.fromLTRB(168, 229, 236, 266), // Recycling bins
  ];

  @override
  void start() {
    squirrels = generateNPCs(); //Currently only creates one squirrel
    trashObjects = createTrashObjects();
    
    interactableObjects.addAll(squirrels);
    interactableObjects.addAll(trashObjects);
    interactableObjects.add(recyclingBins);
    
    //Create a combined list with trashcans and NPCs
    super.proximityChecker = ProximityChecker(
      objects: interactableObjects,
      proximityRange: proximityRange,
      inProximityWith: ValueNotifier(null), // Initialize the button state
    );
  }

  @override
  void update(BuildContext context, Vector2 playerPosition) {
    if (isStart) {
      super.update(context, playerPosition);

      isStart = false;
      TalkDialog.show(context, GameDialog.trashPickingIntroDialog());
      return;
    }
    
    super.proximityChecker.checkProximity(playerPosition); // Call the proximity checker in each update with the player's position
    if (collectedTrash >= trashObjects.length && !isTrashPickingCompleted) {
      isTrashPickingCompleted = true;
      FlameAudio.play('minigame_success.wav');
      TalkDialog.show(context, GameDialog.trashPickingEndDialog());
    }
  }

  List<Trash> createTrashObjects({
    int? appleCount,
    int? bananaCount,
    int? boxCount,
    int? cupCount,
    int? eggCount,
    int? magazineCount,
    int? milkCount,
    int? plasticBagCount,
  }) {
    List<Trash> objects = [];
    final random = Random();
    getRandomNumUpTo(int max) => random.nextInt(max) + 1;

    appleCount ??= getRandomNumUpTo(3);
    bananaCount ??= getRandomNumUpTo(3);
    boxCount ??= getRandomNumUpTo(3);
    cupCount ??= getRandomNumUpTo(3);
    eggCount ??= getRandomNumUpTo(3);
    magazineCount ??= getRandomNumUpTo(3);
    milkCount ??= getRandomNumUpTo(3);
    plasticBagCount ??= getRandomNumUpTo(3);

    bool isValidPosition(Vector2 position) {
      List<InteractiveObject> allObjects = [recyclingBins, ...objects];
      bool isFarFromObjects = allObjects.every((obj) => position.distanceTo(obj.position) >= proximityRange);
      bool isOutsideCollisionAreas = collisionAreas.every((rect) => !rect.contains(position.toOffset()));
      return isFarFromObjects && isOutsideCollisionAreas;
    }

    Vector2 generateRandomPosition() {
      Vector2 position;
      do {
        position = Vector2(random.nextDouble() * (mapWidth - proximityRange), random.nextDouble() * (mapHeight - proximityRange));
      } while (!isValidPosition(position));

      return position;
    }

    objects.addAll(List.generate(appleCount,      (_) => AppleTrash(position: generateRandomPosition())));
    objects.addAll(List.generate(bananaCount,     (_) => BananaTrash(position: generateRandomPosition())));
    objects.addAll(List.generate(boxCount,        (_) => BoxTrash(position: generateRandomPosition())));
    objects.addAll(List.generate(cupCount,        (_) => CupTrash(position: generateRandomPosition())));
    objects.addAll(List.generate(eggCount,        (_) => EggTrash(position: generateRandomPosition())));
    objects.addAll(List.generate(magazineCount,   (_) => MagazineTrash(position: generateRandomPosition())));
    objects.addAll(List.generate(milkCount,       (_) => MilkTrash(position: generateRandomPosition())));
    objects.addAll(List.generate(plasticBagCount, (_) => PlasticBagTrash(position: generateRandomPosition())));

    return objects;
  }

  List<SquirrelNPC> generateNPCs(){
    final List<SquirrelNPC> squirrelList = [];
    SquirrelNPC squirrel = SquirrelNPC(position: Vector2(375, 300));
    squirrelList.add(squirrel);
    return squirrelList;
  }

  //Edit this
  @override
  void interactWithObject(BuildContext context, GameObject object)  {
    if (object is Trash) {
      object.interact();
      // trashObjects.remove(object);
      collectedTrash++;
      FlameAudio.play('success.wav');
      proximityChecker.removeObject(object);
      print('Removed trash can at position: ${object.position}');
    }
    
    if (object is SquirrelNPC) {
      object.interact();
      TalkDialog.show(context, GameDialog.trashPickingSquirrelInteract(trashObjects.length - collectedTrash));
      //print("Hello, im a squirrel. Please help us clean up!");
    }

    if (object is RecyclingBins) {
      object.interact();
      if (!isTrashPickingCompleted) {
        TalkDialog.show(context, GameDialog.trashPickingRecyclingInteract(trashObjects.length - collectedTrash));
      } else {
        Future.microtask(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecyclingMinigame(trashObjects: trashObjects, onRecyclingCompleted: () => super.onCompleted())),
          );
        });
      }
    }
  }
}