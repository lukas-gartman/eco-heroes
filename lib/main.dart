import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import 'app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Load sprite sheets here
  // i.e. from lib/sprite_sheet/sprite_sheet_player.dart
  // await SpriteSheetPlayer.load();
  await Flame.device.setLandscape();
  await Flame.device.fullScreen();
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
      // home: Game()
    );
  }
}
