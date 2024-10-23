import 'package:flutter/material.dart';

import 'settings_page.dart';

class SettingsRoute {
  static const String routeName = '/settings';

  static Map<String, WidgetBuilder> get builder {
    return {
      routeName: (context) => const SettingsPage(),
    };
  }

  static Future open(BuildContext context) {
    return Navigator.pushNamed(context, routeName);
  }
}