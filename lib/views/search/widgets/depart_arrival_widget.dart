import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/common.dart';

class DepartArrivalWidget extends StatelessWidget {
  const DepartArrivalWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: accentColor,
      width: double.infinity,
      height: 119.h,
      child: Row(children: [
        Expanded(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Departure Airport",
                style: GoogleFonts.rubik(
                  color: Colors.white,
                ),
              ),
              Text(
                "KHPN",
                style: GoogleFonts.rubik(
                  fontSize: 32.sp,
                  color: Colors.white,
                ),
              ),
              Text("Weshchester County \nAirport",
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.rubik(color: Colors.white.withOpacity(0.7)))
            ],
          ),
        )),
        Container(
          width: 2,
          height: 119.h,
          color: Colors.white.withOpacity(0.2),
        ),
        Expanded(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Arrival Airport",
                style: GoogleFonts.rubik(
                  color: Colors.white,
                ),
              ),
              Text(
                "KLAS",
                style: GoogleFonts.rubik(
                  fontSize: 32.sp,
                  color: Colors.white,
                ),
              ),
              Text(
                "Weshchester County \nAirport",
                textAlign: TextAlign.center,
                style: GoogleFonts.rubik(
                  color: Colors.white.withOpacity(0.7),
                ),
              )
            ],
          ),
        )),
      ]),
    );
  }
}
