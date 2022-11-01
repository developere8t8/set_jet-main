import 'package:cloud_firestore/cloud_firestore.dart';

class Remarks {
  String? id;
  String? feedback;
  String? remarks;
  String? sender;
  Timestamp? createdon;
  String? category;
  Remarks(
      {required this.createdon,
      required this.feedback,
      required this.id,
      required this.remarks,
      required this.sender,
      required this.category});
  Remarks.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    remarks = map['remarks'];
    feedback = map['feedback'];
    sender = map['sender'];
    createdon = map['created_on'];
    category = map['category'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'remarks': remarks,
      'feedback': feedback,
      'sender': sender,
      'created_on': createdon,
      'category': category
    };
  }
}
