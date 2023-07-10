import 'package:flutter/material.dart';
import 'package:postcron_google_signin/routes/app_routes.dart';
import 'package:postcron_google_signin/screens/login_screen.dart';
import 'package:postcron_google_signin/services/auth_service.dart';
import 'package:postcron_google_signin/services/user_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => UserService()),
      ],
      child: const Postcron(),
    );

  }
}

class Postcron extends StatelessWidget {
  const Postcron({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Postcron',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.getRoutes(),
      home: const Scaffold(
        body: Login()
      )
    );
  }

}