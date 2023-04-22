import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Log_outPage extends StatefulWidget {
  final String title;

  const Log_outPage({Key? key, required this.title}) : super(key: key);

  @override
  _Log_outPageState createState() => _Log_outPageState();
}

class _Log_outPageState extends  State<Log_outPage> {
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
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.blue, Colors.lightBlueAccent.shade200]),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome ${user.email}'),
            Padding(padding: EdgeInsets.only(top: 20),),
            SizedBox(
              width: 120,
              height: 50,
              child: MaterialButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  setState(() => null);
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                padding: const EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [Colors.purpleAccent.shade200, Colors.redAccent.shade200],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                    alignment: Alignment.center,
                    child: const Text(
                      'Log out',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}