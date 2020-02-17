import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_keeper/screens/day_screen.dart';
import 'package:time_keeper/screens/login_screen.dart';
import 'package:time_keeper/screens/register_screen.dart';
import 'package:time_keeper/screens/welcome_screen.dart';
import 'package:time_keeper/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AuthService _auth = AuthService();

    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(value: _auth.user),
      ],
      child: MaterialApp(
        title: 'Time Keeper',
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          DayScreen.id: (context) => DayScreen(),
        },
        theme: ThemeData.dark(),
      ),
    );
  }
}