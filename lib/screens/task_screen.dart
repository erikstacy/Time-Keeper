import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_keeper/services/models.dart';
import 'package:time_keeper/shared/loading.dart';

class TaskScreen extends StatefulWidget {

  static String id = 'task_screen';

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  Category ddCategory = Category(title: '');
  DateTime endTime = DateTime.now();
  Task task;

  @override
  Widget build(BuildContext context) {

    task = Provider.of<Task>(context);
    List<Category> categoryList = Provider.of<List<Category>>(context);
    categoryList.sort((a, b) => a.title.compareTo(b.title));

    if (task != null && categoryList != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'New Task',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'CATEGORY',
                    style: TextStyle(
                      
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: DropdownButton<Category>(
                    value: ddCategory.title == '' ? null : ddCategory,
                    hint: Text('Select'),
                    items: categoryList.map<DropdownMenuItem<Category>>((Category category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Text(
                          category.title,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (Category newCategory) {
                      setState(() {
                        ddCategory = newCategory;
                      });
                    },
                    underline: Container(),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'TIME',
                    style: TextStyle(
                      
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    child: Row(
                      children: <Widget>[
                        Text(
                          _printFormattedTime(endTime),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down,),
                      ],
                    ),
                  ),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text('CANCEL'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 10,),
                    FlatButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Text(
                          'CONFIRM',
                          style: TextStyle(
                            color: Colors.purpleAccent,
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (task.categoryTitle != '' || task.categoryTitle != '..newUser') {
                          task.finishTask(categoryList, endTime);
                        }
                        Task(categoryTitle: ddCategory.title).addToDb(endTime);
                        Navigator.pop(context);
                      },
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

  void _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    DateTime newTime = new DateTime(endTime.year, endTime.month, endTime.day, picked.hour, picked.minute);

    if (picked != null && task.startTime.compareTo(newTime) < 0) {
      setState(() {
        endTime = newTime;
      });
    }
  }
}

String _printFormattedTime(DateTime thisTime) {
  return DateFormat('hh:mm').format(thisTime);
}