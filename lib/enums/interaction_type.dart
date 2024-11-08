import 'package:flutter/material.dart';

enum InteractionType {
  interact,
  clean,
  talk,
  recycle,
  onOff,
  plant;


  String get buttonText {
    switch (this) {
      case InteractionType.interact:
        return 'Interact';
      case InteractionType.clean:
        return 'Clean Up';
      case InteractionType.talk:
        return 'Talk';
      case InteractionType.recycle:
        return 'Recycle';
      case InteractionType.onOff:
        return 'Turn On/Off';
      case InteractionType.plant:
        return 'Plant';
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
      case InteractionType.recycle:
        return const Icon(Icons.recycling);
      case InteractionType.onOff:
        return const Icon(Icons.lightbulb);
      case InteractionType.plant:
        return const Icon(Icons.eco);
    }
  }
}