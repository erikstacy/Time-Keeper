

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Activity {

  String id;
  String category;
  DateTime startTime;
  DateTime endTime;
  int totalTimeInMinutes;

  Activity({
    this.id,
    this.category,
    this.startTime,
    this.endTime,
    this.totalTimeInMinutes,
  });

  factory Activity.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Activity(
      id: doc.documentID,
      category: data['category'] ?? '',
      startTime: DateTime.fromMillisecondsSinceEpoch(data['startTime'].seconds * 1000) ?? DateTime.utc(1960, 1, 1, 12, 0, 0),
      endTime: DateTime.fromMillisecondsSinceEpoch(data['endTime'].seconds * 1000) ?? DateTime.utc(1960, 1, 1, 12, 0, 0),
      totalTimeInMinutes: data['totalTimeInMinutes'] ?? 0,
    );
  }

  String printStartTime() {
    return DateFormat('hh:mm').format(this.startTime);
  }

  String printEndTime() {
    return DateFormat('hh:mm').format(this.endTime);
  }

  void calculateTotalTime() {
    Duration startHours = Duration(hours: this.startTime.hour);
    Duration startMinutes = Duration(minutes: this.startTime.minute);
    Duration endHours = Duration(hours: this.endTime.hour);
    Duration endMinutes = Duration(minutes: this.endTime.minute);

    Duration startDuration = Duration(minutes: (startHours.inMinutes + startMinutes.inMinutes));
    Duration endDuration = Duration(minutes: (endHours.inMinutes + endMinutes.inMinutes));

    this.totalTimeInMinutes = endDuration.inMinutes - startDuration.inMinutes;
  }

  String printTotalTime() {
    int minutes = this.totalTimeInMinutes % 60;
    int hours = this.totalTimeInMinutes ~/ 60;

    return hours.toString() + ":" + (minutes < 10 ? ("0" + minutes.toString()) : minutes.toString());
  }
}

class Category {

  String id;
  String title;

  Category({
    this.id,
    this.title,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Category(
      id: doc.documentID,
      title: data['title'] ?? '',
    );
  }

}

class TimedCategory {

  String id;
  String title;
  int totalTimeInMinutes;

  TimedCategory({
    this.id,
    this.title,
    this.totalTimeInMinutes,
  });

  factory TimedCategory.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return TimedCategory(
      id: doc.documentID,
      title: data['title'] ?? '',
      totalTimeInMinutes: data['totalTimeInMinutes'] ?? 0,
    );
  }

  void addToTotalTime(int addedMinutes) {
    this.totalTimeInMinutes += addedMinutes;
  }

  String printTotalTime() {
    int minutes = this.totalTimeInMinutes % 60;
    int hours = this.totalTimeInMinutes ~/ 60;

    return hours.toString() + ":" + minutes.toString();
  }

}