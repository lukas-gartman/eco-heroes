import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

class GameDialog {

  //Narrator = Squirrel
  static String narrator = 'assets/images/squirrel.png';
  //EcoHero
  static String ecohero = 'assets/images/player/eco_hero_dialogue.png';
  //EcoFiend
  static String ecofiend = 'assets/images/player/eco_fiend_dialogue.png';

  //Introduction

  static List<Say> introMeetTheHeroPart1() {
    return [
      _speak(text: "Welcome, Eco Hero! You're about to go on an exciting adventure to save this city from pollution and destruction. But before you start, let's talk about something really important—the United Nations' Sustainable Development Goals, or SDGs for short!", isHero: false, imagepath: narrator),
      _speak(text: "These are 17 goals set by countries all over the world to make our planet a better place. You'll be focusing on two of them during your mission:", isHero: false, imagepath: narrator),
      _speak(text: "Goal 11 is all about making our cities better places to live. It means cleaner streets, parks, and less waste. And Goal 13 is about taking care of our climate by protecting nature and using energy wisely.", isHero: true, imagepath: ecohero),
      _speak(text: "Together, we can make sure cities like this one become colorful, clean, and safe for everyone. Are you ready to help make that happen? Let's go!", isHero: true, imagepath: ecohero),
    ];
  }

  static List<Say> introMeetTheHeroPart2() {
    return [
      _speak(text: "Welcome, Eco Hero! You've arrived just in time. Our city is in trouble, and only you can save it from the clutches of the Eco Fiend!", isHero: false, imagepath: narrator),
      _speak(text: "Hahaha! Look at this mess! I thrive in pollution and chaos. Watch as I ruin your precious city, starting with the park!", isHero: false, imagepath: ecofiend),
    ];
  }

  //Minigame 1 - Trash Picking
  //Citizen = Squirrel

  static List<Say> trashPickingIntroDialog() {
    return [
      _speak(text: "Eco Hero, please help us! The park is being covered in trash, and it's becoming unusable! Can you clean it up?", isHero: false, imagepath: narrator),
      _speak(text: "Of course! Keeping our parks clean is important for a healthy environment. I'll pick up the trash and sort it to recycle as much as possible.", isHero: true, imagepath: ecohero),
      _speak(text: "Thanks Eco Hero, once you've picked up all the trash recycle them over to the left.", isHero: false, imagepath: narrator),
    ];
  }

  static List<Say> trashPickingSquirrelInteract(int trashLeft) {
    if (trashLeft == 0) {
      return [
        _speak(text: "Great job Eco Hero! You've cleaned up all the trash!", isHero: false, imagepath: narrator),
        _speak(text: "You can now start sorting the trash into the correct bins.", isHero: false, imagepath: narrator),
      ];
    } else {
      return [
        _speak(text: "You still have $trashLeft trash to pick up before you can start to recycle!", isHero: false, imagepath: narrator),
      ];
    }

  }

  static List<Say> trashPickingRecyclingInteract(int trashLeft) {
    if (trashLeft == 0) {
      return [
        _speak(text: "Great job Eco Hero! You've cleaned up all the trash!", isHero: false, imagepath: narrator),
        _speak(text: "You can now start sorting the trash into the correct bins.", isHero: false, imagepath: narrator),
      ];
    } else {
      return [
        _speak(text: "You still have $trashLeft trash to pick up before you can start to recycle!", isHero: false, imagepath: narrator),
      ];
    }
  }

  static List<Say> trashPickingEndDialog() {
    return [
      _speak(text: "No! How could you have cleaned up all my trash?", isHero: false, imagepath: ecofiend),
      _speak(text: "This isn't over, Eco Hero! I'll be back!", isHero: false, imagepath: ecofiend),
      _speak(text: "Thank you for saving the park Eco Hero! Now head over to the recycle bins to sort the trash.", isHero: false, imagepath: narrator),
    ];
  }
  static List<Say> recyclingIntroDialog() {
    return [
      _speak(text: "Help us recycle by putting each piece of trash in the correct bins!", isHero: false, imagepath: narrator)      
    ];
  }
  static List<Say> recyclingEndingDialog() {
    return [
      _speak(text: "Great job, Eco Hero! By cleaning up and sorting the trash, you're helping Goal 11: Sustainable Cities and Communities. A clean park means a better place for everyone!", isHero: false, imagepath: narrator)      
    ];
  }

