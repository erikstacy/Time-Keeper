import 'package:flutter/material.dart';
import 'package:time_keeper/shared/bottom_bar.dart';

class CurrentActivityScreen extends StatefulWidget {

  static String id = 'current_activity_screen';

  @override
  _CurrentActivityScreenState createState() => _CurrentActivityScreenState();
}

class _CurrentActivityScreenState extends State<CurrentActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text('Current Activity'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // TODO - Implement this
        },
      ),
      bottomNavigationBar: BottomBar(0),
    );
  }
}