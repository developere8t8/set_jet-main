import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/model/charter.dart';
import 'package:set_jet/model/planes.dart';
import 'package:set_jet/model/usermodel.dart';
import 'package:set_jet/theme/dark.dart';
import 'package:set_jet/theme/light.dart';
import 'package:set_jet/views/charter_details/charter_details_view.dart';
import 'package:set_jet/widgets/dumb_widgets/search_param_selector.dart';
import 'package:snack/snack.dart';

import '../../theme/common.dart';
import '../smart_widgets/custom_blurred_drawer/custom_blurred_drawer_widget.dart';

class SearchCharterResult extends StatefulWidget {
  final Charter charter;
  final UserData data;

  const SearchCharterResult({Key? key, required this.data, required this.charter}) : super(key: key);

  @override
  State<SearchCharterResult> createState() => _SearchCharterResultState();
}

class _SearchCharterResultState extends State<SearchCharterResult> {
  List<Planes> planes = [];
  UserData? operator;

  void getPlane() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('planes')
        .where('id', isEqualTo: widget.charter.planeid)
        .get();
    QuerySnapshot snapshotuser = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: widget.charter.operator)
        .get();
    setState(() {
      operator = UserData.fromMap(snapshotuser.docs.first.data() as Map<String, dynamic>);
      planes = snapshot.docs.map((d) => Planes.fromMap(d.data() as Map<String, dynamic>)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getPlane();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var isLight = theme.brightness == Brightness.light;
    return GestureDetector(
      onTap: () {
        loadingBar('loading locations... please wait', true, 4);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CharterDetailsView(
                      charter: widget.charter,
                      userdata: widget.data,
                      plane: planes.first,
                      operator: operator!,
                      visible: true,
                    )));
      },
      child: planes.isEmpty
          ? Center(
              child: Container(),
            )
          : Container(
              margin: const EdgeInsets.only(top: 5.0),
              //height: 320.h,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: isLight ? lightSecondary : darkSecondary,
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
                    color: accentColor,
                    padding: EdgeInsets.all(8.h),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.h),
                          child: Row(
                            children: [
                              planes[0].pics![0] == ''
                                  ? const CircleAvatar(
                                      radius: 20.0,
                                      backgroundImage: AssetImage("assets/plane_square.png"),
                                    )
                                  : CircleAvatar(
                                      radius: 20.0,
                                      backgroundImage: NetworkImage(planes[0].pics![0]),
                                    ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      planes[0].brand.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      planes[0].planeName.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.rubik(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 50.w,
                              ),
                              Expanded(
                                  child: Row(
                                children: [
                                  const Icon(
                                    Icons.airline_seat_recline_extra_rounded,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${planes[0].seats} Seats',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.rubik(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  // Row with check icon and text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          planes[0].type.toString(),
                          style: GoogleFonts.rubik(
                            fontSize: 16.sp,
                            color: accentColor,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(child: Text('From: ${widget.charter.fromAirport}')),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [Expanded(child: Text('To: ${widget.charter.toAirport}'))],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              planes[0].wyvern == true ? Icons.check : Icons.close,
                              color: planes[0].wyvern == true ? accentColor : Colors.red,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Expanded(
                              child: Text(
                                'WYVERN',
                                style: GoogleFonts.rubik(
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              planes[0].wifi == true ? Icons.check : Icons.close,
                              color: planes[0].wifi == true ? accentColor : Colors.red,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Expanded(
                              child: Text(
                                'Wifi',
                                style: GoogleFonts.rubik(
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              planes[0].placeholder == true ? Icons.check : Icons.close,
                              color: planes[0].placeholder == true ? accentColor : Colors.red,
                            ),
                            const SizedBox(
                              width: 2,
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
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.h),
                    child: operator == null
                        ? const CircularProgressIndicator(
                            color: Colors.green,
                          )
                        : Row(
                            children: [
                              operator!.pic!.isEmpty
                                  ? const CircleAvatar(
                                      radius: 20.0,
                                      backgroundImage: AssetImage("assets/profile.png"),
                                    )
                                  : CircleAvatar(
                                      radius: 20.0,
                                      backgroundImage: NetworkImage(operator!.pic!),
                                    ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: Text(
                                  operator!.userName!.isEmpty
                                      ? 'loading user detail'
                                      : '${operator!.userName} ${operator!.lastName}',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.rubik(
                                      fontWeight: FontWeight.bold, fontSize: 16.sp, color: accentColor),
                                ),
                              )
                            ],
                          ),
                  ),
                  Container(
                    width: 200,
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
    );
  }

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
}
