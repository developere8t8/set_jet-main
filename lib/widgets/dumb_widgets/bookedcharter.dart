import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/model/charter.dart';
import 'package:set_jet/model/flights.dart';
import 'package:set_jet/model/planes.dart';
import 'package:set_jet/model/usermodel.dart';
import 'package:set_jet/theme/common.dart';
import 'package:set_jet/theme/dark.dart';
import 'package:set_jet/theme/light.dart';
import 'package:set_jet/views/booked_charter_detail/booked_charter_detail_view.dart';
import 'package:set_jet/widgets/dumb_widgets/search_param_selector.dart';
import 'package:intl/intl.dart';

class Bookings extends StatefulWidget {
  final Flights flight;
  final UserData userData;
  const Bookings({Key? key, required this.flight, required this.userData}) : super(key: key);

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  Charter? charter;
  UserData? operator;
  Planes? plane;

  //getting chaerter deatail and operator detail

  Future getcharter() async {
    QuerySnapshot snapshotcharter = await FirebaseFirestore.instance
        .collection('charters')
        .where('id', isEqualTo: widget.flight.charterid)
        .get();
    if (snapshotcharter.docs.isNotEmpty) {
      setState(() {
        charter = Charter.fromMap(snapshotcharter.docs.first.data() as Map<String, dynamic>);
      });
    }
    QuerySnapshot snapshotuser = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: widget.flight.opid)
        .get();
    if (snapshotuser.docs.isNotEmpty) {
      setState(() {
        operator = UserData.fromMap(snapshotuser.docs.first.data() as Map<String, dynamic>);
      });
    }
    QuerySnapshot snapshotplan = await FirebaseFirestore.instance
        .collection('planes')
        .where('id', isEqualTo: charter!.planeid)
        .get();
    if (snapshotplan.docs.isNotEmpty) {
      setState(() {
        plane = Planes.fromMap(snapshotplan.docs.first.data() as Map<String, dynamic>);
      });
    }
  }

  @override
  void initState() {
    getcharter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookedCharterDetailView(
                      charter: charter!,
                      plane: plane!,
                      operator: operator!,
                      user: widget.userData,
                      flight: widget.flight,
                    )));
      }, //viewModel.goToDetails,//goto charterdetails TODO
      child: plane == null
          ? Center(child: Container())
          : Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: isLight ? lightSecondary : darkSecondary,
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 180.h,
                    color: accentColor,
                    padding: EdgeInsets.only(top: 8.h),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 100.w,
                              child: Text(
                                widget.flight.from.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // SizedBox(
                            //     width: 100.w,
                            //     child: Row(
                            //       children: [
                            //         Expanded(
                            //           child: Text(
                            //             widget.flight.from.toString(),
                            //             //overflow: TextOverflow.ellipsis,
                            //             style: GoogleFonts.rubik(
                            //               color: Colors.white,
                            //               fontWeight: FontWeight.bold,
                            //             ),
                            //           ),
                            //         )
                            //       ],
                            //     )),
                            Image.asset(
                              "assets/flight_card.png",
                              height: 25.h,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 100.w,
                              child: Text(
                                widget.flight.to.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
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
                                  text:
                                      DateFormat('EEE MMM dd yyyy').format(widget.flight.date!.toDate()),
                                ),
                                SearchParamWidget(
                                  icon: Icons.timer,
                                  text:
                                      '${DateFormat('hh:mm a').format(widget.flight.date!.toDate())}\n ${DateTime.parse(widget.flight.date!.toDate().toString()).timeZoneName}',
                                ),
                                SearchParamWidget(
                                  icon: Icons.people_outline,
                                  text: plane!.seats.toString(),
                                ),
                                const SearchParamWidget(
                                  icon: Icons.airplanemode_on,
                                  text: "One way",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ListTile(
                    leading: operator!.pic == ''
                        ? const CircleAvatar(
                            radius: 20.0,
                            backgroundImage: AssetImage("assets/profile.png"),
                          )
                        : CircleAvatar(
                            radius: 20.0,
                            backgroundImage: NetworkImage(operator!.pic!),
                          ),
                    title: Text('${operator!.userName!} ${operator!.lastName!}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            //sending mail request request
                          },
                          icon: const Icon(Icons.mail),
                          color: accentColor,
                        ),
                        IconButton(
                          onPressed: () {
                            //sendoing call request
                          },
                          icon: const Icon(Icons.phone),
                          color: accentColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: plane!.pics![0] == ''
                              ? const CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage: AssetImage("assets/plane_square.png"),
                                )
                              : CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage: NetworkImage(plane!.pics![0]),
                                ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plane!.brand!,
                                style: GoogleFonts.rubik(
                                  color: isLight ? const Color(0xcc242424) : const Color(0xccffffff),
                                ),
                              ),
                              Text(
                                plane!.planeName!,
                                style: GoogleFonts.rubik(fontWeight: FontWeight.bold, fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                        Expanded(flex: 2, child: Container())
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "\$${charter!.price}",
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
    );
  }
}
