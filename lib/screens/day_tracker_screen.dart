import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_keeper/services/db.dart';
import 'package:time_keeper/services/models.dart';
import 'package:time_keeper/shared/loader.dart';
import 'package:time_keeper/shared/navigation_bottom_sheet.dart';

// Global variable
String categoryTitle;

class DayTrackerScreen extends StatefulWidget {

  static String id = 'day_tracker_screen';

  @override
  _DayTrackerScreenState createState() => _DayTrackerScreenState();
}

class _DayTrackerScreenState extends State<DayTrackerScreen> {

  DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {

    var user = Provider.of<FirebaseUser>(context);

    List<Activity> activityList = [];

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text(
                'Day Tracker',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              SizedBox(height: 30,),
              Expanded(
                child: StreamBuilder(
                  stream: _db.streamActivityList(user),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return LoadingScreen();
                    } else {
                      activityList = snapshot.data;

                      return ListView.builder(
                        itemCount: activityList.length,
                        itemBuilder: (context, index) {
                          Activity activity = activityList[index];

                          return ListTile(
                            title: Text(activity.category),
                            subtitle: Text(activity.endTime.compareTo(DateTime.utc(1960, 1, 1, 12, 0, 0)) == 0 ? "Start Time: " + activity.printStartTime() : "Total Time: " + activity.printTotalTime()),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => BottomSheet(
                    onClosing: () {},
                    builder: (context) {
                      return NavigationBottomSheet();
                    },
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _db.endDay(user, activityList);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            builder: (context) => BottomSheet(
              onClosing: () {},
              builder: (context) {
                return NewCategorySheet();
              },
            ),
          );

          // Database writes
          _db.addActivity(user, categoryTitle);
          if (activityList.length != 0) {
            _db.setActivityEndTime(user, activityList[activityList.length - 1].id, DateTime.now());
          }
        }
      ),
    );
  }

  

}

class NewCategorySheet extends StatefulWidget {
  @override
  _NewCategorySheetState createState() => _NewCategorySheetState();
}

class _NewCategorySheetState extends State<NewCategorySheet> {

  DatabaseService _db = DatabaseService();

  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {

    var user = Provider.of<FirebaseUser>(context);

    return Container(
      child: Column(
        children: <Widget>[
          StreamBuilder(
            stream: _db.streamCategoryList(user),
            builder: (context, snapshot) {
              List<Category> categoryList = snapshot.data;

              if (selectedCategory == '') {
                selectedCategory = categoryList[0].title;
              }

              return ListTile(
                title: Center(
                  child: Text(selectedCategory),
                ),
                onTap: () async {
                  await showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return categoryPicker(categoryList);
                    }
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget categoryPicker(List<Category> categoryList) {
    List<Widget> widgetList = [];

    for (int i = 0; i < categoryList.length; i++) {
      widgetList.add(Center(child: Text(categoryList[i].title)));
    }

    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: CupertinoPicker(
              itemExtent: 50,
              children: widgetList,
              onSelectedItemChanged: (value) {
                setState(() {
                  categoryTitle = categoryList[value].title;
                  selectedCategory = categoryList[value].title;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
