import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Future<FirebaseUser> get getUser => _auth.currentUser();

  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  Future<FirebaseUser> emailRegister(String email, String password) async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    updateUserData(user);
    return user;
  }

  Future<FirebaseUser> emailLogin(String email, String password) async {
    FirebaseUser user = await _auth.signInWithEmailAndPassword(email: email, password: password);
    updateUserData(user);
    return user;
  }

  Future<void> updateUserData(FirebaseUser user) {
    DocumentReference userRef = _db.collection('users').document(user.uid);

    return userRef.setData({
      'uid': user.uid,
      'email': user.email,
      'lastActivity': DateTime.now()
    }, merge: true);
  }

  Future<void> signOut() {
    return _auth.signOut();
  }

}


/*

_auth.getUser.then(
  (user) {
    if (user != null) {
      Navigator.pushReplacementNamed(context, TodoScreen.id);
    }
  },
);

*/