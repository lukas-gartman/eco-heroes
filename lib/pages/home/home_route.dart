import 'package:flutter/material.dart';

import 'home_page.dart';

class HomeRoute {
  static const String routeName = '/';

  static Map<String, WidgetBuilder> get builder {
    return {
      routeName: (context) => const HomePage(),
    };
  }

  static Future open(BuildContext context) {
    return Navigator.pushNamed(context, routeName);
  }
}