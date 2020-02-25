import 'package:flutter/material.dart';
import 'package:time_keeper/screens/day_tracker_screen.dart';
import 'package:time_keeper/screens/edit_categories_screen.dart';
import 'package:time_keeper/screens/monthly_total_screen.dart';
import 'package:time_keeper/screens/weekly_total_screen.dart';
import 'package:time_keeper/screens/welcome_screen.dart';
import 'package:time_keeper/screens/yesterday_total_screen.dart';
import 'package:time_keeper/services/auth.dart';

class NavigationBottomSheet extends StatelessWidget {

  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text('Day Tracker'),
          onTap: () {
            Navigator.pushNamed(context, DayTrackerScreen.id);
          },
        ),
        ListTile(
          title: Text('Yesterday Totals'),
          onTap: () {
            Navigator.pushNamed(context, YesterdayTotalScreen.id);
          },
        ),
        ListTile(
          title: Text('Weekly Totals'),
          onTap: () {
            Navigator.pushNamed(context, WeeklyTotalScreen.id);
          },
        ),
        ListTile(
          title: Text('Monthly Totals'),
          onTap: () {
            Navigator.pushNamed(context, MonthlyTotalScreen.id);
          },
        ),
        ListTile(
          title: Text('Edit Categories'),
          onTap: () {
            Navigator.pushNamed(context, EditCategoriesScreen.id);
          },
        ),
        ListTile(
          title: Text('Sign Out'),
          onTap: () {
            _auth.signOut();
            Navigator.pushReplacementNamed(context, WelcomeScreen.id);
          },
        ),
      ],
    );
  }
}