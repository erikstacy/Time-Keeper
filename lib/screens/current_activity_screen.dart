import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_keeper/screens/task_screen.dart';
import 'package:time_keeper/services/models.dart';
import 'package:time_keeper/shared/page_title.dart';

class CurrentActivityScreen extends StatefulWidget {

  static String id = 'current_activity_screen';

  @override
  _CurrentActivityScreenState createState() => _CurrentActivityScreenState();
}

class _CurrentActivityScreenState extends State<CurrentActivityScreen> {
  @override
  Widget build(BuildContext context) {

    Task task = Provider.of<Task>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            PageTitle(title: "Current Activity",),
            SizedBox(height: 10,),
            TaskCard(task: task),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'End the day',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      FlatButton(
                        child: Text('CONFIRM'),
                        onPressed: () {                           
                          List<Category> categoryList = Provider.of<List<Category>>(context);
                          task.endDay(categoryList);
                          Navigator.pushNamed(context, TaskScreen.id);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {

  final Task task;

  TaskCard({ this.task });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 30,),
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "CATEGORY",
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  color: Colors.grey[400],
                ),
              ),
            ),
            SizedBox(height: 5,),
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                task.categoryTitle,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                task.printStartTime(),
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 0.25,
                  color: Colors.grey[400],
                ),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('DONE'),
                  onPressed: () {
                    Navigator.pushNamed(context, TaskScreen.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}