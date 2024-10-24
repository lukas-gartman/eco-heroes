import 'package:eco_heroes/src/models/interactive_object.dart';
import 'package:eco_heroes/src/models/interactive_objects/squirrelNPC.dart';
import 'package:eco_heroes/src/models/interactive_objects/trash.dart';
import 'package:flutter/material.dart';

class InteractButton extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onPressed;
   final InteractiveObject? currentObject;

  const InteractButton({super.key, required this.isVisible, required this.onPressed, required this.currentObject});

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink(); // Do not display if not visible
    }

    String buttonText = '';

    if (currentObject is Trash) {
      buttonText = 'Clean Up';
    } else if (currentObject is SquirrelNPC) {
      buttonText = 'Talk';
    }

    return Positioned(
      bottom: 50,
      right: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Icon(buttonIcon), // Add the icon
            const SizedBox(width: 8), // Space between icon and text
            Text(buttonText), // Add the text
          ],
        ),
      ),
    );
  }
}
