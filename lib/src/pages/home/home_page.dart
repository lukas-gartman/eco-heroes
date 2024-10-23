import 'package:eco_heroes/src/pages/game/game_route.dart';
import 'package:eco_heroes/src/pages/settings/settings_route.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Eco Hero Adventures"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            SizedBox(
              width: 250,
              child: FilledButton(
                onPressed: () => GameRoute.open(context),
                child: const Text("Play"),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () => SettingsRoute.open(context),
                child: const Text("Settings"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}