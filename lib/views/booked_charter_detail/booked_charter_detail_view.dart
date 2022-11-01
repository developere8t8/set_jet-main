import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:set_jet/constants/strings.dart';
import 'package:set_jet/model/chatroom.dart';
import 'package:set_jet/model/contact.dart';
import 'package:set_jet/model/flights.dart';
import 'package:set_jet/model/message.dart';
import 'package:set_jet/model/planes.dart';
import 'package:set_jet/model/usermodel.dart';
import 'package:snack/snack.dart';
import '../../model/charter.dart';
import '../../theme/common.dart';
import '../../theme/dark.dart';
import '../../theme/light.dart';
import '../../widgets/dumb_widgets/search_param_selector.dart';
import '../../widgets/smart_widgets/custom_blurred_drawer/custom_blurred_drawer_widget.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class BookedCharterDetailView extends StatefulWidget {
  final Charter charter;
  final Planes plane;
  final UserData operator;
  final UserData user;
  final Flights flight;
  const BookedCharterDetailView(
      {Key? key,
      required this.charter,
      required this.operator,
      required this.plane,
      required this.user,
      required this.flight})
      : super(key: key);

  @override
  State<BookedCharterDetailView> createState() => _BookedCharterDetailViewState();
}

class _BookedCharterDetailViewState extends State<BookedCharterDetailView> {
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
    // return ViewModelBuilder<BookedCharterDetailViewModel>.reactive(
    // builder: (BuildContext context, BookedCharterDetailViewModel viewModel, Widget? _) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // key: scaffoldKey,
        // drawer: const CustomBlurredDrawerWidget(
        //   drawerOption: DrawerOptions.BookedCharters,
        // ),
        appBar: AppBar(
          leading: MaterialButton(
            child: Image.asset('assets/drawer_${!isLight ? 'dark' : 'light'}.png'),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => CustomBlurredDrawerWidget(data: widget.user)));
            },
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Image.asset(
            'assets/logo_${!isLight ? 'dark' : 'light'}.png',
            height: 41.h,
            width: 50.w,
          ),
          centerTitle: true,
          // actions: [
          //   IconButton(
          //     onPressed: () {},
          //     icon: const Icon(
          //       Icons.more_vert,
          //     ),
          //   )
          // ],
        ),
        body: ListView(
          shrinkWrap: true,
          primary: false,
          children: [
            Container(
              height: 80,
              margin: const EdgeInsets.all(8.0),
              // padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xff126ABD),
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: Row(
                children: [
                  SearchParamWidget(
                    icon: Icons.calendar_view_month,
                    text: DateFormat('EEE MMM dd yyyy').format(widget.flight.date!.toDate()),
                  ),
                  SearchParamWidget(
                    icon: Icons.timer,
                    text:
                        '${DateFormat('hh:mm a').format(widget.flight.date!.toDate())}\n ${DateTime.parse(widget.flight.date!.toDate().toString()).timeZoneName}',
                  ),
                  SearchParamWidget(
                    icon: Icons.people_outline,
                    text: widget.plane.seats.toString(),
                  ),
                  const SearchParamWidget(
                    icon: Icons.airplanemode_on,
                    text: "One way",
                  ),
                ],
              ),
            ),
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
        .where('participants.${widget.user.userID!}', isEqualTo: true)
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
            widget.user.userID!: true,
            widget.operator.userID!: true,
          });
      chatroom.set(model.toMap());
      sendMsg(chatroom.id);
    }

    final sendRequest = FirebaseFirestore.instance.collection('contact_requests').doc();

    ContactRequest newrequest = ContactRequest(
        id: sendRequest.id,
        receiver: widget.operator.userID,
        sender: widget.user.userID,
        senton: Timestamp.fromDate(DateTime.now()),
        status: 'Pending',
        charterid: widget.charter.id);
    sendRequest.set(newrequest.toMap());
  }
  //sending message

  void sendMsg(String chatroomid) {
    User? user = FirebaseAuth.instance.currentUser;
    String msg =
        'I am interested in your services please contact me \nphone # : ${widget.user.contact}\nemail: ${user!.email}';
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
          sender: widget.user.userID,
          text: msg);

      final lastmsg = FirebaseFirestore.instance.collection('chatrooms').doc(chatroomid);

      lastmsg.update({
        'lastmessage': msg,
        'created_on': Timestamp.fromDate(DateTime.now())
      }); //updating last message

      msgUser.set(msgs.toMap()); //saving new message
    }
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
}
