import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:eco_heroes/src/models/interactive_objects/trash.dart';

class ProximityChecker {
  final List<Trash> trashCans; // List of trash cans
  final double proximityRange; // The range within which to show the interact button
  final ValueNotifier<bool> showInteractButton; // To notify about button visibility
  Trash? nearbyTrashCan; // To store the currently nearby trash can instance

  ProximityChecker({
    required this.trashCans,
    required this.proximityRange,
    required this.showInteractButton,
  });

  void checkProximity(Vector2 playerPosition) {
    nearbyTrashCan = null; // Reset before checking

    for (Trash trashCan in trashCans) {
      double distance = playerPosition.distanceTo(trashCan.position);
      if (distance < proximityRange) {
        nearbyTrashCan = trashCan; // Set the nearby trash can
        
      }
    }

    // Update the button visibility
    showInteractButton.value = nearbyTrashCan != null;
  }
}
