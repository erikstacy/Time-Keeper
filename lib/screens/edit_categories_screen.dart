import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_keeper/services/db.dart';
import 'package:time_keeper/services/models.dart';
import 'package:time_keeper/shared/loader.dart';
import 'package:time_keeper/shared/navigation_bottom_sheet.dart';

class EditCategoriesScreen extends StatefulWidget {

  static String id = 'edit_categories_screen';

  @override
  _EditCategoriesScreenState createState() => _EditCategoriesScreenState();
}

class _EditCategoriesScreenState extends State<EditCategoriesScreen> {

  DatabaseService _db = DatabaseService();

  String title = '';
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Edit Categories',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              SizedBox(height: 30,),
              Expanded(
                child: StreamBuilder(
                  stream: _db.streamCategoryList(user),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return LoadingScreen();
                    } else {
                      List<Category> categoryList = snapshot.data;

                      return ListView.builder(
                        itemCount: categoryList.length,
                        itemBuilder: (context, index) {
                          Category category = categoryList[index];

                          return ListTile(
                            title: Text(category.title),
                            onTap: () async {
                              await showModalBottomSheet(
                                context: context,
                                builder: (context) => BottomSheet(
                                  onClosing: () {},
                                  builder: (context) {
                                    titleController.text = category.title;
                                    title = category.title;

                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          TextField(
                                            controller: titleController,
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              _db.deleteCategory(user, category.id);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );

                              if (titleController.text != '' && title != titleController.text) {
                                _db.editCategory(user, category.id, titleController.text);
                              }
                              title = '';
                            },
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
            mainAxisAlignment: MainAxisAlignment.start,
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
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        onChanged: (value) {
                          title = value;
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );

          if (title != '') {
            _db.addCategory(user, title);
          }
          title = '';
        }
      ),
    );
  }
}