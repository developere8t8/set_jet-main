import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/common.dart';
import '../../../theme/light.dart';

class AircraftSizeWidget extends StatelessWidget {
  const AircraftSizeWidget({
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
      height: 82.h,
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Text(
            "Aircraft Size",
            style: GoogleFonts.rubik(
              color: accentColor,
            ),
          ),
          Expanded(
              child: Center(
            child: Text(
              "Super Mid Jet",
              style: GoogleFonts.rubik(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ))
        ],
      ),
    );
  }
}
