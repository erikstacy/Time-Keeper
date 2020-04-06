import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            SizedBox(height: 40,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  children: <Widget>[
                    GridCard(
                      icon: FontAwesomeIcons.cubes,
                      content: 'Categories should be created for every type of task you want to track.',
                      color: Colors.greenAccent,
                    ),
                    GridCard(
                      icon: FontAwesomeIcons.walking,
                      content: 'Current Activity should always reflect what you\'re currently doing.',
                      color: Colors.blue,
                    ),
                    GridCard(
                      icon: FontAwesomeIcons.calendarDay,
                      content: 'A new day should be created as soon as you wake up.',
                      color: Colors.purpleAccent,
                    ),
                    GridCard(
                      icon: FontAwesomeIcons.clock,
                      content: 'Totals shows how much time has been spent on each category.',
                      color: Colors.yellowAccent,
                    ),
                  ],
                ),
              ),
            ),
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

class GridCard extends StatelessWidget {

  final Color color;
  final IconData icon;
  final String content;

  GridCard({ this.icon, this.content, this.color });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 50,
            color: color,
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}