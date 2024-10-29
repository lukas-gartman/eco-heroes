import 'package:flutter/widgets.dart';

import 'pages/home/home_route.dart';
import 'pages/game/game_route.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    ...HomeRoute.builder,
    ...GameRoute.builder,
  };
}