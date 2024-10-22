import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:eco_heroes/src/models/interactive_objects/trash.dart';

class ProximityChecker {
  final List<Trash> trashCans; // List of trash cans
  final double proximityRange; // The range within which to show the interact button
  ValueNotifier<bool> showInteractButton; // To notify about button visibility

  ProximityChecker({
    required this.trashCans,
    required this.proximityRange,
    required this.showInteractButton,
  });

  void checkProximity(Vector2 playerPosition) {
    bool foundNearbyTrash = false;
    for (Trash trashCan in trashCans) {
      double distance = playerPosition.distanceTo(trashCan.position);
      if (distance < proximityRange) {
        foundNearbyTrash = true;
        print("Close to a trash can!");
      }
    }

    // Update the button visibility
    showInteractButton.value = foundNearbyTrash;
  }
}
