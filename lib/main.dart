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
import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fp/notification.dart';
import 'package:fp/database_manager.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeService();
  runApp(new MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

Future<bool> onIosBackground(ServiceInstance serviceInstance) async {
  return true;
}

onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "My App Service",
        content: "Updated at ${DateTime.now()}",
      );
    }

    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
      },
    );

    var now = DateTime.now();
    //final time = ["8:10~9:00", "9:10~10:00", "10:10~11:00", "11:10~12:00", "13:10~14:00", "14:10~15:00", "15:10~16:00", "16:10~17:00", "17:10~18:00", "18:10~18:55", "19:00~19:45", "19:50~20:35", "20:40~21:25", "21:30~22:15", "7:10~8:00", "12:10~13:00"];
    final time = ["23:10~23:11", "9:10~10:00", "10:10~11:00", "11:10~12:00", "13:10~14:00", "14:10~15:00", "15:10~16:00", "16:10~17:00", "17:10~18:00", "18:10~18:55", "19:00~19:45", "19:50~20:35", "20:40~21:25", "21:30~22:15", "7:10~8:00", "12:10~13:00"];

    for(int i = 0; i<time.length; ++i){
      if(/*schedules[(now.weekday*16-1)+i] != "" && */now.hour*60+now.minute+30 == int.parse(time[i].split('~')[0].split(":")[0])*60+int.parse(time[i].split('~')[0].split(":")[1])){
        Noti.showBigTextNotification(
            title: '30分鐘後上課',
            body: Data.schedules[now.weekday*16+i],
            fln: flutterLocalNotificationsPlugin
        );
        print(Data.schedules);
      }
    }
  });
}

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