import 'package:flutter/material.dart';

class WarningAlert extends StatelessWidget {

  final String title;
  final String content;

  WarningAlert({ this.title, this.content });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}