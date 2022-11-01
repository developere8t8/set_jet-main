import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/theme/common.dart';

class PreviousFlights extends StatelessWidget {
  const PreviousFlights({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      margin: EdgeInsets.only(left: 25.w, right: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Previous Flights",
            style: GoogleFonts.rubik(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          FlightInfoCard(isLight: isLight),
          FlightInfoCard(isLight: isLight),
          FlightInfoCard(isLight: isLight),
          FlightInfoCard(isLight: isLight),
        ],
      ),
    );
  }
}

class FlightInfoCard extends StatelessWidget {
  const FlightInfoCard({
    Key? key,
    required this.isLight,
  }) : super(key: key);

  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: (isLight ? const Color(0xffF5F5F5) : const Color(0xff404040)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "KHPN",
                  style: GoogleFonts.rubik(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  "assets/flight_card.png",
                  height: 25.h,
                ),
                Text(
                  "KLAS",
                  style: GoogleFonts.rubik(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text(
                  "Fri Oct 8, 2022",
                  textAlign: TextAlign.center,
                ),
                Text(""),
                Text(
                  "05:00 PM\n(EST)",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
