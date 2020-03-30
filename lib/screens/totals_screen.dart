import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_keeper/services/models.dart';
import 'package:time_keeper/shared/loading.dart';

class TotalsScreen extends StatefulWidget {

  static String id = 'totals_screen';

  @override
  _TotalsScreenState createState() => _TotalsScreenState();
}

class _TotalsScreenState extends State<TotalsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Totals'),
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        body: DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: TabBarView(
              children: <Widget>[
                CategoryListWidget(currentTab: 0,),
                CategoryListWidget(currentTab: 1,),
                CategoryListWidget(currentTab: 2,),
                CategoryListWidget(currentTab: 3,),
              ],
            ),
            appBar: TabBar(
              indicatorColor: Colors.purpleAccent,
              tabs: <Widget>[
                Tab(
                  text: "Today",
                ),
                Tab(
                  text: "Yesterday",
                ),
                Tab(
                  text: "Week",
                ),
                Tab(
                  text: "Month",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryListWidget extends StatelessWidget {

  final int currentTab;

  CategoryListWidget({ this.currentTab });

  @override
  Widget build(BuildContext context) {

    List<Category> categoryList = Provider.of<List<Category>>(context);
    categoryList.sort((a, b) => a.chooseTimeToCompare(currentTab).compareTo(b.chooseTimeToCompare(currentTab)));
    categoryList = categoryList.reversed.toList();

    if (categoryList != null) {
      return Container(
        padding: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: categoryList.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return TopCategories(categoryList: categoryList,);
            }

            // Todo - This needs to be changed
            if (index > 0) {
              return CategoryCard(category: categoryList[index],);
            }

            return null;
          },
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

class TopCategories extends StatelessWidget {

  List<Category> categoryList;

  TopCategories({ this.categoryList });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20,),
        Text(
          'Top Three',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        SizedBox(height: 20,),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '3:32',
                      style: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 40,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      'Family',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '3:32',
                    style: TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    'Family',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '3:32',
                    style: TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    'Family',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20,),
        Divider(
          color: Colors.grey[800],
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {

  Category category;

  CategoryCard({ this.category });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                '3:32',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.yellowAccent,
                  fontSize: 40,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'Family',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.grey[800],
        ),
      ],
    );
  }
}