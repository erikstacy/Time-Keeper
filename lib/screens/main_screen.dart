import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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

  RefreshController refreshController = RefreshController(initialRefresh: false);

  Task task;

  @override
  Widget build(BuildContext context) {

    List<Category> categoryList = Provider.of<List<Category>>(context);
    categoryList.sort((a, b) => a.chooseTimeToCompare(0).compareTo(b.chooseTimeToCompare(0)));
    categoryList = categoryList.reversed.toList();

    task = Provider.of<Task>(context);
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
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(),
          controller: refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CurrentActivityCard(task: task,),
              NewDayCard(categoryList: categoryList, task: task, user: user,),
              TotalsCard(categoryList: categoryList,),
            ],
          ),
        ),
      ),
    );
  }

  void _onRefresh() {
    setState(() {
      task = Provider.of<Task>(context);
    });
    refreshController.refreshCompleted();
  }

  void _onLoading() {
    refreshController.loadComplete();
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
        bool confirmed = false;

        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you sure?'),
              content: Text(
                'Only accept if you\'re starting a new day.',
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('YES'),
                  onPressed: () async {
                    confirmed = true;
                    Navigator.pop(context);
                    await task.endDay(categoryList, user);
                  },
                ),
                FlatButton(
                  child: Text('NO'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }
        );
        if (confirmed == true) {
          Navigator.pushNamed(context, TaskScreen.id);
        }        
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
                      if (categoryList.length > 0) SingleTotalCategory(category: categoryList[0]),
                      if (categoryList.length > 1) SingleTotalCategory(category: categoryList[1]),
                      if (categoryList.length > 2) SingleTotalCategory(category: categoryList[2]),
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

class SingleTotalCategory extends StatelessWidget {

  final Category category;

  SingleTotalCategory({ this.category });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            category.title,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 5,),
          Text(
            category.displayTodayTime(),
            style: TextStyle(
              color: Colors.yellowAccent,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}