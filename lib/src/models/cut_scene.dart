import 'package:bonfire/util/talk/say.dart';
import 'package:bonfire/util/talk/talk_dialog.dart';
import 'package:flutter/material.dart';

class CutScene extends StatefulWidget {
  final int opacity;
  final List<Say> dialog;
  final bool cityHasBeenSaved;
  const CutScene({super.key, required this.opacity, required this.dialog, this.cityHasBeenSaved = false});

  @override
  CutSceneState createState() => CutSceneState();
}

class CutSceneState extends State<CutScene> {
  late int opacity;
  late final List<Say> dialog;
  late final bool cityHasBeenSaved;

  @override
  void initState() {
    super.initState();

    opacity = widget.opacity;
    dialog = widget.dialog;
    cityHasBeenSaved = widget.cityHasBeenSaved;

    Future.delayed(Duration.zero, () { // Wait for the widget to be built by skipping a frame
      TalkDialog.show(context, widget.dialog, onFinish: () {
        setState(() => opacity = 100); // Make the screen black
        Future.delayed(const Duration(seconds: 2), () { // Wait for 2 seconds for a more pleasant transition
          Navigator.of(context).pop();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            cityHasBeenSaved 
              ? "assets/images/cut_scenes/clean-city.jpg"
              : "assets/images/cut_scenes/dirty-city.jpg",
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(opacity / 100),
            colorBlendMode: BlendMode.darken,
          ),
        ),
      ],
    );
  }
}