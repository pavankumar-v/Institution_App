import 'dart:async';

import 'package:brindavan_student/models/notificationdata.dart';
import 'package:brindavan_student/models/subjects.dart';
import 'package:brindavan_student/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  String? branch;
  String? sem;
  DatabaseService({this.branch, this.sem});
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  //get usn true or false
  Future checkUsn(usn) async {
    try {
      var result = await _db
          .collection('usncollection')
          .doc('mq6CKVtsEqBoCJvMyeQQ')
          .get()
          .then((value) => {(value.data()!['$usn'])});
      return result.contains(false);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // set usn used
  Future setUsnUsed(usn) async {
    try {
      return await _db
          .collection('usncollection')
          .doc('mq6CKVtsEqBoCJvMyeQQ')
          .set({usn: true}, SetOptions(merge: true)).then(
        (_) => print('success'),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  // Upsert
  Future updateUserData(String usn, String fullName, int sem, String section,
      String branch) async {
    print('database updated');
    try {
      var url =
          'https://firebasestorage.googleapis.com/v0/b/brindavan-student-app.appspot.com/o/assets%2Favatars%2Fstudents%2Fdefault.png?alt=media&token=9ccbf074-a4e0-41bf-bba7-6fef4c4c54bf';
      return await _db.collection('users').doc(_auth.currentUser!.uid).set({
        'usn': usn,
        'fullName': fullName,
        'sem': sem,
        'section': section,
        'branch': branch,
        'avatar': url
      }, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //update avatar
  Future updateAvatar(String avatar) async {
    try {
      return await _db
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({'avatar': avatar}, SetOptions(merge: true));
    } catch (e) {
      print('avatar error');
      print(e.toString());
      return null;
    }
  }

  // stream  user data
  Stream<UserData> curUserData() {
    print('user Stream Called');
    return _db.collection('users').doc(_auth.currentUser!.uid).snapshots().map(
        (DocumentSnapshot<Map<String, dynamic>> snapshot) =>
            UserData.fromJson(snapshot.data()!));
  }

  //stream DataNotifcation
  Stream<List<NotificationData?>?> getNotifications() {
    print('notification Stream Called');
    return _db
        .collection('notifications')
        // .where('createdAt',
        //     isGreaterThan:
        //         DateTime.now().add(Duration(days: -10)).toIso8601String())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationData.fromJson(doc.data()))
            .toList());
  }

  Stream<List<Subjects?>?> getSubjects() {
    print('subjectScreamCalled');
    print('branch' + branch!);
    print('sem' + sem!);
    return _db
        .collection('branch')
        .doc('${branch.toString().toLowerCase()}')
        .collection('${sem.toString()}')
        .orderBy('id')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Subjects.fromJson(doc.data())).toList());
  }

  Future<dynamic> getUsn() async {
    try {
      dynamic result;
      result = await _db
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) => value.data()!);
      return result;
    } catch (e) {
      print('error' + e.toString());
      return null;
    }
  }

   Future<dynamic> getImg() {
    var result = _db
        .collection('assets')
        .doc('drawer_bg')
        .get()
        .then((value) => value.data()!['drawerBg']);

    return result;
  }


}

