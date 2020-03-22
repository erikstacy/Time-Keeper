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
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: TabBarView(
            children: <Widget>[
              CategoryListWidget(currentTab: 0,),
              CategoryListWidget(currentTab: 1,),
              CategoryListWidget(currentTab: 2,),
              CategoryListWidget(currentTab: 3,),
            ],
          ),
          appBar: TabBar(

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
            return _CategoryCard(category: categoryList[index], currentTab: currentTab,);
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

class _CategoryCard extends StatelessWidget {

  final Category category;
  final int currentTab;

  _CategoryCard({ this.category, this.currentTab });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20,),                  
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                category.title,
                style: TextStyle(
                  fontSize: 21,
                ),
              ),
            ),
            SizedBox(height: 5,),
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Total Time: " + category.chooseTimeToDisplay(currentTab),
                style: TextStyle(
                  fontSize: 15,
                  letterSpacing: 0.25,
                  color: Colors.grey[400],
                ),
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}