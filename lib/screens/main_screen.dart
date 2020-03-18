import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_keeper/screens/categories_screen.dart';
import 'package:time_keeper/screens/current_activity_screen.dart';
import 'package:time_keeper/screens/profile_screen.dart';
import 'package:time_keeper/screens/task_screen.dart';
import 'package:time_keeper/screens/totals_screen.dart';
import 'package:time_keeper/services/models.dart';

class MainScreen extends StatefulWidget {

  static String id = 'main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int selectedPage = 0;
  final _pageOptions = [
    CurrentActivityScreen(),
    TotalsScreen(),
    CategoriesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    Task task = Provider.of<Task>(context);
    if (task.categoryTitle == '') {
      Navigator.pushNamed(context, TaskScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        child: _pageOptions[selectedPage],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        type: BottomNavigationBarType.fixed,      
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
            title: Text("Categories"),
            icon: Icon(Icons.category),
          ),
          BottomNavigationBarItem(
            title: Text("Profile"),
            icon: Icon(Icons.person),
          ),
        ],
        onTap: (int id) {
          setState(() {
            selectedPage = id;
          });        
        },
      ),
    );
  }
}