import 'package:flutter/material.dart';
import 'package:time_keeper/screens/main_screen.dart';
import 'package:time_keeper/screens/register_screen.dart';
import 'package:time_keeper/services/auth.dart';
import 'package:time_keeper/shared/page_title.dart';

class LoginScreen extends StatefulWidget {

  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  AuthService _auth = AuthService();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, top: 50,),
              child: PageTitle(title: 'Time Keeper',),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 25,
                            letterSpacing: .6,
                          ),
                        ),
                        SizedBox(height: 30,),
                        Text(
                          'Email',
                        ),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "email",
                            hintStyle: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                        SizedBox(height: 20,),
                        Text(
                          'Password',
                        ),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "password",
                            hintStyle: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterScreen.id);
                    },
                  ),
                  RaisedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      var user = await _auth.emailLogin(email, password);
                      if (user != null) {
                        Navigator.pushReplacementNamed(context, MainScreen.id);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}