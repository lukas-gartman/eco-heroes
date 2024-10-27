import 'package:bonfire/bonfire.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart'; // Import this for the BuildContext

class GameDialog {
  static List<Say> introDialog() {
    return [
      _speak(text: "Hello! I've been expecting you.", isHero: true, imagepath: 'assets/images/player/player_run_right.png'),
      _speak(text: "Hahaha! You cannot defeat me, Villain!", isHero: false, imagepath: 'assets/images/player/player_idle_right.png'),
    ];
  }

  static List<Say> trashPickingIntroDialog() {
    return [
      _speak(text: "Help us Eco Hero, our park has been trashed by the Eco Villain.", isHero: false, imagepath: 'assets/images/squirrel.png'),
      _speak(text: "Pick up all the trash and and put it in the trash can.", isHero: false, imagepath: 'assets/images/squirrel.png'),
    ];
  }

  static List<Say> trashPickingSquirrelInteract(int trashLeft) {
    return [
      _speak(text: "Thanks for helping us Eco Hero! You have $trashLeft trash to pick up before you can start sorting!", isHero: false, imagepath: 'assets/images/squirrel.png')
    ];
  }

  static List<Say> trashPickingEndDialog() {
    return [
      _speak(text: "No! How could you have cleaned up all my trash?", isHero: false, imagepath: 'assets/images/player/player_idle_right.png'),
      _speak(text: "This isn't over, Eco Hero! I'll be back!", isHero: false, imagepath: 'assets/images/player/player_idle_right.png'),
    ];
  }

  static List<Say> quizIntroDialog() {
    return [
      _speak(text: "Here's a quiz to test you on what you've learned! ", isHero: false, imagepath: 'assets/images/squirrel.png')
    ];
  }

  static List<Say> quizEndingDialog() {
    return [
      _speak(text: "You completed the quiz!", isHero: false, imagepath: 'assets/images/squirrel.png')
    ];
  }

  // Helper method to structure the dialog
  static Say _speak({required String text, required bool isHero, required String imagepath}) {
    return Say(
      text: [
        TextSpan(text: text),
      ],
      person: SizedBox(
        height: 80,
        width: 320,
        child: isHero
            ? Image.asset('assets/images/player/player_idle_right.png') // Ecohero
            : Image.asset(imagepath), //image path to the respondant of the dialog
      ),
      personSayDirection: isHero ? PersonSayDirection.LEFT : PersonSayDirection.RIGHT,
    );
  }
}