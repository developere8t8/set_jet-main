import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  String? messageid;
  Timestamp? createdon;
  bool? seen;
  String? sender;
  String? text;

  Messages(
      {required this.messageid,
      required this.createdon,
      required this.seen,
      required this.sender,
      required this.text});
  Messages.fromMap(Map<String, dynamic> map) {
    messageid = map['messageid'];
    createdon = map['createdon'];
    seen = map['seen'];
    sender = map['sender'];
    text = map['text'];
  }

  Map<String, dynamic> toMap() {
    return {
      'messageid': messageid,
      'createdon': createdon,
      'seen': seen,
      'sender': sender,
      'text': text
    };
  }
}
