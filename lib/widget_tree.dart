import 'package:flutter_vinted_login/auth_firebase.dart';
import 'package:flutter_vinted_login/pages/home.dart';
import 'package:flutter_vinted_login/pages/login_register.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthFirebase().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Home();
          } else {
            return const LoginPage();
          }
        });
  }
}
