import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/theme/common.dart';

class MessageTimeDivider extends StatelessWidget {
  const MessageTimeDivider({
    Key? key,
    this.time,
  }) : super(key: key);
  final time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 2.h,
            color: accentColor,
          ),
          Container(
            width: 127.w,
            height: 30.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: accentColor,
            ),
            child: Center(
              child: Text(
                time,
                style: GoogleFonts.rubik(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}