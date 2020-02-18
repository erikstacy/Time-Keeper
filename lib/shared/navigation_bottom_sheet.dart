import 'package:flutter/material.dart';
import 'package:time_keeper/screens/day_tracker_screen.dart';
import 'package:time_keeper/screens/edit_categories_screen.dart';

class NavigationBottomSheet extends StatelessWidget {
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
          title: Text('Edit Categories'),
          onTap: () {
            Navigator.pushNamed(context, EditCategoriesScreen.id);
          },
        ),
      ],
    );
  }
}