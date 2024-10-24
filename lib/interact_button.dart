import 'package:flutter/material.dart';

class InteractButton extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onPressed;

  const InteractButton({super.key, required this.isVisible, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink(); // Do not display if not visible
    }

    return Positioned(
      bottom: 50,
      right: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text('Interact'),
      ),
    );
  }
}
