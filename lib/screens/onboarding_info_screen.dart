import 'package:flutter/material.dart';
import 'package:time_keeper/screens/main_screen.dart';

class OnboardingInfoScreen extends StatefulWidget {

  static String id = 'onboarding_info_screen';

  @override
  _OnboardingInfoScreenState createState() => _OnboardingInfoScreenState();
}

class _OnboardingInfoScreenState extends State<OnboardingInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Text(
              'App information',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'This app is designed to help you track how much time you\'re spending on certain tasks throughout the day. Create categories for everything that you would like to track throughout your day. You can get stats on how much time you\'ve spent per category as well! Thank you for using Time Keeper and I hope you enjoy it!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[200],                
                ),
              ),
            ),
            SizedBox(height: 20,),
            RaisedButton(
                child: Text(
                  'Open Time Keeper',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                color: Colors.purpleAccent,
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: () async {
                  /*
                  var user = await _auth.emailRegister(email, password);
                  if (user != null) {
                    Navigator.pushReplacementNamed(context, MainScreen.id);
                  }
                  */
                  Navigator.pushReplacementNamed(context, MainScreen.id);
                },
              ),
          ],
        ),
      ),
    );
  }
}