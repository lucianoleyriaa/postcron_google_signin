import 'package:flutter/material.dart';

// Screens
import 'package:postcron_google_signin/screens/screens.dart';

class AppRoutes {

  static const String initialRoute = 'login';

  static final Map<String, Widget Function(BuildContext context)> _routes = {
    'login': (BuildContext context) => const Login(),
    'app': (BuildContext context) => const App(),
  };

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return _routes;
  }

}