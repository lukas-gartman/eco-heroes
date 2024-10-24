import 'package:eco_heroes/src/models/enums/interaction_type.dart';
import 'package:flutter/material.dart';

class InteractButton extends StatelessWidget {
  final InteractionType interactionType;
  final VoidCallback onPressed;

  const InteractButton({super.key, required this.interactionType, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      right: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            interactionType.icon,
            const SizedBox(width: 8), // Space between icon and text
            Text(interactionType.buttonText),
          ],
        ),
      ),
    );
  }
}
