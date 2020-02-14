import 'package:flutter/material.dart';
import 'package:time_keeper/screens/login_screen.dart';
import 'package:time_keeper/screens/register_screen.dart';
import 'package:time_keeper/screens/test_screen.dart';
import 'package:time_keeper/screens/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Keeper',
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        TestScreen.id: (context) => TestScreen(),
      },
      theme: ThemeData.dark(),
    );
  }
}