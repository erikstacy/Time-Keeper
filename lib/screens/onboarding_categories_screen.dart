import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_keeper/screens/categories_screen.dart';
import 'package:time_keeper/screens/onboarding_task_screen.dart';
import 'package:time_keeper/services/globals.dart';
import 'package:time_keeper/services/models.dart';
import 'package:time_keeper/shared/loading.dart';

class OnboardingCategoriesScreen extends StatefulWidget {

  static String id = 'onboarding_categories_screen';

  @override
  _OnboardingCategoriesScreenState createState() => _OnboardingCategoriesScreenState();
}

class _OnboardingCategoriesScreenState extends State<OnboardingCategoriesScreen> {

  String category1 = "";
  String category2 = "";
  String category3 = "";

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading ? Center(child: Loader()) : SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Text(
              'Create three categories',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5,),
            Text(
              'You can add more later.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "First Category",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                ),
                onChanged: (value) {
                  category2 = value;
                },
              ),
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Second Category",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                ),
                onChanged: (value) {
                  category3 = value;
                },
              ),
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Third Category",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                ),
                onChanged: (value) {
                  category1 = value;
                },
              ),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              color: Colors.purpleAccent,
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });

                List<Category> categoryList = Provider.of<List<Category>>(context);

                categoryList[0].delete();

                Category newCategory1 = Category();
                newCategory1.initializeCategory(category1);

                Category newCategory2 = Category();
                newCategory2.initializeCategory(category2);

                Category newCategory3 = Category();
                newCategory3.initializeCategory(category3);

                categoryList.add(newCategory1);
                categoryList.add(newCategory2);
                categoryList.add(newCategory3);

                Navigator.pushNamed(context, OnboardingTaskScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}