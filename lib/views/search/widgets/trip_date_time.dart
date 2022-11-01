import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/common.dart';
import '../../../theme/dark.dart';
import '../../../theme/light.dart';

class TripDateTimeWidget extends StatelessWidget {
  const TripDateTimeWidget({
    Key? key,
    required this.isLight,
  }) : super(key: key);

  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
          color: isLight ? lightSecondary : Colors.black,
          borderRadius: BorderRadius.circular(10)),
      height: 100.h,
      child: Row(children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Trip Date",
              style: GoogleFonts.rubik(
                color: accentColor,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "Fri Oct 8, 2022",
              style: GoogleFonts.rubik(
                fontSize: 18.sp,
              ),
            ),
          ],
        )),
        Container(
          width: 0.5.h,
          color: Colors.grey,
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Departure Time",
              style: GoogleFonts.rubik(color: accentColor, fontSize: 18.sp),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "05:00 PM",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(5),
                        color:
                            isLight ? const Color(0x4d0982F4) : darkSecondary),
                    child: Text(
                      "EST",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(
                        fontSize: 18.sp,
                      ),
                    ))
              ],
            ),
          ],
        )),
      ]),
    );
  }
}
