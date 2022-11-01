import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserData {
  String? userID;
  String? userName;
  String? lastName;
  String? contact;
  String? role;
  String? pic;
  bool? subscrp;
  Timestamp? subDate;
  Timestamp? endDate;
  String? timeZone;
  String? subscrpType;
  double? amount;

  UserData({
    required this.contact,
    required this.endDate,
    required this.lastName,
    required this.pic,
    required this.role,
    required this.subDate,
    required this.subscrp,
    required this.timeZone,
    required this.userID,
    required this.userName,
    required this.amount,
    required this.subscrpType,
  });

  UserData.fromMap(Map<String, dynamic> map) {
    userID = map['id'];
    contact = map['phone'];
    endDate = map['end_Date'];
    lastName = map['lastname'];
    pic = map['pic'];
    role = map['role'];
    subscrp = map['subscrp'];
    subDate = map['subscrp_date'];
    timeZone = map['timezone'];
    userName = map['firstname'];
    amount = double.parse(map['amount'].toString());
    subscrpType = map['subscrp_type'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': userID,
      'phone': contact,
      'end_Date': endDate,
      'lastname': lastName,
      'pic': pic,
      'role': role,
      'subscrp': subscrp,
      'subscrp_date': subDate,
      'timezone': timeZone,
      'firstname': userName,
      'subscrp_type': subscrpType,
      'amount': amount
    };
  }
}
