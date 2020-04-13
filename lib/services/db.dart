import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import './globals.dart';



class Document<T> {
  final Firestore _db = Firestore.instance;
  final String path; 
  DocumentReference ref;

  Document({ this.path }) {
    ref = _db.document(path);
  }

  Future<T> getData() {
    return ref.get().then((v) => Global.models[T](v) as T);
  }

  Stream<T> streamData() {
    return ref.snapshots().map((v) => Global.models[T](v) as T);
  }

  Future<void> upsert(Map data) {
    return ref.setData(Map<String, dynamic>.from(data), merge: true);
  }

  Future<void> delete() {
    return ref.delete();
  }

}

class Collection<T> {
  final Firestore _db = Firestore.instance;
  final String path; 
  CollectionReference ref;

  Collection({ this.path }) {
    ref = _db.collection(path);
  }

  Future<List<T>> getData() async {
    var snapshots = await ref.getDocuments();
    return snapshots.documents.map((doc) => Global.models[T](doc) as T ).toList();
  }

  Stream<List<T>> streamData() {
    return ref.snapshots().map((list) => list.documents.map((doc) => Global.models[T](doc) as T).toList() );
  }

  Future<void> upsert(Map data) {
    return ref.add(Map<String, dynamic>.from(data));
  }

}

class UserDocument<T> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<T> get documentStream {

    return Observable(_auth.onAuthStateChanged).switchMap((user) {
      if (user != null) {
          Document<T> doc = Document<T>(path: 'users/${user.uid}'); 
          return doc.streamData();
      } else {
          return Observable<T>.just(null);
      }
    }); //.shareReplay(maxSize: 1).doOnData((d) => print('777 $d'));// as Stream<T>;
  }

  Future<T> getDocument() async {
    FirebaseUser user = await _auth.currentUser();

    if (user != null) {
      Document doc = Document<T>(path: 'users/${user.uid}'); 
      return doc.getData();
    } else {
      return null;
    }

  }

  Future<void> upsert(Map data) async {
    FirebaseUser user = await _auth.currentUser();
    Document<T> ref = Document(path:  'users/${user.uid}');
    return ref.upsert(data);
  }

}

class UserCollection<T> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String path;

  UserCollection({ this.path });

  Stream<List<T>> get collectionStream {

    return Observable(_auth.onAuthStateChanged).switchMap((user) {
      if (user != null) {
          Collection<T> doc = Collection<T>(path: 'users/${user.uid}/$path'); 
          return doc.streamData();
      } else {
          return Observable<List<T>>.just(null);
      }
    }); //.shareReplay(maxSize: 1).doOnData((d) => print('777 $d'));// as Stream<T>;
  }

  Future<List<T>> getCollection() async {
    FirebaseUser user = await _auth.currentUser();

    if (user != null) {
      Collection doc = Collection<T>(path: 'users/${user.uid}/$path'); 
      return doc.getData();
    } else {
      return null;
    }

  }

  Future<void> upsert(Map data) async {
    FirebaseUser user = await _auth.currentUser();
    Collection<T> ref = Collection(path:  'users/${user.uid}/$path');
    return ref.upsert(data);
  }

}