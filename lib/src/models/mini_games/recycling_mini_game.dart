import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import '../dialog.dart';
import '../enums/trash_type.dart';
import '../interactive_objects/trash.dart';

class RecyclingMinigame extends StatefulWidget {
  final List<Trash> trashObjects;
  final Function? onRecyclingCompleted;

  const RecyclingMinigame({super.key, required this.trashObjects, this.onRecyclingCompleted});

  @override
  RecyclingMinigameState createState() => RecyclingMinigameState();
}

class RecyclingMinigameState extends State<RecyclingMinigame> {
  late List<Trash> trashObjects;
  late Rect paperBin, plasticBin, compostBin;
  late List<Offset> trashPositions;
  late List<int> sortedTrash;

  bool hasShownIntroDialog = false; // This will track whether the intro dialog has been shown
  String feedbackMessage = '';
  Color feedbackColor = Colors.black;
  bool showDropZone = false;

  @override
  void initState() {
    super.initState();

    trashObjects = widget.trashObjects..shuffle();
    trashPositions = List.generate(trashObjects.length, (index) => Offset((index * 0.04), (index % 2 == 0 ? 0.75 : 0.85)));
    sortedTrash = [];

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
        onDragStarted: () => setState(() => showDropZone = true),
        childWhenDragging: Container(),
        onDraggableCanceled: (velocity, offset) {
          setState(() {
            showDropZone = false;

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
    if (sortedTrash.length == trashObjects.length) {
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

          if (showDropZone) ...[
            for (Rect bin in [paperBin, plasticBin, compostBin]) ...[
              Positioned(
                left: bin.left,
                top: bin.top,
                child: Container(
                  width: bin.width,
                  height: bin.height,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 5),
                  ),
                ),
              ),
            ],
          ],

          if (feedbackMessage.isNotEmpty) ...[
            Center(
              child: Stack(
                children: [
                  Text(
                    feedbackMessage,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = Colors.black,
                    ),
                  ),
                  Text(
                    feedbackMessage,
                    style: TextStyle(color: feedbackColor, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ),
          ],

          ...trashObjects.asMap().entries.map((entry) {
            int index = entry.key;
            Trash trash = entry.value;
            Offset initialPosition = trashPositions[index];

            Rect targetBin;
            switch (trash.trashType) {
              case TrashType.paper:
                targetBin = paperBin;
                break;
              case TrashType.plastic:
                targetBin = plasticBin;
                break;
              case TrashType.compost:
                targetBin = compostBin;
                break;
            }

            return _buildDraggableItem(
              position: initialPosition,
              imagePath: "assets/images/${trash.spriteSrc}",
              targetBin: targetBin,
              initialPosition: initialPosition,
              onResetPosition: (newPosition) => setState(() => trashPositions[index] = newPosition),
              onSorted: (sorted) => setState(() { if (sorted) sortedTrash.add(index); }),
              isSorted: sortedTrash.contains(index),
            );
          }),
        ],
      ),
    );
  }
}
