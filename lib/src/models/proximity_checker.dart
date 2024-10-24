import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/src/models/interactive_object.dart';
import 'package:flutter/material.dart';

class ProximityChecker<T extends InteractiveObject> {
  final List<T> objects;
  final double proximityRange;
  final ValueNotifier<T?> inProximityWith;

  ProximityChecker({required this.objects, required this.proximityRange, required this.inProximityWith});

  void checkProximity(Vector2 playerPosition) {
    inProximityWith.value = null;

    for (T obj in objects) {
      double distance = playerPosition.distanceTo(obj.position);
      if (distance < proximityRange) {
        inProximityWith.value = obj;
      }
    }
  }

  void removeObject(T obj) {
    objects.remove(obj);
  }
}
