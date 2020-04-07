import 'package:flutter/material.dart';
import 'package:time_keeper/screens/categories_screen.dart';
import 'package:time_keeper/screens/main_screen.dart';
import 'package:time_keeper/services/globals.dart';
import 'package:time_keeper/services/models.dart';
import 'package:time_keeper/shared/loading.dart';

class DisplayCategoryScreen extends StatefulWidget {

  static String id = 'display_category_screen';

  @override
  _DisplayCategoryScreenState createState() => _DisplayCategoryScreenState();
}

class _DisplayCategoryScreenState extends State<DisplayCategoryScreen> {

  String title = "";

  @override
  Widget build(BuildContext context) {

    Category category = Global.currentCategory;
    if (title == "") {
      title = category.title;
    }

    if (category != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(title),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TimeCard(label: "Today", time: category.displayTodayTime(),),
                      TimeCard(label: "Yesterday", time: category.displayYesterdayTime(),),
                      TimeCard(label: "Week", time: category.displayWeekTime(),),
                      TimeCard(label: "Month", time: category.displayMonthTime(),),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Divider(
                  color: Colors.grey[900],
                  thickness: 2,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        child: Text('Edit Title'),
                        color: Colors.grey[800],
                        onPressed: () async {
                          String newTitle = "";

                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Edit Title'),
                                content: TextField(
                                  onChanged: (val) {
                                    newTitle = val;
                                  },
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('CONFIRM'),
                                    onPressed: () {
                                      category.changeTitle(newTitle);
                                      setState(() {
                                        title = newTitle;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            }
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 15,),
                    Expanded(
                      child: RaisedButton(
                        child: Text('Delete'),
                        color: Colors.red,
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Delete?'),
                                content: Text(
                                  'Deleting this Category is permanent',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('YES'),
                                    onPressed: () {
                                      category.delete();
                                      Navigator.popUntil(context, ModalRoute.withName(CategoriesScreen.id));
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
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.center,
        child: Loader(),
      );
    }
  }
}

class TimeCard extends StatelessWidget {

  final String label;
  final String time;

  TimeCard({ this.label, this.time });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            letterSpacing: 1.5,
            color: Colors.grey[400],
          ),
        ),
        SizedBox(height: 5,),
        Text(
          time,
          style: TextStyle(
            fontSize: 25,
            color: Colors.purpleAccent,
          ),
        ),
      ],
    );
  }
}