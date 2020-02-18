

import 'package:cloud_firestore/cloud_firestore.dart';

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
      startTime: data['startTime'] ?? DateTime.utc(1960),
      endTime: data['endTime'] ?? DateTime.utc(1960),
    );
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