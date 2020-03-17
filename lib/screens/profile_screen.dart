import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_keeper/screens/login_screen.dart';
import 'package:time_keeper/services/auth.dart';
import 'package:time_keeper/services/models.dart';
import 'package:time_keeper/shared/page_title.dart';

class ProfileScreen extends StatefulWidget {

  static String id = 'profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                PageTitle(title: 'Profile',),
                SizedBox(height: 50,),
                Center(
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        child: Text(
                          user.email[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 40,
                          ),
                        ),
                        radius: 50,
                      ),
                      SizedBox(height: 40,),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  child: Text('Sign Out'),
                  onPressed: () {
                    AuthService().signOut();
                    Navigator.pushReplacementNamed(context, LoginScreen.id);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}