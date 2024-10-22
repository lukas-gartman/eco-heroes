import 'package:bonfire/bonfire.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart'; // Import this for the BuildContext

class GameDialog {
  static Future<void> introDialog(BuildContext context) async {
    // Use await to ensure the dialog is shown asynchronously
    await TalkDialog.show(context, [
      _speak(text: "Hello, ! I've been expecting you.", isHero: true, imagepath: 'assets/images/player/player_idle_right.png'),
      _speak(text: "Hahaha! You cannot defeat me, Villain!", isHero: false, imagepath: 'assets/images/player/player_idle_right.png'),
    ]);
  }

  static Future<void> minigameDialog1(BuildContext context) async{
    await TalkDialog.show(context, [
      _speak(text: "Help us EcoHero, our park has been trashed by the Ecovillain.", isHero: false, imagepath: 'assets/images/player/player_idle_right.png'),
      _speak(text: "Pick up all the trash and and put it in the trashcan.", isHero: false, imagepath: 'assets/images/player/player_idle_right.png'),
    ]);
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
