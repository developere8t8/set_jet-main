import 'package:cloud_firestore/cloud_firestore.dart';

class Charter {
  String? id;
  String? fromAirport;
  String? toAirport;
  String? operator;
  double? price;
  String? planeid;
  bool? active;
  Timestamp? createdon;
  String? range;

  Charter(
      {required this.id,
      required this.fromAirport,
      required this.toAirport,
      required this.operator,
      required this.active,
      required this.createdon,
      required this.price,
      required this.planeid,
      required this.range});

  Charter.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    fromAirport = map['from'];
    toAirport = map['to'];
    operator = map['opid'];
    active = map['active'];
    createdon = map['createdon'];
    price = double.parse(map['price'].toString());
    planeid = map['planeid'];
    range = map['range'];
  }
  Map<String, dynamic> toMap() {
    return {
      'from': fromAirport,
      'to': toAirport,
      'opid': operator,
      'active': active,
      'createdon': createdon,
      'price': price,
      'planeid': planeid,
      'id': id,
      'range': range
    };
  }
}
