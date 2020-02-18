
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {

  final Firestore _db = Firestore.instance;

  void addActivity(FirebaseUser user) {
    _db.collection('users').document(user.uid).collection('day_tracker').add({
      'category': 'School',
      'startTime': DateTime.now(),
      'endTime': DateTime.utc(1960, 1, 1, 12, 0, 0),
    });
  }

}