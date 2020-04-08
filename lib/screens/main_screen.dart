import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:time_keeper/screens/categories_screen.dart';
import 'package:time_keeper/screens/login_screen.dart';
import 'package:time_keeper/screens/task_screen.dart';
import 'package:time_keeper/screens/totals_screen.dart';
import 'package:time_keeper/services/auth.dart';
import 'package:time_keeper/services/models.dart';

class MainScreen extends StatefulWidget {

  static String id = 'main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {

    List<Category> categoryList = Provider.of<List<Category>>(context);
    categoryList.sort((a, b) => a.chooseTimeToCompare(0).compareTo(b.chooseTimeToCompare(0)));
    categoryList = categoryList.reversed.toList();

    Task task = Provider.of<Task>(context);
    User user = Provider.of<User>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Time Keeper'),
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        drawer: MainDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CurrentActivityCard(task: task,),
            NewDayCard(categoryList: categoryList, task: task, user: user,),
            TotalsCard(categoryList: categoryList,),
          ],
        ),
      ),
    );
  }
}

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Stack(
              children: [
                Positioned(
                  bottom: 12,
                  left: 16,
                  child: Text(
                    'Time Keeper',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.purple,
                  Colors.grey[800],
                  Colors.black,
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.cubes),
            title: Text('Categories'),
            onTap: () {
              Navigator.pushNamed(context, CategoriesScreen.id);
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.signOutAlt),
            title: Text('Sign Out'),
            onTap: () {
              AuthService().signOut();
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            },
          ),
        ],
      ),
    );
  }
}

class CurrentActivityCard extends StatelessWidget {

  final Task task;

  CurrentActivityCard({ this.task });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, TaskScreen.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.walking,
                    color: Colors.blue,
                    size: 18,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    'Current Activity',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            task.printRawTotal(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            'TOTAL TIME',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'CATEGORY',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                task.categoryTitle,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'START TIME',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                task.printRawStartTime(),
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewDayCard extends StatelessWidget {

  final Task task;
  final List<Category> categoryList;
  final User user;

  NewDayCard({ this.task, this.categoryList, this.user });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await task.endDay(categoryList, user);
        Navigator.pushNamed(context, TaskScreen.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.calendarDay,
                    color: Colors.purpleAccent,
                    size: 18,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    'Start New Day',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Start a ',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'NEW DAY ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.purpleAccent,
                      ),
                    ),
                    Text(
                      'here!',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

class TotalsCard extends StatelessWidget {

  final List<Category> categoryList;

  TotalsCard({ this.categoryList });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, TotalsScreen.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.clock,
                    color: Colors.yellowAccent,
                    size: 18,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    'Total Time',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20,),
                    child: Text(
                      'Today\'s Totals',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              categoryList[0].title,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              categoryList[0].displayTodayTime(),
                              style: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              categoryList[1].title,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              categoryList[1].displayTodayTime(),
                              style: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              categoryList[2].title,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              categoryList[2].displayTodayTime(),
                              style: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}