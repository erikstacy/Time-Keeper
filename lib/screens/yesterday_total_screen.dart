import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_keeper/services/db.dart';
import 'package:time_keeper/services/models.dart';
import 'package:time_keeper/shared/loader.dart';
import 'package:time_keeper/shared/navigation_bottom_sheet.dart';

class YesterdayTotalScreen extends StatefulWidget {

  static String id = 'yesterday_total_screen';

  @override
  _YesterdayTotalScreenState createState() => _YesterdayTotalScreenState();
}

class _YesterdayTotalScreenState extends State<YesterdayTotalScreen> {

  DatabaseService _db = DatabaseService();

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
                'Yesterday Totals',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              SizedBox(height: 30,),
              Expanded(
                  child: StreamBuilder(
                  stream: _db.streamYesterdayTotalsList(user),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return LoadingScreen();
                    } else {
                      List<TimedCategory> yesterdayTotalsList = snapshot.data;

                      return ListView.builder(
                        itemCount: yesterdayTotalsList.length,
                        itemBuilder: (context, index) {
                          TimedCategory timedCategory = yesterdayTotalsList[index];

                          return ListTile(
                            title: Text(timedCategory.title),
                            subtitle: Text(timedCategory.printTotalTime()),
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
    );
  }
}