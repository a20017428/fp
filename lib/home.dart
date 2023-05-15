import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fp/data.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fp/notification.dart';
import 'package:fp/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> entries = <String>['課表'];
  final List<String> entriesRoute = <String>['/schedule'];

  @override
  void initState() {
    super.initState();

    Noti.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    print('home u $user');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.blue, Colors.lightBlueAccent.shade200]),
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 10.0,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 200,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [Colors.blue.shade600, Colors.lightBlue.shade100],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: [
                        Data.avatarFile == null ? CircleAvatar(radius: 50, backgroundColor: Colors.grey.shade200,)
                            : CircleAvatar(
                          backgroundImage: FileImage(Data.avatarFile!),
                          radius: 50,
                        ),
                        Padding(padding: EdgeInsets.only(left: 20),),
                        Text(
                          Data.name == null ? '' : Data.name!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25.0),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Text(
                        user == null ? '' : user.email!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 13.0
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, size: 35,color: Colors.blue.shade300,),
              title: Text('Settings', style: TextStyle(fontSize: 22)),
              onTap: () {
                Navigator.of(context).pushNamed('/settings').then((_) {
                  setState(() => null);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle, size: 35, color: Colors.red,),
              title: Text('Account', style: TextStyle(fontSize: 22)),
              onTap: () {
                Navigator.of(context).pushNamed('/login').then((_) {
                  setState(() => null);
                });
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: listView(entries.length),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Noti.showBigTextNotification(title: '30分鐘後上課', body: '演算法', fln: flutterLocalNotificationsPlugin);
        },
      ),
    );
  }

  List<Widget> listView(int num){
    return List.generate(num, (i) => Container(
      margin: EdgeInsets.all(20),
      width: 150,
      height: 90,
      child: MaterialButton(
        onPressed: (){
          Navigator.of(context).pushNamed(entriesRoute[i]);
        },
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        child: Ink(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400, width: 2),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [Colors.lightBlueAccent, Colors.indigoAccent.shade200],
            ),
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
          child: Center(
            child: Text(
              entries[i],
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
          ),
        ),
      ),
    ),);
  }
}