import 'package:flutter/material.dart';
import 'package:time_keeper/screens/current_activity_screen.dart';
import 'package:time_keeper/screens/profile_screen.dart';
import 'package:time_keeper/screens/totals_screen.dart';

class BottomBar extends StatefulWidget {

  int current;

  BottomBar(this.current);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.current,
      items: [
        BottomNavigationBarItem(
          title: Text("Activity"),
          icon: Icon(Icons.directions_run),
        ),
        BottomNavigationBarItem(
          title: Text("Totals"),
          icon: Icon(Icons.calendar_today),
        ),
        BottomNavigationBarItem(
          title: Text("Profile"),
          icon: Icon(Icons.person),
        ),
      ],
      onTap: (int id) {
        switch (id) {
          case 0:
            Navigator.pushReplacementNamed(context, CurrentActivityScreen.id);
            break;
          case 1:
            Navigator.pushReplacementNamed(context, TotalsScreen.id);
            break;
          case 2:
            Navigator.pushReplacementNamed(context, ProfileScreen.id);
            break;
        }
      },
    );
  }
}