import 'package:eco_heroes/src/pages/game/game_page.dart';
import 'package:flutter/widgets.dart';

class GameRoute {
  static const String routeName = '/game';

  static Map<String, WidgetBuilder> get builder {
    return {
      routeName: (context) => const GamePage(),
    };
  }

  static Future open(BuildContext context) {
    return Navigator.pushNamed(context, routeName);
  }
}