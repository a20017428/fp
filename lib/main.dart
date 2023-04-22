import 'package:fp/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fp/setting.dart';
import 'package:fp/login.dart';
import 'package:fp/schedule.dart';
import 'dart:io';
import 'package:fp/data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fp/utils.dart';


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(new MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Final Project',
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(title: 'Home Page'),
        '/login': (context) => LoginPage(title: 'Login Page'),
        '/settings': (context) => SettingPage(title: 'Setting Page'),
        '/schedule': (context) => SchedulePage(title: 'Schedule Page'),
      },
    );
  }
}