import 'package:flutter/material.dart';
import 'package:time_keeper/shared/bottom_bar.dart';

class ProfileScreen extends StatefulWidget {

  static String id = 'profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text('Profile'),
      ),
      bottomNavigationBar: BottomBar(2),
    );
  }
}