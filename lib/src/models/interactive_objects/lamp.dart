import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import '../interactive_object.dart';
import '../enums/interaction_type.dart';

abstract class Lamp extends InteractiveObject {
  final String spriteSrc;
  @override
  InteractionType get interactionType => InteractionType.onOff;

  bool _lampOn = true;
  bool get lampOn => _lampOn;

  Lamp({required this.spriteSrc, required super.position})
    : super(size: Vector2(32, 32), sprite: Sprite.load(spriteSrc)) {
      setupLighting(
        LightingConfig(
          radius: width * 1.5,
          color: Colors.yellow.withOpacity(_lampOn ? 0.5 : 0),
          withPulse: true,
        ),
      );
    }

  @override
  void interact() {
    _lampOn = !_lampOn;
    setupLighting(
      LightingConfig(
        radius: _lampOn ? (width * 1.5) : 0,
        color: Colors.yellow.withOpacity(_lampOn ? 0.5 : 0),
        withPulse: _lampOn,
      ),
    );
  }
}
