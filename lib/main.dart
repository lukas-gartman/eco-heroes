import 'package:bonfire/bonfire.dart';
import 'package:eco_heroes/app_routes.dart';
import 'package:flutter/material.dart';

void main() {
  // TODO: Load sprite sheets here
  // i.e. from lib/sprite_sheet/sprite_sheet_player.dart
  // await SpriteSheetPlayer.load();
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  Flame.device.setLandscape();
  Flame.device.fullScreen();
  runApp(const EcoHeroes());
}

class EcoHeroes extends StatelessWidget {
  const EcoHeroes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Eco Heroes",
      theme: ThemeData(primarySwatch: Colors.green),
      routes: AppRoutes.routes,
    );
  }
}