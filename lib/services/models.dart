import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:time_keeper/services/globals.dart';
import 'db.dart';

class User {

  String uid;
  Document<User> doc;
  String email;

  User({
    this.uid,
    this.doc,
    this.email,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return User(
      uid: data['uid'],
      doc: Document<User>(path: doc.reference.path),
      email: data['email'],
    );
  }
}

class Category {

  String id;
  Document<Category> doc;
  String title;
  int todayTime;
  int yesterdayTime;
  int weekTime;
  int monthTime;

  Category({
    this.id,
    this.doc,
    this.title,
    this.todayTime,
    this.yesterdayTime,
    this.weekTime,
    this.monthTime,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Category(
      id: doc.documentID,
      doc: Document<Category>(path: doc.reference.path),
      title: data['title'],
      todayTime: data['todayTime'],
      yesterdayTime: data['yesterdayTime'],
      weekTime: data['weekTime'],
      monthTime: data['monthTime'],
    );
  }

  void addToDb() {
    Global.categoryCollection.upsert({
      "title": title,
      "todayTime": todayTime,
      "yesterdayTime": yesterdayTime,
      "weekTime": weekTime,
      "monthTime": monthTime,
    });
  }

  void updateDb() {
    doc.upsert({
      "todayTime": todayTime,
      "yesterdayTime": yesterdayTime,
      "weekTime": weekTime,
      "monthTime": monthTime,
    });
  }

  void delete() {
    doc.delete();
  }

  void changeTitle(String newTitle) {
    doc.upsert({
      "title": newTitle,
    });
  }

  void initializeCategory(String title) {
    this.title = title;
    todayTime = 0;
    yesterdayTime = 0;
    weekTime = 0;
    monthTime = 0;
    addToDb();
  }

  String formatTime(int timeInMinutes) {
    int minutes = timeInMinutes % 60;
    int hours = timeInMinutes ~/ 60;

    return hours.toString() + ":" + (minutes < 10 ? ("0" + minutes.toString()) : minutes.toString());
  }

  String displayTodayTime() {
    return formatTime(todayTime);
  }

  String displayYesterdayTime() {
    return formatTime(yesterdayTime);
  }

  String displayWeekTime() {
    return formatTime(weekTime);
  }

  String displayMonthTime() {
    return formatTime(monthTime);
  }

  int chooseTimeToCompare(int currentTab) {
    int time;
    switch (currentTab) {
      case 0:
        time = todayTime;
        break;
      case 1:
        time = yesterdayTime;
        break;
      case 2:
        time = weekTime;
        break;
      case 3:
        time = monthTime;
        break;
    }

    return time;
  }

  String chooseTimeToDisplay(int currentTab) {
    String time;
    switch (currentTab) {
      case 0:
        time = displayTodayTime();
        break;
      case 1:
        time = displayYesterdayTime();
        break;
      case 2:
        time = displayWeekTime();
        break;
      case 3:
        time = displayMonthTime();
        break;
    }

    return time;
  }

  void endDay() {
    this.yesterdayTime = this.todayTime;
    this.todayTime = 0;

    if (DateTime.now().weekday == 1) {
      this.weekTime = 0;
    }

    if (DateTime.now().day == 1) {
      this.monthTime = 0;
    }

    updateDb();
  }
}

class Task {

  String id;
  Document<Task> doc;
  String categoryTitle;
  DateTime startTime;
  DateTime endTime;
  int totalTimeInMinutes;

  Task({
    this.id,
    this.doc,
    this.categoryTitle,
    this.startTime,
    this.endTime,
    this.totalTimeInMinutes,
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Task(
      id: doc.documentID,
      doc: Document<Task>(path: doc.reference.path),
      categoryTitle: data['categoryTitle'] ?? '',
      startTime: DateTime.fromMillisecondsSinceEpoch(data['startTime'].seconds * 1000) ?? DateTime.utc(1960, 1, 1, 12, 0, 0),
    );
  }

  String printStartTime() {
    return "Start Time: " + DateFormat('hh:mm').format(this.startTime);
  }

  void finishTask(List<Category> categoryList) {
    endTime = DateTime.now();
    totalTimeInMinutes = endTime.difference(startTime).inMinutes;

    for (Category category in categoryList) {
      if (category.title == this.categoryTitle) {
        category.todayTime += this.totalTimeInMinutes;
        category.weekTime += this.totalTimeInMinutes;
        category.monthTime += this.totalTimeInMinutes;
        category.updateDb();
      }
    }
    categoryTitle = '';
  }

  void addToDb() {
    Global.taskDocument.upsert({
      'categoryTitle': categoryTitle,
      'startTime': DateTime.now(),
    });
  }

  void endDay(List<Category> categoryList) {
    finishTask(categoryList);
    for (Category category in categoryList) {
      category.endDay();
    }
  }

}