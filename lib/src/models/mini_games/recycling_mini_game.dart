import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import '../dialog.dart';

class RecyclingMinigame extends StatefulWidget {
  final Function? onRecyclingCompleted;

  const RecyclingMinigame({Key? key, this.onRecyclingCompleted}) : super(key: key);

  @override
  _RecyclingMinigameState createState() => _RecyclingMinigameState();
}

class _RecyclingMinigameState extends State<RecyclingMinigame> {
  Offset boxPosition = Offset(0.4, 0.8);
  Offset plasticPosition = Offset(0.5, 0.8);
  Offset bananaPosition = Offset(0.6, 0.8);

  late Rect paperBin, plasticBin, compostBin;
  bool isBoxSorted = false;
  bool isPlasticSorted = false;
  bool isBananaSorted = false;
  bool hasShownIntroDialog = false; // This will track whether the intro dialog has been shown
  String feedbackMessage = '';
  Color feedbackColor = Colors.black;

  @override
  void initState() {
    super.initState();
    // Show the intro dialog when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showIntroDialog();
    });
  }

  void _showIntroDialog() {
    if (!hasShownIntroDialog) {
      TalkDialog.show(context, GameDialog.recyclingIntroDialog(), onFinish: () {
        setState(() {
          hasShownIntroDialog = true; // Mark as shown after the dialog finishes
        });
      });
    }
  }

  void _completeRecyclingGame() {
    TalkDialog.show(context, GameDialog.recyclingEndingDialog(), onFinish: () {
      widget.onRecyclingCompleted?.call(); // Trigger completion callback
      Navigator.pop(context); // Close the RecyclingMinigame screen after completion
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    paperBin = Rect.fromLTWH(screenWidth * 0.13, screenHeight * 0.02, screenWidth * 0.2, screenHeight * 0.2);
    plasticBin = Rect.fromLTWH(screenWidth * 0.4, screenHeight * 0.02, screenWidth * 0.2, screenHeight * 0.2);
    compostBin = Rect.fromLTWH(screenWidth * 0.66, screenHeight * 0.02, screenWidth * 0.2, screenHeight * 0.2);
  }

  bool _isInTargetZone(Offset position, Rect target) {
    return target.contains(position);
  }

  void _showFeedback(String message, Color color) {
    setState(() {
      feedbackMessage = message;
      feedbackColor = color;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        feedbackMessage = '';
      });
    });
  }

  Widget _buildDraggableItem({
    required Offset position,
    required String imagePath,
    required Rect targetBin,
    required Offset initialPosition,
    required ValueSetter<Offset> onResetPosition,
    required ValueSetter<bool> onSorted,
    required bool isSorted,
  }) {
    if (isSorted) return const SizedBox(); // Hide the item if it’s sorted

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      left: screenWidth * position.dx,
      top: screenHeight * position.dy,
      child: Draggable<Offset>(
        data: position,
        feedback: Image.asset(imagePath, width: 80, height: 80),
        childWhenDragging: Container(),
        onDraggableCanceled: (velocity, offset) {
          setState(() {
            if (_isInTargetZone(offset, targetBin)) {
              onSorted(true); // Mark as sorted if in the correct bin
              _showFeedback("Correct bin, good job!", Colors.white); // Change this to make a sound instead
            } else if (_isInTargetZone(offset, paperBin) ||
                _isInTargetZone(offset, plasticBin) ||
                _isInTargetZone(offset, compostBin)) {
              _showFeedback("Wrong bin, try again!", Colors.red);
              onResetPosition(initialPosition); // Reset to original position
            } else {
              onResetPosition(initialPosition); // Reset to original position if dropped outside all bins
            }

            _checkGameCompletion(); // Check if all items have been sorted
          });
        },
        child: Image.asset(imagePath, width: 80, height: 80),
      ),
    );
  }

  void _checkGameCompletion() {
    if (isBoxSorted && isPlasticSorted && isBananaSorted) {
      _completeRecyclingGame(); // Trigger the callback if all items are sorted
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/recycling_minigame_background.jpg',
              fit: BoxFit.cover,
            ),
          ),

          if (feedbackMessage.isNotEmpty)
            Center(
              child: Text(
                feedbackMessage,
                style: TextStyle(color: feedbackColor, fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),

          _buildDraggableItem(
            position: boxPosition,
            imagePath: 'assets/images/trash/trash_box.png',
            targetBin: paperBin,
            initialPosition: Offset(0.4, 0.8),
            onResetPosition: (newPosition) => setState(() => boxPosition = newPosition),
            onSorted: (sorted) => setState(() => isBoxSorted = sorted),
            isSorted: isBoxSorted,
          ),
          _buildDraggableItem(
            position: plasticPosition,
            imagePath: 'assets/images/trash/trash_plasticbag.png',
            targetBin: plasticBin,
            initialPosition: Offset(0.5, 0.8),
            onResetPosition: (newPosition) => setState(() => plasticPosition = newPosition),
            onSorted: (sorted) => setState(() => isPlasticSorted = sorted),
            isSorted: isPlasticSorted,
          ),
          _buildDraggableItem(
            position: bananaPosition,
            imagePath: 'assets/images/trash/trash_apple.png',
            targetBin: compostBin,
            initialPosition: Offset(0.6, 0.8),
            onResetPosition: (newPosition) => setState(() => bananaPosition = newPosition),
            onSorted: (sorted) => setState(() => isBananaSorted = sorted),
            isSorted: isBananaSorted,
          ),
        ],
      ),
    );
  }
}
