

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Activity {

  String id;
  String category;
  DateTime startTime;
  DateTime endTime;

  Activity({
    this.id,
    this.category,
    this.startTime,
    this.endTime,
  });

  factory Activity.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Activity(
      id: doc.documentID,
      category: data['category'] ?? '',
      startTime: DateTime.fromMillisecondsSinceEpoch(data['startTime'].seconds * 1000) ?? DateTime.utc(1960, 1, 1, 12, 0, 0),
      endTime: DateTime.fromMillisecondsSinceEpoch(data['endTime'].seconds * 1000) ?? DateTime.utc(1960, 1, 1, 12, 0, 0),
    );
  }

  String printStartTime() {
    return DateFormat('kk:mm').format(this.startTime);
  }

  String printEndTime() {
    return DateFormat('kk:mm').format(this.endTime);
  }

  String printTotalTime() {
    DateTime tempDate = this.endTime;
    tempDate.subtract(Duration(
      hours: this.startTime.hour,
      minutes: this.startTime.minute,
    ));

    return DateFormat('kk:mm').format(tempDate);
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