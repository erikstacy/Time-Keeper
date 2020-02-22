import 'package:flutter/material.dart';
import 'package:time_keeper/shared/navigation_bottom_sheet.dart';

class YesterdayTotalScreen extends StatefulWidget {

  static String id = 'yesterday_total_screen';

  @override
  _YesterdayTotalScreenState createState() => _YesterdayTotalScreenState();
}

class _YesterdayTotalScreenState extends State<YesterdayTotalScreen> {
  @override
  Widget build(BuildContext context) {
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