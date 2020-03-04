import 'package:flutter/material.dart';

class TotalsScreen extends StatefulWidget {

  static String id = 'totals_screen';

  @override
  _TotalsScreenState createState() => _TotalsScreenState();
}

class _TotalsScreenState extends State<TotalsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Text('Totals'),
    );
  }
}