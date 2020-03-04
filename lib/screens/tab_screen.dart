import 'package:flutter/material.dart';
import 'package:time_keeper/screens/current_activity_screen.dart';
import 'package:time_keeper/screens/profile_screen.dart';
import 'package:time_keeper/screens/totals_screen.dart';

class TabScreen extends StatefulWidget {

  static String id = 'tab_screen';

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: TabBar(
          tabs: <Widget>[
            Tab(icon: Icon(Icons.directions_walk),),
            Tab(icon: Icon(Icons.calendar_today),),
            Tab(icon: Icon(Icons.person),),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            CurrentActivityScreen(),
            TotalsScreen(),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }
}