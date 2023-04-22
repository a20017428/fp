import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fp/main.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fp/utils.dart';

class Sign_UpPage extends StatefulWidget {
  final String title;
  final Function() onClickedSignIn;

  const Sign_UpPage({Key? key, required this.title, required this.onClickedSignIn}) : super(key: key);

  @override
  _Sign_UpPageState createState() => _Sign_UpPageState();
}

class _Sign_UpPageState extends  State<Sign_UpPage> {
  late String title;
  final formKey = GlobalKey<FormState>();
  TextEditingController _textFieldController1 = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();

  @override
  void initState() {
    super.initState();

    title = widget.title;
  }

  @override
  void dispose() {

    _textFieldController1.dispose();
    _textFieldController2.dispose();
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
              Text('Welcome to SignUp Page'),
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
                width: 300,
                height: 60,
                child: TextFormField(
                  obscureText: true,
                  controller: _textFieldController2,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                  value != null && value.length < 6
                      ? 'Enter min 6 characters' : null,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20),),
              SizedBox(
                width: 200,
                height: 55,
                child: MaterialButton(
                  onPressed: () {
                    signUp();
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                  padding: const EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [Colors.greenAccent.shade400, Colors.cyanAccent],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                      alignment: Alignment.center,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20),),
              RichText(
                text: TextSpan(
                    text: 'Already have an account?  ',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignIn,
                        text: 'Sign In',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ]
                ),
              ),
            ],
          ),
        ),

      ),



    );
  }

  Future signUp() async{
    final isValid = formKey.currentState!.validate();
    if(!isValid) return;

    bool success = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _textFieldController1.text.trim(),
          password: _textFieldController2.text.trim(),
      );
    } on FirebaseException catch (e){
      print(e);

      success = false;

      Utils.showSnackBar(e.message);
    }

    if(success)
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    else
      Navigator.pop(context);
  }
}