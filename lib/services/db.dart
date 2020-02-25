
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

  Stream<List<TimedCategory>> streamMonthlyTotalsList(FirebaseUser user) {
    var ref = _db.collection('users').document(user.uid).collection('monthly_totals');
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
    // Create the lists that we'll be using
    List<Activity> newActivityList = [];
    List<TimedCategory> yesterdayTotalsList = [];
    List<TimedCategory> weeklyTotalsList = [];
    List<TimedCategory> monthlyTotalsList = [];

    // Create the bools that we need
    bool sameAcivityCategory = false;
    bool sameYesterdayTitle = false;
    bool sameWeeklyTitle = false;
    bool sameMonthlyTitle = false;

    // Delete yesterday_totals document from Firestore
    await _db.collection('users').document(user.uid).collection('yesterday_totals').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        print("Deleting yesterday_totals: " + ds.data.toString());
        ds.reference.delete();
      }
    });

    // Populate weeklyTotalsList from Firestore IF it isn't the beginning of the next week
    if (DateTime.now().weekday != 1) {
      await _db.collection('users').document(user.uid).collection('weekly_totals').getDocuments().then((QuerySnapshot snapshot) {
        for (DocumentSnapshot ds in snapshot.documents){
          weeklyTotalsList.add(TimedCategory(
            title: ds.data['title'],
            totalTimeInMinutes: ds.data['totalTimeInMinutes'],
          ));

          print("Adding to weeklyTotalsList: " + ds.data.toString());
        }
      });
    }

    // Populate monthlyTotalsList from Firestore IF it isn't the beginning of the month
    if (DateTime.now().day != 1) {
      await _db.collection('users').document(user.uid).collection('monthly_totals').getDocuments().then((QuerySnapshot snapshot) {
        for (DocumentSnapshot ds in snapshot.documents){
          monthlyTotalsList.add(TimedCategory(
            title: ds.data['title'],
            totalTimeInMinutes: ds.data['totalTimeInMinutes'],
          ));

          print("Adding to monthlyTotalsList: " + ds.data.toString());
        }
      });
    }

    // Delete weekly_totals document from Firestore
    await _db.collection('users').document(user.uid).collection('weekly_totals').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        print("Deleting weekly_totals: " + ds.data.toString());
        ds.reference.delete();
      }
    });

    // Delete monthly document from Firestore
    await _db.collection('users').document(user.uid).collection('monthly_totals').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        print("Deleting monthly_totals: " + ds.data.toString());
        ds.reference.delete();
      }
    });

    // Initialize newActivityList with the first activity
    newActivityList.add(activityList[0]);

    // Condense the activityList so that there are no duplicate categories
    for (int i = 1; i < activityList.length; i++) {
      for (int j = 0; j < newActivityList.length; j++) {
        if (activityList[i].category == newActivityList[j].category) {
          sameAcivityCategory = true;
          newActivityList[j].addToTotalTime(activityList[i].totalTimeInMinutes);
        }
      }

      if (sameAcivityCategory == false) {
        newActivityList.add(activityList[i]);
      }

      sameAcivityCategory = false;
    }

    // The BEAST for loop, the mashed potata's of this app
    for (int i = 0; i < newActivityList.length; i++) {
      // Populate the yesterdayTotalsList
      if (yesterdayTotalsList.length != 0) {
        for (int j = 0; j < yesterdayTotalsList.length; j++) {
          if (newActivityList[i].category == yesterdayTotalsList[j].title) {
            yesterdayTotalsList[j].addToTotalTime(newActivityList[i].totalTimeInMinutes);
            sameYesterdayTitle = true;
          }
        }
      }

      // Make a new yesterday TimedCategory
      if (sameYesterdayTitle == false) {
        yesterdayTotalsList.add(TimedCategory(
          title: newActivityList[i].category,
          totalTimeInMinutes: newActivityList[i].totalTimeInMinutes,
        ));
      }

      // Populate the weeklyTotalsList
      if (weeklyTotalsList.length != 0) {
        for (int j = 0; j < weeklyTotalsList.length; j++) {
          if (newActivityList[i].category == weeklyTotalsList[j].title) {
            weeklyTotalsList[j].addToTotalTime(newActivityList[i].totalTimeInMinutes);
            sameWeeklyTitle = true;
          }
        }
      }

      // Make a new weekly TimedCategory
      if (sameWeeklyTitle == false) {
        weeklyTotalsList.add(TimedCategory(
          title: newActivityList[i].category,
          totalTimeInMinutes: newActivityList[i].totalTimeInMinutes,
        ));
      }

      // Populate the monthlyTotalsList
      if (monthlyTotalsList.length != 0) {
        for (int j = 0; j < monthlyTotalsList.length; j++) {
          if (newActivityList[i].category == monthlyTotalsList[j].title) {
            monthlyTotalsList[j].addToTotalTime(newActivityList[i].totalTimeInMinutes);
            sameMonthlyTitle = true;
          }
        }
      }

      // Make a new monthly TimedCategory
      if (sameMonthlyTitle == false) {
        monthlyTotalsList.add(TimedCategory(
          title: newActivityList[i].category,
          totalTimeInMinutes: newActivityList[i].totalTimeInMinutes,
        ));
      }

      // Reset the sameTitle bools
      sameYesterdayTitle = false;
      sameWeeklyTitle = false;
      sameMonthlyTitle = false;
    }

    // Write the yesterdayTotalsList to Firestore
    for (int i = 0; i < yesterdayTotalsList.length; i++) {
      await _db.collection('users').document(user.uid).collection('yesterday_totals').add({
        'title': yesterdayTotalsList[i].title,
        'totalTimeInMinutes': yesterdayTotalsList[i].totalTimeInMinutes,
      });
    }

    // Write the yesterdayTotalsList to Firestore
    for (int i = 0; i < weeklyTotalsList.length; i++) {
      await _db.collection('users').document(user.uid).collection('weekly_totals').add({
        'title': weeklyTotalsList[i].title,
        'totalTimeInMinutes': weeklyTotalsList[i].totalTimeInMinutes,
      });
    }

    // Write the yesterdayTotalsList to Firestore
    for (int i = 0; i < monthlyTotalsList.length; i++) {
      await _db.collection('users').document(user.uid).collection('monthly_totals').add({
        'title': monthlyTotalsList[i].title,
        'totalTimeInMinutes': monthlyTotalsList[i].totalTimeInMinutes,
      });
    }

    // Delete day_tracker documents
    await _db.collection('users').document(user.uid).collection('day_tracker').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        ds.reference.delete();
      }
    });
  }
}