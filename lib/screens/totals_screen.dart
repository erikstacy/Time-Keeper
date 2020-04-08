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
        child: ListView(
          children: <Widget>[
            TopCategories(categoryList: categoryList, currentTab: currentTab,),
            OtherCategories(categoryList: categoryList, currentTab: currentTab,),
          ],
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

  final List<Category> categoryList;
  final int currentTab;

  TopCategories({ this.categoryList, this.currentTab });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
                      categoryList[0].chooseTimeToDisplay(currentTab),
                      style: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 40,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      categoryList[0].title,
                      textAlign: TextAlign.center,
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
                    categoryList[1].chooseTimeToDisplay(currentTab),
                    style: TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    categoryList[1].title,
                    textAlign: TextAlign.center,
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
                    categoryList[2].chooseTimeToDisplay(currentTab),
                    style: TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    categoryList[2].title,
                    textAlign: TextAlign.center,
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

class OtherCategories extends StatelessWidget {

  final List<Category> categoryList;
  final int currentTab;

  OtherCategories({ this.categoryList, this.currentTab });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(categoryList.length - 3, (index) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 45),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: index % 2 == 1 ? Colors.grey[850] : Colors.grey[700],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                categoryList[index + 3].title,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                categoryList[index + 3].chooseTimeToDisplay(currentTab),
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}