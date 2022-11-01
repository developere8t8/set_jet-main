import 'package:cloud_firestore/cloud_firestore.dart';

class ContactRequest {
  String? id;
  String? receiver;
  String? sender;
  Timestamp? senton;
  String? status;
  String? charterid;

  ContactRequest(
      {required this.id,
      required this.receiver,
      required this.sender,
      required this.senton,
      required this.status,
      required this.charterid});
  ContactRequest.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    receiver = map['receiver'];
    sender = map['sender'];
    senton = map['sent_on'];
    status = map['status'];
    charterid = map['charterid'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'receiver': receiver,
      'sender': sender,
      'sent_on': senton,
      'status': status,
      'charterid': charterid
    };
  }
}
