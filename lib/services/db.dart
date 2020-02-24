
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

  Stream<List<TimedCategory>> streamYesterdayTotalsList(FirebaseUser user) {
    var ref = _db.collection('users').document(user.uid).collection('yesterday_totals');
    return ref.snapshots().map((list) => list.documents.map((doc) => TimedCategory.fromFirestore(doc)).toList());
  }

  Stream<List<TimedCategory>> streamWeeklyTotalsList(FirebaseUser user) {
    var ref = _db.collection('users').document(user.uid).collection('weekly_totals');
    return ref.snapshots().map((list) => list.documents.map((doc) => TimedCategory.fromFirestore(doc)).toList());
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

  void endDay(FirebaseUser user, List<Activity> activityList) async {
    List<TimedCategory> yesterdayTotalsList = [];
    bool categoryExists = false;

    print('Starting endDay');

    // Put the first Activity into the TimedCategory
    yesterdayTotalsList.add(TimedCategory(
      title: activityList[0].category,
      totalTimeInMinutes: activityList[0].totalTimeInMinutes,
    ));

    // Loop through the remaining activities in activityList
    for (int i = 1; i < activityList.length; i++) {
      // Loop through the timedCategoryList
      for (int j = 0; j < yesterdayTotalsList.length; j++) {
        // This Activities category exists in the timeCategoryList
        if (yesterdayTotalsList[j].title == activityList[i].category) {
          yesterdayTotalsList[j].addToTotalTime(activityList[i].totalTimeInMinutes);
          categoryExists = true;
        }
      }

      // We looped through the whole timedCategoryList, and this Activities category didn't exist
      if (categoryExists == false) {
        yesterdayTotalsList.add(TimedCategory(
          title: activityList[i].category,
          totalTimeInMinutes: activityList[i].totalTimeInMinutes,
        ));
      }

      // Reset the categoryExists
      categoryExists = false;
    }

    for (int i = 0; i < yesterdayTotalsList.length; i++) {
      await _db.collection('users').document(user.uid).collection('yesterday_totals').add({
        'title': yesterdayTotalsList[i].title,
        'totalTimeInMinutes': yesterdayTotalsList[i].totalTimeInMinutes,
      });
      print("yesterday_totals write: " + yesterdayTotalsList[i].title);
    }

    // Delete all the Activity documents
    await _db.collection('users').document(user.uid).collection('day_tracker').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        print("Deleting day_tracker: " + ds.data.toString());
        ds.reference.delete();
      }
    });

    print('Ending endDay');
  }

  void convertYesterdayToWeekly(FirebaseUser user) async {
    List<TimedCategory> yesterdayTotalsList = [];
    List<TimedCategory> weeklyTotalsList = [];
    bool categoryExists = false;

    print('Started convertYesterdayToWeekly');

    // Get all of the current yesterday_totals
    await _db.collection('users').document(user.uid).collection('yesterday_totals').getDocuments().then((QuerySnapshot snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        yesterdayTotalsList.add(TimedCategory(
          title: ds.data['title'],
          totalTimeInMinutes: ds.data['totalTimeInMinutes'],
        ));

        print("Adding to yeseterdayTotalsList: " + ds.data.toString());
      }
    });

    // Get all of the current weekly_totals
    /*
    _db.collection('users').document(user.uid).collection('weekly_totals').getDocuments().then((QuerySnapshot snapshot) {
      weeklyTotalsList = snapshot.documents.map((f) => weeklyTotalsList.add(TimedCategory.fromMap(f.data))).toList();
      //snapshot.documents.map((f) => weeklyTotalsList.add(TimedCategory.fromMap(f.data)));
    });
    */

    // Add yesterday_totals to weekly_totals
    if (weeklyTotalsList.length == 0) {
      weeklyTotalsList = yesterdayTotalsList;
    } else {
      for (int i = 1; i < yesterdayTotalsList.length; i++) {
        for (int j = 0; j < weeklyTotalsList.length; j++) {
          if (weeklyTotalsList[j].title == yesterdayTotalsList[i].title) {
            weeklyTotalsList[j].addToTotalTime(yesterdayTotalsList[i].totalTimeInMinutes);
            categoryExists = true;
          }
        }

        // We looped through the whole weeklyTotalsList, and this TimedCategory category didn't exist
        if (categoryExists == false) {
          weeklyTotalsList.add(TimedCategory(
            title: yesterdayTotalsList[i].title,
            totalTimeInMinutes: yesterdayTotalsList[i].totalTimeInMinutes,
          ));
        }

        // Reset the categoryExists
        categoryExists = false;
      }
    }

    // Add the new weekly_totals data to Firestore
    for (int i = 0; i < weeklyTotalsList.length; i++) {
      await _db.collection('users').document(user.uid).collection('weekly_totals').add({
        'title': weeklyTotalsList[i].title,
        'totalTimeInMinutes': weeklyTotalsList[i].totalTimeInMinutes,
      });
    }

    // Delete all the yesterday_totals
    await _db.collection('users').document(user.uid).collection('yesterday_totals').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        print("Deleting yesterday_totals: " + ds.data.toString());
        ds.reference.delete();
      }
    });

    print('Ended convertYesterdayToWeekly');
  }

}