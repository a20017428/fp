import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fp/main.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fp/utils.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String title;

  const ForgotPasswordPage({Key? key, required this.title}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends  State<ForgotPasswordPage> {
  late String title;
  final formKey = GlobalKey<FormState>();
  TextEditingController _textFieldController1 = TextEditingController();

  @override
  void initState() {
    super.initState();

    title = widget.title;
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
      body: Form(
        key: formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Receive an email to reset your password'),
              Padding(padding: EdgeInsets.only(top: 20),),
              SizedBox(
                width: 300,
                height: 60,
                child: TextFormField(
                  autofocus: true,
                  controller: _textFieldController1,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email' : null,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20),),
              SizedBox(
                width: 200,
                height: 55,
                child: MaterialButton(
                  onPressed: () {
                    resetPassword();
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                  padding: const EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [Colors.yellow.shade400, Colors.redAccent.shade200],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                      alignment: Alignment.center,
                      child: const Text(
                        'Reset password',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20),),
            ],
          ),
        ),
      ),
    );
  }

  Future resetPassword() async{
    bool successful = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try{
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _textFieldController1.text.trim());
      Utils.showSnackBar('Password reset email sent');
    } on FirebaseException catch (e){
      print(e);

      successful = false;

      Utils.showSnackBar(e.message);
    }

    if(successful)
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    else{
      Navigator.pop(context);
    }


  }
}