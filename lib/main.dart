import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_keeper/screens/categories_screen.dart';
import 'package:time_keeper/screens/current_activity_screen.dart';
import 'package:time_keeper/screens/display_category_screen.dart';
import 'package:time_keeper/screens/login_screen.dart';
import 'package:time_keeper/screens/main_screen.dart';
import 'package:time_keeper/screens/register_screen.dart';
import 'package:time_keeper/screens/task_screen.dart';
import 'package:time_keeper/screens/totals_screen.dart';
import 'package:time_keeper/services/auth.dart';
import 'package:time_keeper/services/globals.dart';
import 'package:time_keeper/services/models.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AuthService _auth = AuthService();

    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(value: _auth.user),
        StreamProvider<List<Category>>.value(value: Global.categoryCollection.collectionStream),
        StreamProvider<User>.value(value: Global.userDocument.documentStream),
        StreamProvider<Task>.value(value: Global.taskDocument.documentStream),
      ],
      child: MaterialApp(
        title: 'Time Keeper',
        initialRoute: LoginScreen.id,
        routes: {
          RegisterScreen.id: (context) => RegisterScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          MainScreen.id: (context) => MainScreen(),
          CurrentActivityScreen.id: (context) => CurrentActivityScreen(),
          TotalsScreen.id: (context) => TotalsScreen(),
          CategoriesScreen.id: (context) => CategoriesScreen(),
          DisplayCategoryScreen.id: (context) => DisplayCategoryScreen(),
          TaskScreen.id: (context) => TaskScreen(),
        },
        theme: ThemeData.dark(),
      ),
    );
  }
}