  //Minigame 2 - Planting Trees

  static List<Say> introForestAttack() {
    return [
      //Change sprite
      _speak(text: "Hmph! You may have cleaned the park, but what will you do when I chop down the forest?", isHero: false, imagepath: ecofiend),
    ];
  }

  static List<Say> plantingIntroDialogue() {
    return [
      _speak(text: "Eco Hero, look! The Eco Fiend is destroying the forest! Can you help us replant the trees?", isHero: false, imagepath: narrator),
      _speak(text: "Yes! Trees are crucial for clean air and fighting climate change. Replanting them helps with Goal 13: Climate Action.", isHero: true, imagepath: ecohero),
      _speak(text: "Here are some seeds, please plant them so that the forrest can grow back!", isHero: false, imagepath: narrator),
    ];
  }

  static List<Say> plantingSquirrelDialog(int seedsLeft) {
    return [
      _speak(text: "Thanks for doing this for us Eco Hero. You have $seedsLeft seeds to plant until you've saved the forest!", isHero: false, imagepath: narrator)
    ];
  }

  static List<Say> plantingEndDialog() {
    return [
      _speak(text: "Well done, Eco Hero! Planting trees helps absorb carbon dioxide and keeps our planet healthy. Goal 13 is all about taking action to protect the climate.", isHero: false, imagepath: narrator),
    ];
  }


  //Minigame 3 - Apartment

  static List<Say> introHouseSabotageDialog() {
    return [
      _speak(text: "You may have won the park and forest, but now I'll waste all the energy and water in this house! Let's see how you fix this!", isHero: false, imagepath: ecofiend),
    ];
  }

  static List<Say> apartmentIntroDialog() {
    return [
      _speak(text: "Eco Hero, the Eco Fiend is wasting energy and water! We need your help to turn off everything we don't need!", isHero: false, imagepath: narrator),
      _speak(text: "No problem! Conserving energy and water is part of keeping cities sustainable. Let's stop the waste and save resources.", isHero: true, imagepath: ecohero),
    ];
  }

  static List<Say> apartmentEndDialog() {
    return [
      _speak(text: "Good job Eco Hero! You've saved the house from the Eco Fiend's waste!", isHero: false, imagepath: narrator),
      _speak(text: "By saving energy and water, you're helping Goal 11 again—keeping cities sustainable and resources protected for everyone.", isHero: false, imagepath: narrator),
    ];
  }
  
  //Minigame 4 - Quiz

  static List<Say> quizIntroDialog() {
    return [
      _speak(text: "Grr... you may have won, but can you teach others what you've learned? We'll see!", isHero: false, imagepath: ecofiend),
      _speak(text: "You've done it, Eco Hero! You've saved the city from the Eco Fiend's chaos, and now it's time to share what you've learned. Are you ready for the final quiz? Let's see how much you know about Goals 11 and 13!", isHero: false, imagepath: narrator)
    ];
  }

  static List<Say> quizEndingDialog() {
    return [
      _speak(text: "You completed the quiz! Well done!", isHero: false, imagepath: narrator)
    ];
  }

  //Ending

  static List<Say> cityIsSavedDialog() {
    return [
      _speak(text: "Congratulations, Eco Hero! You've not only defeated the Eco Fiend, you also helped create a more sustainable, thriving city. Remember, every little action counts toward making the world a better place!", isHero: false, imagepath: narrator),
      _speak(text: "Now think about what you can do yourself to keep up with the Sustainable Development Goals 11 and 13!\n\nDiscuss with your friends!\nHave you heard about these goals before? Can you find out what the other goals are about?", isHero: false, imagepath: narrator),
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
            ? Image.asset(ecohero) // Ecohero
            : Image.asset(imagepath), //image path to the respondant of the dialog
      ),
      personSayDirection: isHero ? PersonSayDirection.LEFT : PersonSayDirection.RIGHT,
    );
  }
}