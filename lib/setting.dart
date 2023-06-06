import 'package:flutter/material.dart';
import 'package:fp/database_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:fp/data.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fp/build_progress.dart';

class SettingPage extends StatefulWidget {
  final String title;

  const SettingPage({Key? key, required this.title}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late String title;
  File? avatarFile;

  TaskSnapshot? uploadTask;

  TextEditingController _textFieldController1 = TextEditingController();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final User? user = FirebaseAuth.instance.currentUser;


  @override
  void initState() {
    super.initState();

    title = widget.title;
    DataBaseManager().downloadData('url');
    DataBaseManager().downloadData('name');
    _textFieldController1.text = Data.name == null ? "" : Data.name!;
  }

  @override
  void dispose() {

    _textFieldController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            Padding(padding: EdgeInsets.only(bottom: 50),),
            InkWell(
              onTap: () async {
                await pickImage(context);
              },
              child: SizedBox(
                width: 100,
                height: 100,
                child: IconButton(
                  onPressed: () => pickImage(context),
                  icon: Icon(Icons.image, size: 60,),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20),),
            SizedBox(
              width: 250,
              height: 60,
              child: TextFormField(
                autofocus: true,
                controller: _textFieldController1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(5),
                ],
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 50,
                  child: MaterialButton(
                    onPressed: () async {
                      buildProgress(context);
                      Data.name = _textFieldController1.text;
                      await uploadImage();
                      await DataBaseManager().uploadData('url');
                      await DataBaseManager().uploadData('name');



                      _textFieldController1.text = '';
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    padding: const EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          colors: [Colors.purpleAccent.shade200, Colors.lightBlueAccent.shade100],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                        alignment: Alignment.center,
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 30),),
                SizedBox(
                  width: 120,
                  height: 50,
                  child: MaterialButton(
                    onPressed: () {
                      _textFieldController1.text = '';
                      Navigator.pop(context);
                      Navigator.pop(context);
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
                          'Cancel',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 30),),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage(BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      setState((){
        avatarFile = File(image.path);
      });
      Navigator.pop(context);
    } on PlatformException catch(e){
      print('Failed ot pick image: $e');
    }
  }

  Future uploadImage() async {
    if (user == null || avatarFile == null) return;

    final fileName = path.basename(avatarFile!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      uploadTask = await ref.putFile(avatarFile!);
      Data.url = await uploadTask!.ref.getDownloadURL();
      print('url ${Data.url}');
    } catch (e) {
      print('error occured');
    }
  }
}