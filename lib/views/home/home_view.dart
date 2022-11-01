import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:set_jet/theme/common.dart';

import 'package:intl/intl.dart';

import 'package:set_jet/widgets/dumb_widgets/new_flights_header.dart';
import 'package:set_jet/widgets/smart_widgets/custom_blurred_drawer/custom_blurred_drawer_widget.dart';
import 'package:snack/snack.dart';
import '../../model/chatroom.dart';
import '../../model/flights.dart';
import '../../model/usermodel.dart';
import '../../widgets/dumb_widgets/header_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  UserData? userdata;
  final user = FirebaseAuth.instance.currentUser;
  bool isLoading = false;
  int unMessages = 0;
  int booked = 0;
  int expinDays = 0;
  bool alertVisible = false;
  List<Flights> previousFlights = [];
  List<Flights> flights = [];
  List<Flights> awaitingFlights = [];
  List<ChatRoomModel> chatmodel = [];

  Future getUserDetail() async {
    try {
      QuerySnapshot usersnap =
          await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: user!.uid).get();
      if (usersnap.docs.isNotEmpty) {
        setState(() {
          userdata = UserData.fromMap(usersnap.docs.first.data() as Map<String, dynamic>);
        });
      }
      //getting booked charters
      QuerySnapshot snapshotbooked = await FirebaseFirestore.instance
          .collection('flights')
          .where('psngr_id', isEqualTo: user!.uid)
          .get();
      //getting total flights
      flights =
          snapshotbooked.docs.map((d) => Flights.fromMap(d.data() as Map<String, dynamic>)).toList();

      //getting previous flights
      previousFlights = flights.where((e) => e.date!.toDate().isBefore(DateTime.now())).toList();

      //awaiting flights
      awaitingFlights =
          flights.where((element) => element.date!.toDate().isAfter(DateTime.now())).toList();

      //getting unread messages
      await FirebaseFirestore.instance
          .collection('chatrooms')
          .where('participants.${userdata!.userID}', isEqualTo: true)
          .get()
          .then((res) async {
        for (var result in res.docs) {
          QuerySnapshot shot = await FirebaseFirestore.instance
              .collection('chatrooms')
              .doc(result.id)
              .collection('messages')
              .where('seen', isEqualTo: false)
              .where('sender', isNotEqualTo: userdata!.userID)
              .get();
          unMessages += shot.docs.length;
        }
      });
      //setting variable for total boooked flights
      booked = awaitingFlights.isNotEmpty ? awaitingFlights.length : 0;

      setState(() {});
    } catch (e) {
      alert(e.toString(), 'Error', context);
    }
  }

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    //return ViewModelBuilder<HomeViewModel>.reactive(
    // builder: (BuildContext context, HomeViewModel viewModel, Widget? _) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    //var scaffoldKey = GlobalKey<ScaffoldState>();
    return WillPopScope(
        onWillPop: () async => false,
        child: userdata != null
            ? Scaffold(
                //key: scaffoldKey,
                appBar: AppBar(
                  backgroundColor: isLight ? const Color(0xffF1F1F1) : Colors.black,
                  elevation: 0,
                  title: Image.asset(
                    'assets/logo_${!isLight ? 'dark' : 'light'}.png',
                    height: 41.h,
                    width: 50.w,
                  ),
                  centerTitle: true,
                  leading: MaterialButton(
                    child: Image.asset('assets/drawer_${!isLight ? 'dark' : 'light'}.png'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomBlurredDrawerWidget(
                                    data: userdata!,
                                    unRead: unMessages,
                                  )));
                    },
                  ),
                  actions: [
                    Container(
                        margin: EdgeInsets.only(right: 25.w),
                        child: userdata!.pic!.isEmpty
                            ? CircleAvatar(
                                radius: 20.h,
                                backgroundColor: Colors.transparent,
                                child: CircleAvatar(
                                    radius: 20.h,
                                    backgroundImage: const AssetImage('assets/profile.png')),
                              )
                            : CircleAvatar(
                                radius: 20.h,
                                backgroundColor: Colors.transparent,
                                child: CircleAvatar(
                                    radius: 20.h,
                                    backgroundImage: NetworkImage(userdata!.pic.toString())),
                              ))
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 10.h,
                        color: isLight ? const Color(0xffF1F1F1) : Colors.black,
                      ),
                      HeaderWidget(messages: unMessages, booked: booked),
                      //const NotificationPanel(),
                      //const AdSection(),
                      NewFlightsHeader(data: userdata!),
                      const Text(
                        'Previous Flights',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 21.0),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ListView.builder(
                          itemCount: previousFlights.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            return FlightInfoCard(isLight: isLight, flightsFlights: flights[index]);
                          })
                    ],
                  ),
                ),
              )
            : Container());
  } //this should be removed

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

  void alert(String content, String title, context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: const [
                CloseButton(),
              ],
            ));
  }
}

class FlightInfoCard extends StatefulWidget {
  final bool isLight;
  final Flights? flightsFlights;
  const FlightInfoCard({Key? key, required this.isLight, required this.flightsFlights})
      : super(key: key);

  @override
  State<FlightInfoCard> createState() => _FlightInfoCardState();
}

class _FlightInfoCardState extends State<FlightInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: (widget.isLight ? const Color(0xffF5F5F5) : const Color(0xff404040)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100.w,
                  child: Text(
                    widget.flightsFlights!.from.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.rubik(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Image.asset(
                  "assets/flight_card.png",
                  height: 25.h,
                ),
                SizedBox(
                  width: 100.w,
                  child: Text(
                    widget.flightsFlights!.to.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.rubik(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 25.h,
            thickness: 1,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                      '${DateFormat('MMM dd yyyy').format(widget.flightsFlights!.date!.toDate())}\n${DateFormat('EEEE').format(widget.flightsFlights!.date!.toDate())}',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.rubik(fontSize: 14.sp)),
                ),
                const Text("   "),
                Expanded(
                  child: Text(
                    '${DateFormat('hh:mm a').format(widget.flightsFlights!.date!.toDate())}\n ${DateTime.parse(widget.flightsFlights!.date!.toDate().toString()).timeZoneName}',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
