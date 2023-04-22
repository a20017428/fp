import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:fp/data.dart';


class SettingPage extends StatefulWidget {
  final String title;

  const SettingPage({Key? key, required this.title}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late String title;
  File? avatarFile;

  TextEditingController _textFieldController1 = TextEditingController();
  @override
  void initState() {
    super.initState();

    title = widget.title;
    avatarFile = Data.avatarFile;
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
                child: avatarFile == null ? CircleAvatar(radius: 50, backgroundColor: Colors.grey.shade200,)
                    : CircleAvatar(
                  backgroundImage: FileImage(avatarFile!),
                  radius: 50,
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
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 50,
                  child: MaterialButton(
                    onPressed: () {
                      Data.avatarFile = avatarFile;
                      Data.name = _textFieldController1.text;

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
}