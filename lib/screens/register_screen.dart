import 'package:flutter/material.dart';
import 'package:time_keeper/screens/onboarding_categories_screen.dart';
import 'package:time_keeper/services/auth.dart';
import 'package:time_keeper/services/form_validation.dart';
import 'package:time_keeper/shared/warning_alert.dart';

class RegisterScreen extends StatefulWidget {

  static String id = 'register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  AuthService _auth = AuthService();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Text(
              'Enter your email',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5,),
            Text(
              'This will be the email you login with.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Password",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                ),
                onChanged: (value) {
                  password = value;
                },
              ),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              child: Text(
                'Register',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              color: Colors.purpleAccent,
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: () => registerButtonPress(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> registerButtonPress(context) async {
    int formResult = await FormValidation.validateEmailRegistration(email, password);

    if (formResult == 0) {
      Navigator.pushNamed(context, OnboardingCategoriesScreen.id);
    } else if (formResult == 1) {
      showDialog(
        context: context,
        builder: (context) {
          return WarningAlert(
            title: 'Account already exists',
            content: 'You can go back a screen or Login with this account information.',
          );
        },
      );
    } else if (formResult == 2) {
      showDialog(
        context: context,
        builder: (context) {
          return WarningAlert(
            title: 'Email isn\'t formatted properly',
            content: 'Check to make sure that you have a valid email address for your email.',
          );
        },
      );
    } else if (formResult == 3) {
      showDialog(
        context: context,
        builder: (context) {
          return WarningAlert(
            title: 'Password isn\'t long enough',
            content: 'Your password must be at least 6 characters long.',
          );
        },
      );
    }
  }
}

