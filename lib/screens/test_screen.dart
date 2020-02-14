import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {

  static String id = 'test_screen';

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Fuck you'),
    );
  }
}