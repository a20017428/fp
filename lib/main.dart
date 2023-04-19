import 'package:flutter/material.dart';
import 'package:fp/setting.dart';
import 'package:fp/login.dart';
import 'package:fp/schedule.dart';
import 'dart:io';
import 'package:fp/data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Final Project',
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Home Page'),
        '/login': (context) => LoginPage(title: 'Login Page'),
        '/settings': (context) => SettingPage(title: 'Setting Page'),
        '/schedule': (context) => SchedulePage(title: 'Schedule Page'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> entries = <String>['課表'];
  // final List<int> colorCodes = <int>[600, 500, 100, 100];
  List<String> navigateList = ['/schedule'];

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        Data.avatarFile == null ? CircleAvatar(radius: 50, backgroundColor: Colors.grey.shade300,)
                            : CircleAvatar(
                          backgroundImage: FileImage(Data.avatarFile!),
                          radius: 50,
                        ),
                        Padding(padding: EdgeInsets.only(left: 20),),
                        Text(
                          Data.name == null ? '無名' : Data.name!,
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
                          Data.mail == null ? "" : Data.mail!,
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
              leading: Icon(Icons.settings, size: 30,color: Colors.blue.shade300,),
              title: Text('Settings', style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.of(context).pushNamed('/settings').then((value) {
                  setState(() {
                  });
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, size: 30, color: Colors.red,),
              title: Text('Login', style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.of(context).pushNamed('/login');
              },
            ),

          ],
        ),
      ),
        body: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
            ),
            children: gridViewChildren(entries.length),
        ),
    );
  }


  List<Widget> gridViewChildren(num) {
    return List.generate(num, (i) => Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: Colors.black38, width: 0.5),
        ),
        child: Center(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: InkWell(
              onTap: (){
                Navigator.of(context).pushNamed(navigateList[i]);
              },
              child: Center(
                child: Text(
                  entries[i],
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}




