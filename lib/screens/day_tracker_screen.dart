import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_keeper/services/db.dart';
import 'package:time_keeper/shared/navigation_bottom_sheet.dart';

class DayTrackerScreen extends StatefulWidget {

  static String id = 'day_tracker_screen';

  @override
  _DayTrackerScreenState createState() => _DayTrackerScreenState();
}

class _DayTrackerScreenState extends State<DayTrackerScreen> {

  DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {

    var user = Provider.of<FirebaseUser>(context);

    return Scaffold(
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
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (context) => BottomSheet(
            onClosing: () {
              _db.addActivity(user);
            },
            builder: (context) {
              return Column();
            },
          ),
        ),
      ),
    );
  }
}