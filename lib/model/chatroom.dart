import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  String? ctrid;
  String? lastmessage;
  Timestamp? createdon;
  Map<String, dynamic>? participants;

  ChatRoomModel({
    required this.ctrid,
    required this.createdon,
    required this.lastmessage,
    required this.participants,
  });

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    ctrid = map['id'];
    participants = map['participants'];
    createdon = map['created_on'];
    lastmessage = map['lastmessage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': ctrid,
      'participants': participants,
      'created_on': createdon,
      'lastmessage': lastmessage
    };
  }
}
