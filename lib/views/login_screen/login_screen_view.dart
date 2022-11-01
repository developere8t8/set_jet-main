import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/loader.dart';
import 'package:set_jet/theme/common.dart';
import 'package:set_jet/views/pre_login/pre_login_view.dart';
import 'package:set_jet/widgets/dumb_widgets/app_button.dart';
import 'package:set_jet/widgets/dumb_widgets/app_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snack/snack.dart';
import 'package:stacked/stacked.dart';
import '../../model/usermodel.dart';
import '../home/home_view.dart';
import 'login_screen_view_model.dart';

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({Key? key}) : super(key: key);

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  UserData? data;
  void login() async {
    loadingBar('Loading .... please wait', true, 3);
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.text.trim(), password: password.text.trim());

      // if (!credential.user!.emailVerified) {
      //   await credential.user!.sendEmailVerification();
      //   loadingBar('Check your email for verification link', false, 3);
      // }

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: credential.user!.uid)
          .where('role', isEqualTo: 'user')
          .get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          data = UserData.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
        });       
        //ignore: use_build_context_synchronously
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeView()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        alert('Wrong password', 'Error', context);
      } else if (e.code == 'user-not-found') {
        alert(
            'Email is not registered yet \n go back and create an account or\n try other sign in methods',
            'Error',
            context);
      } else {
        alert(e.code.toString(), 'Error', context);
      }
    } catch (e) {
      alert(e.toString(), 'Error', context);
    }
  }

  @override
  void initState() {
    super.initState();   
  }

  @override
  Widget build(BuildContext context) {
    //ViewModelBuilder<LoginScreenViewModel>.reactive(
    //builder: (BuildContext context, LoginScreenViewModel viewModel, Widget? _) {
    final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
    //return Builder(builder: (context) {
    var theme = Theme.of(context);
    var isLight = theme.brightness == Brightness.light;
    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PreLoginView()));
            },
            icon: const Icon(Icons.arrow_back)),
        elevation: 0,
        iconTheme: IconThemeData(
          color: !isLight ? Colors.white : accentColor, //change your color here
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 100,
                child: Image.asset(
                  'assets/logo_${!isLight ? 'dark' : 'light'}.png',
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/social_Icon/${!isLight ? 'email1' : 'email2'}.png',
                                  height: 30.h,
                                  width: 30.w,
                                ),
                                Text(
                                  ' Sign in with Email',
                                  style: GoogleFonts.rubik(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey, //change your color here
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: AppTextField(
                                      label: 'Email',
                                      controller: email,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Expanded(
                                    child: AppTextField(
                                      label: 'Password',
                                      obscureText: true,
                                      controller: password,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 331.w,
                                height: 56.h,
                                child: AppButton(
                                  color: accentColor,
                                  textColor: Colors.white,
                                  text: 'Sign in',
                                  onpressed: () {
                                    login();
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  //);
  //},
  //viewModelBuilder: () => LoginScreenViewModel(),
  //);
  //}
  void loadingBar(String content, bool load, int duration) {
    final bar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(content),
          (load) ? const CircularProgressIndicator(color: Colors.red) : const Text(''),
        ],
      ),
      duration: Duration(seconds: duration),
    );
    bar.show(context);
  }

  void alert(String _content, String _title, _context) {
    showDialog(
        context: _context,
        builder: (context) => AlertDialog(
              title: Text(_title),
              content: Text(_content),
              actions: const [
                CloseButton(),
              ],
            ));
  }
}
