
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

  void setActivityEndTime(FirebaseUser user, Activity activity) {
    activity.endTime = DateTime.now();
    activity.calculateTotalTime();

    _db.collection('users').document(user.uid).collection('day_tracker').document(activity.id).setData({
      'endTime': activity.endTime,
      'totalTimeInMinutes': activity.totalTimeInMinutes,
    }, merge: true);
  }

  void clearDayTracker(FirebaseUser user) {
    _db.collection('users').document(user.uid).collection('day_tracker');
  }

  void endDay(FirebaseUser user, List<Activity> activityList) {
    List<TimedCategory> timedCategoryList = [];
    bool categoryExists = false;

    // Put the first Activity into the TimedCategory
    timedCategoryList.add(TimedCategory(
      title: activityList[0].category,
      totalTimeInMinutes: activityList[0].totalTimeInMinutes,
    ));

    // Loop through the remaining activities in activityList
    for (int i = 1; i < activityList.length; i++) {
      // Loop through the timedCategoryList
      for (int j = 0; j < timedCategoryList.length; j++) {
        // This Activities category exists in the timeCategoryList
        if (timedCategoryList[j].title == activityList[i].category) {
          timedCategoryList[j].addToTotalTime(activityList[i].totalTimeInMinutes);
          categoryExists = true;
        }
      }

      // We looped through the whole timedCategoryList, and this Activities category didn't exist
      if (categoryExists == false) {
        timedCategoryList.add(TimedCategory(
          title: activityList[i].category,
          totalTimeInMinutes: activityList[i].totalTimeInMinutes,
        ));
      }

      // Reset the categoryExists
      categoryExists = false;
    }

    List<Map<String, int>> mapList = [];

    for (int i = 0; i < timedCategoryList.length; i++) {
      _db.collection('users').document(user.uid).collection('yesterday_totals').add({
        'title': timedCategoryList[i].title,
        'totalTimeInMinutes': timedCategoryList[i].totalTimeInMinutes,
      });
    }

    // Delete all the Activity documents
    _db.collection('users').document(user.uid).collection('day_tracker').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        ds.reference.delete();
      }
    });
  }

}