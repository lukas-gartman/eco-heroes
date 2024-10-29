import 'package:flutter/material.dart';

import '../game/game_route.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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