import 'package:flutter/material.dart';
import 'package:time_keeper/screens/login_screen.dart';
import 'package:time_keeper/screens/main_screen.dart';
import 'package:time_keeper/screens/task_screen.dart';
import 'package:time_keeper/services/auth.dart';
import 'package:time_keeper/shared/page_title.dart';

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
            Text(
              'Enter your email',
            ),
            Text(
              'This will be the email you login with.',
            ),
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
            RaisedButton(
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              color: Colors.purpleAccent,
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: () async {
                var user = await _auth.emailRegister(email, password);
                if (user != null) {
                  Navigator.pushReplacementNamed(context, MainScreen.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}