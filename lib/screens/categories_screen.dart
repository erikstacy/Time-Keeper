import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_keeper/screens/display_category_screen.dart';
import 'package:time_keeper/services/globals.dart';
import 'package:time_keeper/services/models.dart';
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

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('New Category'),
                content: TextField(),
                actions: <Widget>[
                  FlatButton(
                    child: Text('SAVE'),
                    onPressed: () {
                      // Todo - Implement this
                    },
                  ),
                ],
              );
            }
          );
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PageTitle(title: "Categories",),
              SizedBox(height: 10,),
              Expanded(
                child: ListView.builder(
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
                    return _CategoryCard(category: categoryList[index],);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {

  final Category category;

  _CategoryCard({ this.category });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          Global.changeCategory(category);
          Navigator.pushNamed(context, DisplayCategoryScreen.id);
        },
        child: Card(
          elevation: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20,),                  
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  category.title,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}