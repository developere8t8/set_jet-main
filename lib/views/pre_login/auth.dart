import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:set_jet/views/home/home_view.dart';
import 'package:set_jet/views/pre_login/pre_login_view.dart';

class AuthLogin extends StatefulWidget {
  const AuthLogin({Key? key}) : super(key: key);

  @override
  State<AuthLogin> createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        } else {
          if (snapshot.hasData) {
            return const HomeView();
          } else if (snapshot.hasError) {
            return PreLoginView();
          } else {
            return PreLoginView();
          }
        }
      },
    )));
  }
}
