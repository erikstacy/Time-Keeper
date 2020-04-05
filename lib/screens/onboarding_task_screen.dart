import 'package:flutter/material.dart';
import 'package:time_keeper/screens/onboarding_info_screen.dart';
import 'package:time_keeper/services/models.dart';

class OnboardingTaskScreen extends StatefulWidget {

  static String id = 'onboarding_task_screen';

  @override
  _OnboardingTaskScreenState createState() => _OnboardingTaskScreenState();
}

class _OnboardingTaskScreenState extends State<OnboardingTaskScreen> {

  List<Category> categoryList = [
    Category(title: 'Coding'),
    Category(title: 'School'),
    Category(title: 'Sleep'),
  ];

  Category currentCategory;

  @override
  void initState() {
    super.initState();

    currentCategory = categoryList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20,),
              Text(
                'What are you doing?',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5,),
              Text(
                'Pick the category that you are currently doing.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 30,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 20),
                    child: Text(
                      'CATEGORY',
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: DropdownButton<Category>(
                      value: currentCategory,
                      hint: Text('Select'),
                      items: categoryList.map<DropdownMenuItem<Category>>((Category category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Text(
                            category.title,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.purpleAccent,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (Category newCategory) {
                        setState(() {
                          currentCategory = newCategory;
                        });
                      },
                      underline: Container(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30,),
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
                  /*
                  var user = await _auth.emailRegister(email, password);
                  if (user != null) {
                    Navigator.pushReplacementNamed(context, MainScreen.id);
                  }
                  */
                  Navigator.pushNamed(context, OnboardingInfoScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}