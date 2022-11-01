import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/theme/common.dart';

class AdSection extends StatelessWidget {
  const AdSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 121.h,
      width: 340.w,
      margin: EdgeInsets.only(top: 10.h, left: 25.w, right: 25.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: accentColor,
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Center(
        child: Text(
          "AD SECTION",
          style: GoogleFonts.rubik(
            fontSize: 50,
            color: accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
