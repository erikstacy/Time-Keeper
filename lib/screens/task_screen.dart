import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_keeper/services/models.dart';
import 'package:time_keeper/shared/loading.dart';
import 'package:time_keeper/shared/page_title.dart';

class TaskScreen extends StatefulWidget {

  static String id = 'task_screen';

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  Category ddCategory = Category(title: '');

  @override
  Widget build(BuildContext context) {

    Task task = Provider.of<Task>(context);
    List<Category> categoryList = Provider.of<List<Category>>(context);
    categoryList.sort((a, b) => a.title.compareTo(b.title));

    if (task != null && categoryList != null) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PageTitle(title: 'New Task',),
                SizedBox(height: 40,),
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
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text('CANCEL'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 10,),
                    RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Text('CONFIRM'),
                      ),
                      onPressed: () {
                        if (task.categoryTitle != '' || task.categoryTitle != '..newUser') {
                          task.finishTask(categoryList);
                        }
                        Task(categoryTitle: ddCategory.title).addToDb();
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
}