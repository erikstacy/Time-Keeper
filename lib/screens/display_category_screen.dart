import 'package:flutter/material.dart';
import 'package:time_keeper/screens/main_screen.dart';
import 'package:time_keeper/services/globals.dart';
import 'package:time_keeper/services/models.dart';
import 'package:time_keeper/shared/page_title.dart';

class DisplayCategoryScreen extends StatefulWidget {

  static String id = 'display_category_screen';

  @override
  _DisplayCategoryScreenState createState() => _DisplayCategoryScreenState();
}

class _DisplayCategoryScreenState extends State<DisplayCategoryScreen> {
  @override
  Widget build(BuildContext context) {

    Category category = Global.currentCategory;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PageTitle(title: category.title,),
              SizedBox(height: 30,),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: <Widget>[
                      TimeCard(
                        label: 'TODAY',
                        time: category.displayTodayTime(),
                      ),
                      TimeCard(
                        label: 'YESTERDAY',
                        time: category.displayYesterdayTime(),
                      ),
                      TimeCard(
                        label: 'WEEK',
                        time: category.displayWeekTime(),
                      ),
                      TimeCard(
                        label: 'MONTH',
                        time: category.displayMonthTime(),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
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
                              Navigator.popUntil(context, ModalRoute.withName(MainScreen.id));
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
            ],
          ),
        ),
      ),
    );
  }
}

class TimeCard extends StatelessWidget {

  final String label;
  final String time;

  TimeCard({ this.label, this.time });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
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
          SizedBox(height: 20,),
          Text(
            time,
            style: TextStyle(
              fontSize: 36,
            ),
          ),
        ],
      ),
    );
  }
}