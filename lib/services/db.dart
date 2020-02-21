
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:time_keeper/services/models.dart';

class DatabaseService {

  final Firestore _db = Firestore.instance;

  /*

    Streams

  */

  Stream<List<Category>> streamCategoryList(FirebaseUser user) {
    var ref = _db.collection('users').document(user.uid).collection('categories');
    return ref.snapshots().map((list) => list.documents.map((doc) => Category.fromFirestore(doc)).toList());
  }

  Stream<List<Activity>> streamActivityList(FirebaseUser user) {
    var ref = _db.collection('users').document(user.uid).collection('day_tracker');
    return ref.snapshots().map((list) => list.documents.map((doc) => Activity.fromFirestore(doc)).toList());
  }

  /*

    Writes

  */

  void addCategory(FirebaseUser user, String title) {
    _db.collection('users').document(user.uid).collection('categories').add({
      'title': title,
    });
  }

  void editCategory(FirebaseUser user, String categoryId, String title) {
    _db.collection('users').document(user.uid).collection('categories').document(categoryId).setData({
      'title': title,
    }, merge: true);
  }

  void deleteCategory(FirebaseUser user, String categoryId) {
    _db.collection('users').document(user.uid).collection('categories').document(categoryId).delete();
  }

  void addActivity(FirebaseUser user, String categoryTitle) {
    _db.collection('users').document(user.uid).collection('day_tracker').add({
      'category': categoryTitle,
      'startTime': DateTime.now(),
      'endTime': DateTime.utc(1960, 1, 1, 12, 0, 0),
    });
  }

  void setActivityEndTime(FirebaseUser user, String activityId, DateTime dateTime) {
    _db.collection('users').document(user.uid).collection('day_tracker').document(activityId).setData({
      'endTime': dateTime,
    }, merge: true);
  }

  void endDay(FirebaseUser user, List<Activity> activityList) {
    List<TimedCategory> timedCategoryList = [];
    bool categoryExists = false;

    // Loop through the activityList
    for (int i = 0; i < activityList.length; i++) {
      // Loop through the timedCategoryList to check if the activityList category exists
      if (timedCategoryList.length == 0) {
        timedCategoryList.add(TimedCategory(
          title: activityList[i].category,
          totalTime: activityList[i].printTotalTime(),
        ));
      } else {
        for (int j = 0; j < timedCategoryList.length; j++) {
          if (timedCategoryList[j].title == activityList[i].category) {
            int totalHour = int.parse(timedCategoryList[j].totalTime[0] + timedCategoryList[j].totalTime[1]);
            int totalMinute = int.parse(timedCategoryList[j].totalTime[3] + timedCategoryList[j].totalTime[4]);

            int activityHour = int.parse(activityList[i].printTotalTime()[0] + activityList[i].printTotalTime()[1]);
            int activityMinute = int.parse(activityList[i].printTotalTime()[3] + activityList[i].printTotalTime()[4]);            

            totalHour += activityHour;
            totalMinute += activityMinute;

            Duration activityDuration = Duration(hours: totalHour, minutes: totalMinute);

            int finalHours = activityDuration.inMinutes ~/ 60;
            int finalMinutes = activityDuration.inMinutes % 60;

            timedCategoryList[j].totalTime = (finalHours < 10 ? "0" + finalHours.toString() : finalHours.toString()) + ':' + (finalMinutes < 10 ? "0" + finalMinutes.toString() : finalMinutes.toString());

            categoryExists = true;
          }
        }

        if (categoryExists == false) {
          timedCategoryList.add(TimedCategory(
            title: activityList[i].category,
            totalTime: activityList[i].printTotalTime(),
          ));
        }

        categoryExists = false;
      }
    }

    List<Map<String, String>> mapList = [];

    for (int i = 0; i < timedCategoryList.length; i++) {
      mapList.add({timedCategoryList[i].title: timedCategoryList[i].totalTime});
    }

    _db.collection('users').document(user.uid).setData({
      'yesterday_totals': mapList,
    }, merge: true);
  }

}