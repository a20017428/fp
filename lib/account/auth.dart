import 'package:flutter/material.dart';
import 'package:fp/account/log_in.dart';
import 'package:fp/account/log_out.dart';
import 'package:fp/account/sign_up.dart';

class AuthPage extends StatefulWidget {
  final String title;

  const AuthPage({Key? key, required this.title}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends  State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? Log_inPage(title: "Log in page", onClickedSignUp: toggle)
      : Sign_UpPage(title: "Sign up page", onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}