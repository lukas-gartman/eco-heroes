import 'package:bonfire/bonfire.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart'; // Import this for the BuildContext

class GameDialog {

  //Narrator = Squirrel
  //EcoHero
  //EcoFiend

  //Introduction

  static List<Say> introMeetTheHero() {
    return [
      _speak(text: "Welcome, EcoHero! You’re about to go on an exciting adventure to save this city from pollution and destruction. But before you start, let’s talk about something really important—the United Nations’ Sustainable Development Goals, or SDGs for short!", isHero: false, imagepath: 'images/squirrel.png'),
      _speak(text: "These are 17 goals set by countries all over the world to make our planet a better place. You’ll be focusing on two of them during your mission:", isHero: false, imagepath: 'images/squirrel.png'),
      _speak(text: "Goal 11 is all about making our cities better places to live. It means cleaner streets, parks, and less waste. And Goal 13 is about taking care of our climate by protecting nature and using energy wisely.", isHero: true, imagepath: 'assets/images/player/eco_hero_dialogue.png'),
      _speak(text: "Together, we can make sure cities like this one become colorful, clean, and safe for everyone. Are you ready to help make that happen? Let’s go!", isHero: true, imagepath: 'assets/images/player/eco_hero_dialogue.png'),
      _speak(text: "~ Transition screen ~", isHero: false, imagepath: 'images/squirrel.png'),
      _speak(text: "Welcome, EcoHero! You’ve arrived just in time. Our city is in trouble, and only you can save it from the clutches of the Ecofiend!", isHero: false, imagepath: 'images/squirrel.png'),
      _speak(text: "Hahaha! Look at this mess! I thrive in pollution and chaos. Watch as I ruin your precious city, starting with the park!", isHero: false, imagepath: 'images/trash.png'),
    
    ];
  }

  static List<Say> introDialog() {
    return [
      _speak(text: "Hello! I've been expecting you.", isHero: true, imagepath: 'assets/images/player/eco_hero_dialogue.png'),
      _speak(text: "Hahaha! You cannot defeat me, Villain!", isHero: false, imagepath: 'assets/images/player/eco_hero_dialogue.png'),
    ];
  }


  //Minigame 1 - Trash Picking

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

  static List<Say> trashPickingRecyclingInteract(int trashLeft) {
    if (trashLeft == 0) {
      return [
        _speak(text: "Great job Eco Hero! You've cleaned up all the trash!", isHero: false, imagepath: 'assets/images/squirrel.png'),
        _speak(text: "You can now start sorting the trash into the correct bins.", isHero: false, imagepath: 'assets/images/squirrel.png'),
      ];
    } else {
      return [
        _speak(text: "You still have $trashLeft trash to pick up before you can start sorting!", isHero: false, imagepath: 'assets/images/squirrel.png'),
      ];
    }
  }

  static List<Say> trashPickingEndDialog() {
    return [
      _speak(text: "No! How could you have cleaned up all my trash?", isHero: false, imagepath: 'assets/images/player/eco_hero_dialogue.png'),
      _speak(text: "This isn't over, Eco Hero! I'll be back!", isHero: false, imagepath: 'assets/images/player/eco_hero_dialogue.png'),
      _speak(text: "Thank you for saving the park Eco Hero! Now head over to the recycle bins to sort the trash.", isHero: false, imagepath: 'assets/images/squirrel.png'),
    ];
  }
  static List<Say> recyclingIntroDialog() {
    return [
      _speak(text: "Help me recycle!.", isHero: false, imagepath: 'assets/images/squirrel.png')      
    ];
  }
  static List<Say> recyclingEndingDialog() {
    return [
      _speak(text: "Thank you for recycling all the trash EcoHero!.", isHero: false, imagepath: 'assets/images/squirrel.png')      
    ];
  }

  //Minigame 2 - Planting Trees

  static List<Say> plantingIntroDialogue() {
    return [
      _speak(text: "Oh you're here eco hero! The evil eco fiend cut down all the trees!", isHero: false, imagepath: 'assets/images/squirrel.png'),
      _speak(text: "Here are some seeds, please plant them so that the forrest can grow back!", isHero: false, imagepath: 'assets/images/squirrel.png'),
    ];
  }

  static List<Say> plantingSquirrelDialog(int seedsLeft) {
    return [
      _speak(text: "Thanks for doing this for us Eco Hero. You have $seedsLeft seeds to plant until you've saved the forest!", isHero: false, imagepath: 'assets/images/squirrel.png')
    ];
  }

  //REMEBER TO UPDATE
  static List<Say> plantingEndDialog() {
    return [
      _speak(text: "No! How could you have cleaned up all my trash?", isHero: false, imagepath: 'assets/images/player/eco_hero_dialogue.png'),
      _speak(text: "This isn't over, Eco Hero! I'll be back!", isHero: false, imagepath: 'assets/images/player/eco_hero_dialogue.png'),
    ];
  }


  //Minigame 3 - Apartment

  static List<Say> apartmentIntroDialog() {
    return [
      _speak(text: "You may have won the park and forest, but now I'll waste all the energy and water in this house! Let's see how you fix this!", isHero: false, imagepath: 'assets/images/player/eco_hero_dialogue.png'),
      _speak(text: "Eco Hero, the Eco Fiend is wasting energy and water! We need your help to turn off everything we don't need!", isHero: false, imagepath: 'assets/images/squirrel.png'),
      _speak(text: "No problem! Conserving energy and water is part of keeping cities sustainable. Let's stop the waste and save resources.", isHero: true, imagepath: 'assets/images/player/eco_hero_dialogue.png'),
    ];
  }

  static List<Say> apartmentEndDialog() {
    return [
      _speak(text: "Good job Eco Hero! You've saved the house from the Eco Fiend's waste!", isHero: false, imagepath: 'assets/images/squirrel.png'),
      _speak(text: "By saving energy and water, you're helping Goal 11 again—keeping cities sustainable and resources protected for everyone.", isHero: false, imagepath: 'assets/images/squirrel.png'),
    ];
  }
  
  //Minigame 4 - Quiz

  static List<Say> quizIntroDialog() {
    return [
      _speak(text: "Here's a quiz to test you on what you've learned! ", isHero: false, imagepath: 'assets/images/squirrel.png')
    ];
  }

  static List<Say> quizEndingDialog() {
    return [
      _speak(text: "You completed the quiz! Well done!", isHero: false, imagepath: 'assets/images/squirrel.png')
    ];
  }

  //Ending

  static List<Say> cityIsSavedDialog() {
    return [
      _speak(text: "Congratulations, Eco Hero! You've not only defeated the Eco Fiend, you also helped create a more sustainable, thriving city. Remember, every little action counts toward making the world a better place!", isHero: false, imagepath: 'assets/images/squirrel.png'),
      _speak(text: "Now think about what you can do yourself to keep up with the Sustainable Development Goals 11 and 13!\n\nDiscuss with your friends!\nHave you heard about these goals before? Can you find out what the other goals are about?", isHero: false, imagepath: 'assets/images/squirrel.png'),
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
            ? Image.asset('assets/images/player/eco_hero_dialogue.png') // Ecohero
            : Image.asset(imagepath), //image path to the respondant of the dialog
      ),
      personSayDirection: isHero ? PersonSayDirection.LEFT : PersonSayDirection.RIGHT,
    );
  }
}