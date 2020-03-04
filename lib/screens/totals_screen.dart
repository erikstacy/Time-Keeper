import 'package:flutter/material.dart';
import 'package:time_keeper/shared/bottom_bar.dart';

class TotalsScreen extends StatefulWidget {

  static String id = 'totals_screen';

  @override
  _TotalsScreenState createState() => _TotalsScreenState();
}

class _TotalsScreenState extends State<TotalsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text('Totals'),
      ),
      bottomNavigationBar: BottomBar(1),
    );
  }
}