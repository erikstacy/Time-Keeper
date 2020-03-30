import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:time_keeper/screens/display_category_screen.dart';
import 'package:time_keeper/services/globals.dart';
import 'package:time_keeper/services/models.dart';
import 'package:time_keeper/shared/loading.dart';
import 'package:time_keeper/shared/page_title.dart';

class CategoriesScreen extends StatefulWidget {

  static String id = 'categories_screen';

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {

    List<Category> categoryList = Provider.of<List<Category>>(context);
    categoryList.sort((a, b) => a.title.compareTo(b.title));

    if (categoryList != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Categories'),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.purpleAccent,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {

                String title;

                return AlertDialog(
                  title: Text('New Category'),
                  content: TextField(
                    onChanged: (value) {
                      title = value;
                    },
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('SAVE'),
                      onPressed: () {
                        Category().initializeCategory(title);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              }
            );
          },
        ),
        body: SafeArea(
          child: ListView.builder(
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              return _CategoryCard(category: categoryList[index],);
            },
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

class _CategoryCard extends StatelessWidget {

  final Category category;

  _CategoryCard({ this.category });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Global.changeCategory(category);
        Navigator.pushNamed(context, DisplayCategoryScreen.id);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              category.title,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Icon(
              FontAwesomeIcons.chevronRight,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}