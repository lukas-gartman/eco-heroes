import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/src/models/interactive_object.dart';
import 'package:flutter/material.dart';

class ProximityChecker<T extends InteractiveObject> {
  final List<T> objects;
  final double proximityRange;
  final ValueNotifier<bool> inProximity;
  T? nearbyObject;

  ProximityChecker({required this.objects, required this.proximityRange, required this.inProximity});

  void checkProximity(Vector2 playerPosition) {
    nearbyObject = null;

    for (T obj in objects) {
      double distance = playerPosition.distanceTo(obj.position);
      if (distance < proximityRange) {
        nearbyObject = obj;
      }
    }

    inProximity.value = nearbyObject != null;
  }
}
