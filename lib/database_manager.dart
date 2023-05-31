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

  Future<void> uploadData(String key) async {
    if(key == 'schedule')
      FirebaseFirestore.instance.collection(user!.uid).doc(key)
          .set({key: Data.schedules});
    else if(key == 'url')
      FirebaseFirestore.instance.collection(user!.uid).doc(key)
          .set({key: Data.url});
    else if(key == 'name')
      FirebaseFirestore.instance.collection(user!.uid).doc(key)
          .set({key: Data.name});
    else if(key == 'holiday')
      FirebaseFirestore.instance.collection(user!.uid).doc(key)
          .set({key: Data.holiday});
  }

  Future<void> downloadData(String key) async {
    FirebaseFirestore.instance.collection(user!.uid).doc(key).get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      if(data[key] == null) return;
      if(key == 'schedule')
        Data.schedules = List.from(data[key]);
      else if(key == 'url')
        Data.url = data[key];
      else if(key == 'name')
        Data.name = data[key];
      else if(key == 'holiday')
        Data.holiday = List.from(data[key]);
    });
  }
}
