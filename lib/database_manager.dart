import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:fp/data.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';


class DataBaseManager {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> uploadData() async {
    FirebaseFirestore.instance.collection(user!.uid).doc('schedule')
        .set({'schedule': Data.schedules});
  }

  Future<void> downloadData() async {
    FirebaseFirestore.instance.collection(user!.uid).doc('schedule').get()
        .then((DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          Data.schedules = List.from(data['schedule']);
    });
  }
}
