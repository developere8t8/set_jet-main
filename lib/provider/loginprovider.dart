import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:set_jet/model/fb.dart';

class LoginMethods extends ChangeNotifier {
  ////Google sign section starts from here
  final googleSignin = GoogleSignIn(); //google sign object
  GoogleSignInAccount? user; //user account details

  GoogleSignInAccount get gUser => user!; //maping user account details

  //function to google signin
  Future googleLogin() async {
    try {
      final googleUser = await googleSignin.signIn(); //getting user details

      if (googleUser == null) {
        return; //retrun if no details
      } else {
        user = googleUser;
      }

      final googleAuth = await googleUser.authentication; //getting authentication details

      final credential = GoogleAuthProvider.credential(
        //getting credentials
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential); //calling sign method

      final currentuser = FirebaseAuth.instance.currentUser;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: currentuser!.uid)
          .get();
      if (snapshot.docs.isEmpty) {
        final docUser = FirebaseFirestore.instance.collection('users').doc(currentuser.uid);
        final json = {
          'firstname': currentuser.displayName,
          'lastname': '',
          'phone': currentuser.phoneNumber,
          'pic': currentuser.photoURL,
          'terms': true,
          'timezone': '',
          'subscrp': false,
          'subscrp_date': DateTime.now(),
          'end_Date': DateTime.now().add(const Duration(days: 15)),
          'amount': 0,
          'subscrp_type': 'trail',
          'id': currentuser.uid,
          'role': 'user',
        };
        await docUser.set(json);
      } else {
        final docUser = FirebaseFirestore.instance.collection('users').doc(currentuser.uid);
        final json = {
          'firstname': currentuser.displayName,
          'lastname': '',
          'phone': currentuser.phoneNumber,
          //'pic': currentuser.photoURL,
          'terms': true,
          'timezone': '',
          'subscrp': false,
          //'subscrp_date': DateTime.now(),
          //'end_Date': DateTime.now().add(const Duration(days: 15)),
          'amount': 0,
          //'subscrp_type': 'trail',
          'id': currentuser.uid,
          //'role': 'op',
        };
        await docUser.update(json);
      }
    } catch (e) {
      throw e.toString();
    }

    notifyListeners(); //applying updates
  }

  //logout  event
  Future logout() async {
    googleSignin.disconnect();
    await FirebaseAuth.instance.signOut();
    //notifyListeners();
  }

  //facebook login
  Future fbLogin() async {
    final LoginResult result =
        await FacebookAuth.instance.login(permissions: (['email', 'public_profile']));
    final token = result.accessToken!.token;

    final graphResponse = await http.get(Uri.parse('https://graph.facebook.com/'
        'v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));

    //final profile = jsonDecode(graphResponse.body);

    try {
      final AuthCredential facebookCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(facebookCredential);

      FaceBookLoginInfo fbinfo = FaceBookLoginInfo.fromMap(jsonDecode(graphResponse.body));
      final currentuser = FirebaseAuth.instance.currentUser;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: currentuser!.uid)
          .get();
      if (snapshot.docs.isEmpty) {
        final docUser = FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid);
        final json = {
          'firstname': fbinfo.fname,
          'lastname': fbinfo.lname,
          'phone': userCredential.user!.phoneNumber,
          'pic': userCredential.user!.photoURL,
          'terms': true,
          'timezone': '',
          'subscrp': false,
          'subscrp_date': DateTime.now(),
          'end_Date': DateTime.now().add(const Duration(days: 15)),
          'amount': 0,
          'subscrp_type': 'trail',
          'id': currentuser.uid,
          'role': 'user',
        };
        await docUser.set(json);
      } else {
        final docUser = FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid);
        final json = {
          'firstname': fbinfo.fname,
          'lastname': fbinfo.lname,
          'phone': userCredential.user!.phoneNumber,
          //'pic': userCredential.user!.photoURL,
          'terms': true,
          'timezone': '',
          'subscrp': false,
          //'subscrp_date': DateTime.now(),
          //'end_Date': DateTime.now().add(const Duration(days: 15)),
          'amount': 0,
          //'subscrp_type': 'trail',
          'id': currentuser.uid,
          //'role': 'user',
        };
        await docUser.update(json);
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
