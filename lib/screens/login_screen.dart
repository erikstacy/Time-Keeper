import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_keeper/screens/main_screen.dart';
import 'package:time_keeper/screens/register_screen.dart';
import 'package:time_keeper/services/auth.dart';
import 'package:time_keeper/services/form_validation.dart';
import 'package:time_keeper/shared/warning_alert.dart';

class LoginScreen extends StatefulWidget {

  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  AuthService _auth = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
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
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Email",
                      hintStyle: TextStyle(fontSize: 14, color: Colors.white,),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                    ),
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
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Password",
                      hintStyle: TextStyle(fontSize: 14, color: Colors.white,),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
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
                  onPressed: () => loginButtonPress(context),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RegisterScreen.id);
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loginButtonPress(context) async {
    int formResult = await FormValidation.validateEmailLogin(emailController.text, passwordController.text);

    if (formResult == 0) {
      Navigator.pushReplacementNamed(context, MainScreen.id);
    } else if (formResult == 1) {
      showDialog(
        context: context,
        builder: (context) {
          return WarningAlert(
            title: 'Wrong account information',
            content: 'The username or password may be wrong. If you don\'t have an account yet then tap on Register at the bottom of the screen.',
          );
        },
      );
      setState(() {
        emailController.text = "";
        passwordController.text = "";
      });
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
      setState(() {
        emailController.text = "";
        passwordController.text = "";
      });
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
      setState(() {
        emailController.text = "";
        passwordController.text = "";
      });
    }
  }
}