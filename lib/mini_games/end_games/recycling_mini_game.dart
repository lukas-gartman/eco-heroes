import 'package:bonfire/bonfire.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import '../../helpers/dialog.dart';
import '../../enums/trash_type.dart';
import '../../interactive_objects/trash.dart';

class RecyclingMinigame extends StatefulWidget {
  final List<Trash> trashObjects;
  final Function? onRecyclingCompleted;

  const RecyclingMinigame({super.key, required this.trashObjects, this.onRecyclingCompleted});

  @override
  RecyclingMinigameState createState() => RecyclingMinigameState();
}

class RecyclingMinigameState extends State<RecyclingMinigame> {
  late List<Trash> trashObjects;
  late List<TrashOffset> trashOffsets;
  late Rect paperBin, plasticBin, compostBin;

  bool hasShownIntroDialog = false; // This will track whether the intro dialog has been shown
  String feedbackMessage = '';
  Color feedbackColor = Colors.black;
  bool showDropZone = false;

  @override
  void initState() {
    super.initState();

    trashObjects = widget.trashObjects..shuffle();
    trashOffsets = [];
    for (int i = 0; i < trashObjects.length; i++) {
      trashOffsets.add(TrashOffset(
        id: i+1,
        trash: trashObjects[i],
        imagePath: "assets/images/${trashObjects[i].spriteSrc}",
        initialPosition: Offset((i * 0.04), (i % 2 == 0 ? 0.75 : 0.85)),
      ));
    }

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
    FlameAudio.play('minigame_success.wav');
    TalkDialog.show(context, GameDialog.recyclingEndingDialog(), onFinish: () {
      widget.onRecyclingCompleted?.call(); // Trigger completion callback
      Navigator.pop(context); // Close the RecyclingMinigame screen after completion
    });
  }

  @override
  void didChangeDependencies() { // To calculate the positions of the bins to match every screen
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
    required TrashOffset trashOffset,
    required Rect targetBin,
    required ValueSetter<Offset> onResetPosition,
    required ValueSetter<bool> onSorted,
  }) {
    if (trashOffset.isSorted) return const SizedBox(); // Hide the item if it’s sorted

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      left: screenWidth * trashOffset.position.dx,
      top: screenHeight * trashOffset.position.dy,
      child: Draggable<int>(
        key: ValueKey(trashOffset.id),
        data: trashOffset.id,
        feedback: Image.asset(trashOffset.imagePath, width: 80, height: 80),
        onDragStarted: () => setState(() => showDropZone = true),
        childWhenDragging: const SizedBox.shrink(),
        onDraggableCanceled: (velocity, offset) {
          setState(() {
            showDropZone = false;

            if (_isInTargetZone(offset, targetBin)) {
              onSorted(true); // Mark as sorted if in the correct bin
              FlameAudio.play('success.wav', volume: 0.15);
              _showFeedback("Correct bin, good job!", Colors.white); // Change this to make a sound instead
            } else if (_isInTargetZone(offset, paperBin) ||
                _isInTargetZone(offset, plasticBin) ||
                _isInTargetZone(offset, compostBin)) {
              FlameAudio.play('wrong.mp3');
              _showFeedback("Wrong bin, try again!", Colors.red);
              onResetPosition(trashOffset.initialPosition); // Reset to original position
            } else {
              onResetPosition(trashOffset.initialPosition); // Reset to original position if dropped outside all bins
            }

            _checkGameCompletion(); // Check if all items have been sorted
          });
        },
        child: Image.asset(trashOffset.imagePath, width: 80, height: 80),
      ),
    );
  }

  void _checkGameCompletion() {
    if (trashOffsets.every((trashOffset) => trashOffset.isSorted)) {
      _completeRecyclingGame(); // Trigger the callback if all items are sorted
    }
  }

  Rect _getTargetBin(TrashType type) {
    switch (type) {
      case TrashType.paper:
        return paperBin;
      case TrashType.plastic:
        return plasticBin;
      case TrashType.compost:
        return compostBin;
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

          for (int index = 0; index < trashOffsets.length; index++) ...[
            _buildDraggableItem(
              trashOffset: trashOffsets[index],
              targetBin: _getTargetBin(trashOffsets[index].trash.trashType),
              onResetPosition: (newPosition) => setState(() => trashOffsets[index].position = newPosition),
              onSorted: (sorted) => setState(() { if (sorted) trashOffsets[index].isSorted = true; }),
            ),
          ],
        ],
      ),
    );
  }
}

class TrashOffset {
  final int id;
  final Trash trash;
  final String imagePath;
  final Offset initialPosition;
  Offset position;
  bool isSorted;

  TrashOffset({ required this.id, required this.trash, required this.imagePath, required this.initialPosition})
    : position = initialPosition, isSorted = false;
}