import 'package:flutter/material.dart';

enum InteractionType {
  interact,
  clean,
  talk;

  String get buttonText {
    switch (this) {
      case InteractionType.interact:
        return 'Interact';
      case InteractionType.clean:
        return 'Clean Up';
      case InteractionType.talk:
        return 'Talk';
    }
  }

  Icon get icon {
    switch (this) {
      case InteractionType.interact:
        return const Icon(Icons.touch_app);
      case InteractionType.clean:
        return const Icon(Icons.cleaning_services);
      case InteractionType.talk:
        return const Icon(Icons.chat);
    }
  }
}