import 'package:eco_heroes/src/pages/game/game_route.dart';
import 'package:flutter/widgets.dart';

import 'src/pages/home/home_route.dart';
import 'src/pages/settings/settings_route.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    ...HomeRoute.builder,
    ...SettingsRoute.builder,
    ...GameRoute.builder,
  };
}