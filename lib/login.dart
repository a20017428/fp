import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fp/login.dart';
import 'package:fp/account/log_out.dart';
import 'package:fp/account/auth.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key? key, required this.title}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends  State<LoginPage> {
  late String title;

  @override
  void initState() {
    super.initState();

    title = widget.title;
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          else if(snapshot.hasError){
            return Center(child: Text("Error"));
          }
          else if(snapshot.hasData){
            return Log_outPage(title: "Log out page");
          }
          else {
            return AuthPage(title: title);
          }
        },
      ),
    );
  }
}