import 'package:flutter/material.dart';
import 'package:time_keeper/screens/day_screen.dart';
import 'package:time_keeper/services/auth.dart';

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
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                email = value;
              },
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
              },
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            RaisedButton(
              child: Text('REGISTER'),
              onPressed: () async {
                var user = await _auth.emailRegister(email, password);
                if (user != null) {
                  Navigator.pushReplacementNamed(context, DayScreen.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}