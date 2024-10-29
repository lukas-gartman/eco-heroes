import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../game/game_route.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    FlameAudio.bgm.stop();
    FlameAudio.bgm.play('loop_music.wav');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 264,
                  height: 50,
                  child: FilledButton(
                    onPressed: () => GameRoute.open(context),
                    child: const Text("Start Game", style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}