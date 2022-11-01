import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class Flights {
  String? from;
  String? to;
  Timestamp? date;
  String? opid;
  String? psngrid;
  String? status;
  String? charterid;

  Flights({
    required this.charterid,
    required this.date,
    required this.from,
    required this.opid,
    required this.psngrid,
    required this.status,
    required this.to,
  });

  Flights.fromMap(Map<String, dynamic> map) {
    from = map['from'];
    to = map['to'];
    date = map['date'];
    opid = map['opid'];
    psngrid = map['psngr_id'];
    status = map['status'];
    charterid = map['charterid'];
  }
  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'date': date,
      'opid': opid,
      'psngr_id': psngrid,
      'status': status,
      'charterid': charterid,
    };
  }
}
