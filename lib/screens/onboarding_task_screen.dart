import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_keeper/screens/onboarding_info_screen.dart';
import 'package:time_keeper/services/models.dart';

class OnboardingTaskScreen extends StatefulWidget {

  static String id = 'onboarding_task_screen';

  @override
  _OnboardingTaskScreenState createState() => _OnboardingTaskScreenState();
}

class _OnboardingTaskScreenState extends State<OnboardingTaskScreen> {

  Category ddCategory = Category(title: '');

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List<Category> categoryList = Provider.of<List<Category>>(context);
    categoryList.sort((a, b) => a.title.compareTo(b.title));

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
                      value: ddCategory.title == '' ? null : ddCategory,
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
                          ddCategory = newCategory;
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
                  setState(() {
                    isLoading = true;
                  });

                  Task firstTask = new Task();
                  firstTask.categoryTitle = ddCategory.title;

                  firstTask.addToDb(DateTime.now());

                  Navigator.pushNamed(context, OnboardingInfoScreen.id);

                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}