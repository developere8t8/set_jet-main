class Planes {
  String? airport;
  String? brand;
  String? operator;
  List? pics;
  String? planeName;
  String? type;
  bool? wyvern;
  bool? placeholder;
  bool? wifi;
  double? price;
  int? seats;
  String? id;

  Planes(
      {required this.airport,
      required this.brand,
      required this.operator,
      this.pics,
      required this.placeholder,
      required this.planeName,
      required this.price,
      required this.seats,
      required this.type,
      required this.wifi,
      required this.wyvern,
      required this.id});
  Planes.fromMap(Map<String, dynamic> map) {
    airport = map['airport'];
    brand = map['brand'];
    operator = map['operator'];
    pics = map['pics'];
    planeName = map['plane_name'];
    type = map['type'];
    wyvern = map['MYVERN'];
    placeholder = map['placeholder'];
    wifi = map['wifi'];
    price = double.parse(map['price'].toString());
    seats = map['seats'];
    id = map['id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'airport': airport,
      'brand': brand,
      'operator': operator,
      'pics': pics,
      'plane_name': planeName,
      'type': type,
      'MYVERN': wyvern,
      'placeholder': placeholder,
      'wifi': wifi,
      'price': price,
      'seats': seats,
      'id': id,
    };
  }
}
