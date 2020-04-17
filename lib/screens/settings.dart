import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {

  static String id = 'settings_screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool enableNotificationsState = false;

  @override
  void initState() {
    _getSharedPreferences();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('Enable Notifications'),
              subtitle: Text('Do you want a constant notification for your Current Activity?'),
              trailing: Switch(
                value: enableNotificationsState,
                onChanged: (newValue) {
                  _setEnableNotifications(newValue);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      enableNotificationsState = (prefs.getBool('enable_notifications') ?? false);
    });
  }

  void _setEnableNotifications(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enable_notifications', value);
    setState(() {
      enableNotificationsState = value;
    });
  }
}