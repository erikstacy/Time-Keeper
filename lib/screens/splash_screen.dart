import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_keeper/screens/login_screen.dart';
import 'package:time_keeper/screens/main_screen.dart';
import 'package:time_keeper/services/auth.dart';

class SplashScreen extends StatefulWidget {

  static String id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();

    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.solidClock,
                    color: Colors.purple,
                    size: 80,
                  ),
                  SizedBox(height: 15,),
                  Text(
                    'Time Keeper',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 80,
                    width: 80,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getUser() {
    _auth.getUser.then(
      (user) {
        if (user != null) {
          Navigator.pushReplacementNamed(context, MainScreen.id);
        } else {
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        }
      },
    );
  }
}