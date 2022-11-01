import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:set_jet/model/chatroom.dart';
import 'package:set_jet/model/contact.dart';
import 'package:set_jet/model/flights.dart';
import 'package:set_jet/model/message.dart';
import 'package:set_jet/theme/common.dart';
import 'package:set_jet/theme/dark.dart';
import 'package:set_jet/theme/light.dart';
import 'package:http/http.dart' as http;
import 'package:set_jet/views/home/home_view.dart';
import 'package:set_jet/widgets/smart_widgets/custom_blurred_drawer/custom_blurred_drawer_widget.dart';
import 'package:snack/snack.dart';
import '../../constants/strings.dart';
import '../../model/charter.dart';
import '../../model/planes.dart';
import '../../model/usermodel.dart';

class CharterDetailsView extends StatefulWidget {
  final UserData userdata;
  final Charter charter;
  final Planes plane;
  final UserData operator;
  final bool visible;
  const CharterDetailsView(
      {Key? key,
      required this.userdata,
      required this.charter,
      required this.plane,
      required this.operator,
      required this.visible})
      : super(key: key);

  @override
  State<CharterDetailsView> createState() => _CharterDetailsViewState();
}

class _CharterDetailsViewState extends State<CharterDetailsView> {
  DateTime bookingdate = DateTime.now();
  TimeOfDay bookingTime = const TimeOfDay(hour: 9, minute: 00);
  List<LatLng> latLong = [];
  List<Polyline> polyline = [];
  // bool? placeholder = true;
  // bool? wifi = true;
  // bool? wyvern = true;
  String? type;
  CameraPosition? position; //CameraPosition(target: LatLng(33.63779875, -84.42927118585675), zoom: 8);
  GoogleMapController? controller;
  List<Marker> markers = [];
  String apiKey = googleMapApiKey; //'AIzaSyCEmHBhem_KFl1_prIbKS2wIA1pTDGRB74'; // google map api key
//setting markers of flight range
  void addMarkerDestination() async {
    //getting from location coordinates
    Uri fromUri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${widget.charter.fromAirport}&key=$apiKey');
    //getting destination location coordinates
    Uri toUri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${widget.charter.toAirport}&key=$apiKey');
    final toResponse = await http.get(toUri);
    final fromResponse = await http.get(fromUri);

    if (fromResponse.statusCode == 200) {
      var temp = jsonDecode(fromResponse.body)['results'];
      for (var element in temp) {
        Map obj = element;
        Map geo = obj['geometry'];
        Map loc = geo['location'];
        setState(() {
          latLong.add(LatLng(loc['lat'], loc['lng']));
          markers.add(Marker(
              markerId: MarkerId(widget.charter.fromAirport.toString()),
              position: LatLng(latLong[0].latitude, latLong[0].longitude),
              infoWindow: InfoWindow(title: widget.charter.fromAirport.toString())));
        });
      }
    }
    if (toResponse.statusCode == 200) {
      var toTemp = jsonDecode(toResponse.body)['results'];
      for (var toelement in toTemp) {
        Map toobj = toelement;
        Map togeo = toobj['geometry'];
        Map toloc = togeo['location'];
        setState(() {
          latLong.add(LatLng(toloc['lat'], toloc['lng']));
          markers.add(Marker(
              markerId: MarkerId(widget.charter.toAirport.toString()),
              position: LatLng(latLong[1].latitude, latLong[1].longitude),
              infoWindow: InfoWindow(title: widget.charter.toAirport.toString())));
          position = CameraPosition(target: LatLng(latLong[1].latitude, latLong[1].longitude), zoom: 5);
          polyline.add(Polyline(polylineId: const PolylineId('1'), points: latLong, color: Colors.red));
        });
        controller?.animateCamera(CameraUpdate.newCameraPosition(position!));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    addMarkerDestination();
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    // return ViewModelBuilder<CharterDetailsViewModel>.reactive(
    // builder: (BuildContext context, CharterDetailsViewModel viewModel, Widget? _) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: MaterialButton(
            child: Image.asset('assets/drawer_${!isLight ? 'dark' : 'light'}.png'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomBlurredDrawerWidget(data: widget.userdata)));
            },
          ),
          backgroundColor: isLight ? Colors.white : Colors.black,
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                }, //viewModel.back,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: accentColor,
                ),
              ),
              Text(
                "Charter Details",
                style: isLight ? darkText : lightText,
              ),
            ],
          ),
          // actions: [
          //   IconButton(
          //       onPressed: () {},
          //       icon: Icon(
          //         Icons.more_vert,
          //       ))
          // ],
        ),
        body: ListView(
          shrinkWrap: true,
          primary: false,
          children: [
            SizedBox(
              height: 150.h,
              child: widget.plane.pics!.first == ''
                  ? Image.asset("assets/plane_full.png")
                  : Image.network(
                      widget.plane.pics!.first,
                      fit: BoxFit.cover,
                    ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.plane.brand.toString(),
                        style: GoogleFonts.rubik(
                          color: isLight ? const Color(0xcc242424) : const Color(0xccffffff),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.airline_seat_recline_extra,
                            color: accentColor,
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            "${widget.plane.seats} seats",
                            style: GoogleFonts.rubik(),
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.plane.planeName.toString(),
                              style: GoogleFonts.rubik(fontWeight: FontWeight.bold, fontSize: 21.sp),
                            ),
                            Text(
                              widget.plane.type.toString(),
                              style: GoogleFonts.rubik(color: accentColor),
                            ),
                            Row(
                              children: [
                                Expanded(child: Text('From: ${widget.charter.fromAirport}')),
                              ],
                            ),
                            Row(
                              children: [Expanded(child: Text('To: ${widget.charter.toAirport}'))],
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Container())
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        widget.plane.wyvern == true ? Icons.check : Icons.close,
                        color: widget.plane.wyvern == true ? accentColor : Colors.red,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Expanded(
                        child: Text(
                          'WYVERN',
                          style: GoogleFonts.rubik(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Icon(
                        widget.plane.wifi == true ? Icons.check : Icons.close,
                        color: widget.plane.wifi == true ? accentColor : Colors.red,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Expanded(
                        child: Text(
                          'Wifi',
                          style: GoogleFonts.rubik(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Icon(
                        widget.plane.placeholder == true ? Icons.check : Icons.close,
                        color: widget.plane.placeholder == true ? accentColor : Colors.red,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Expanded(
                        child: Text(
                          'Placeholder',
                          style: GoogleFonts.rubik(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    width: 200.w,
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '\$ ${widget.charter.price}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                        color: accentColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            //const AdSection(),
            SizedBox(
              height: 10.h,
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              height: 600.h,
              child: position == null
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    )
                  : GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: position!,
                      markers: Set<Marker>.of(markers),
                      polylines: Set<Polyline>.of(polyline),
                      onMapCreated: (GoogleMapController contrl) {
                        setState(() {
                          controller = contrl;
                        });
                      },
                    ),
            ),
            SizedBox(
              height: 10.h,
            ),
            // ROw with two text
            Container(
              margin: EdgeInsets.all(8.w),
              padding: EdgeInsets.all(8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Flight Range",
                    style: GoogleFonts.rubik(
                        color: (isLight ? bgColorDark : Colors.white).withOpacity(0.6)),
                  ),
                  Text(
                    '${roundDouble(double.parse(widget.charter.range.toString()), 1)} km',
                    style: GoogleFonts.rubik(
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.all(8.w),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                    color: isLight ? lightSecondary : Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                height: 50.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Wifi',
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CupertinoSwitch(
                      value: widget.plane.wifi!,
                      onChanged: (val) {},
                      activeColor: accentColor,
                    )
                  ],
                )),
            Container(
                margin: EdgeInsets.all(8.w),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                    color: isLight ? lightSecondary : Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                height: 50.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'WYVERN',
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CupertinoSwitch(
                      value: widget.plane.wyvern!,
                      onChanged: (val) {},
                      activeColor: accentColor,
                    )
                  ],
                )),
            Container(
                margin: EdgeInsets.all(8.w),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                    color: isLight ? lightSecondary : Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                height: 50.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Placeholder',
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CupertinoSwitch(
                      value: widget.plane.placeholder!,
                      onChanged: (val) {},
                      activeColor: accentColor,
                    )
                  ],
                )),
            SizedBox(
              height: 20.h,
            ),
            Container(
              margin: EdgeInsets.all(16.h),
              decoration: BoxDecoration(
                color: isLight ? lightSecondary : darkSecondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(children: [
                ListTile(
                  leading: widget.operator.pic!.isEmpty
                      ? const CircleAvatar(
                          radius: 20.0,
                          backgroundImage: AssetImage("assets/profile.png"),
                        )
                      : CircleAvatar(
                          radius: 20.0,
                          backgroundImage: NetworkImage(widget.operator.pic!),
                        ),
                  title: Text(
                    '${widget.operator.userName!} ${widget.operator.lastName!}',
                    style: GoogleFonts.rubik(
                      color: accentColor,
                    ),
                  ),
                  subtitle: Text(
                    "Operator",
                    style: GoogleFonts.rubik(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: MaterialButton(
                    color: isLight ? lightSecondaryDarker : Colors.black,
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),
                    onPressed: () {
                      getChatRoom('message');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.mail,
                        ),
                        Text(
                          "Send Message",
                          style: GoogleFonts.rubik(),
                        ),
                        Container()
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: MaterialButton(
                    elevation: 0,
                    color: isLight ? lightSecondaryDarker : Colors.black,
                    padding: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),
                    onPressed: () {
                      getChatRoom('call');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.phone,
                        ),
                        Text(
                          "Send Call Request",
                          style: GoogleFonts.rubik(),
                        ),
                        Container()
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: MaterialButton(
                    color: isLight ? lightSecondaryDarker : Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),
                    onPressed: () {
                      getChatRoom('mail');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.mark_email_read_outlined,
                        ),
                        Text(
                          "Send Mail Request",
                          style: GoogleFonts.rubik(),
                        ),
                        Container()
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                )
              ]),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      color: accentColor,
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),
                      onPressed: () {
                        selectedDate(context, 'Select booking date');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          Text(
                            "Select booking date",
                            style: GoogleFonts.rubik(),
                          ),
                          Container()
                        ],
                      ),
                    ),
                    MaterialButton(
                      color: accentColor,
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),
                      onPressed: () {
                        selectedTime(context, 'Select booking time');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          Text(
                            "Select booking Time",
                            style: GoogleFonts.rubik(),
                          ),
                          Container()
                        ],
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'Booking date is ${DateFormat('MMM-dd-yyyy').format(bookingdate)}\n and Time is   ${bookingTime.hour.toString().padLeft(2, '0')} : ${bookingTime.minute.toString().padLeft(2, '0')}',
                style: GoogleFonts.rubik(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Visibility(
              visible: widget.visible,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: MaterialButton(
                  color: accentColor,
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),
                  onPressed: () {
                    bookCharter(); // booking acharter
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Text(
                        "Book",
                        style: GoogleFonts.rubik(),
                      ),
                      Container()
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
    //},
    //viewModelBuilder: () => CharterDetailsViewModel(),
    //);
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  //checking for already present chatroom

  Future getChatRoom(String request) async {
    loadingBar('sending $request request', true, 4);
    QuerySnapshot chatroomsnapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('participants.${widget.userdata.userID!}', isEqualTo: true)
        .where('participants.${widget.operator.userID!}', isEqualTo: true)
        .get();

    if (chatroomsnapshot.docs.isNotEmpty) {
      ChatRoomModel chatmodel =
          ChatRoomModel.fromMap(chatroomsnapshot.docs.first.data() as Map<String, dynamic>);
      sendMsg(chatmodel.ctrid!);
    } else {
      final chatroom = await FirebaseFirestore.instance.collection('chatrooms').doc();
      ChatRoomModel model = ChatRoomModel(
          ctrid: chatroom.id,
          createdon: Timestamp.fromDate(DateTime.now()),
          lastmessage: '',
          participants: {
            widget.userdata.userID!: true,
            widget.operator.userID!: true,
          });
      chatroom.set(model.toMap());
      sendMsg(chatroom.id);
    }

    final sendRequest = FirebaseFirestore.instance.collection('contact_requests').doc();

    ContactRequest newrequest = ContactRequest(
        id: sendRequest.id,
        receiver: widget.operator.userID,
        sender: widget.userdata.userID,
        senton: Timestamp.fromDate(DateTime.now()),
        status: 'Pending',
        charterid: widget.charter.id);
    sendRequest.set(newrequest.toMap());
  }
  //sending message

  void sendMsg(String chatroomid) {
    User? user = FirebaseAuth.instance.currentUser;
    String msg =
        'I am interested in your services please contact me \nphone # : ${widget.userdata.contact}\nemail: ${user!.email}';
    if (msg.isNotEmpty) {
      final msgUser = FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatroomid)
          .collection('messages')
          .doc();
      Messages msgs = Messages(
          messageid: msgUser.id,
          createdon: Timestamp.fromDate(DateTime.now()),
          seen: false,
          sender: widget.userdata.userID,
          text: msg);

      final lastmsg = FirebaseFirestore.instance.collection('chatrooms').doc(chatroomid);

      lastmsg.update({
        'lastmessage': msg,
        'created_on': Timestamp.fromDate(DateTime.now())
      }); //updating last message

      msgUser.set(msgs.toMap()); //saving new message
    }
  }

  //book a charter

  Future bookCharter() async {
    loadingBar('Booking this charter for you', true, 3);
    DateTime bookings = DateTime(
        bookingdate.year, bookingdate.month, bookingdate.day, bookingTime.hour, bookingTime.minute);
    final booking = FirebaseFirestore.instance.collection('flights').doc();
    Flights flight = Flights(
        charterid: widget.charter.id,
        date: Timestamp.fromDate(DateTime.parse(bookings.toString())),
        from: widget.charter.fromAirport,
        opid: widget.operator.userID,
        psngrid: widget.userdata.userID,
        status: 'completed',
        to: widget.charter.toAirport);
    await booking.set(flight.toMap());
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeView()));
  }

//loading bar
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

  //date picker
  selectedDate(BuildContext context, String _helptext) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime(2099),
        helpText: _helptext);
    if (picked != null) {
      setState(() {
        bookingdate = picked;
      });
    }
  }

  //time picker
  selectedTime(BuildContext context, String _helptext) async {
    const initalTime = TimeOfDay(hour: 9, minute: 00);
    final picked = await showTimePicker(context: context, initialTime: initalTime, helpText: _helptext);
    if (picked != null) {
      setState(() {
        bookingTime = picked;
      });
    }
  }
}
