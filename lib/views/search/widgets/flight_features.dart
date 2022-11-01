import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/common.dart';
import '../../../theme/light.dart';

class FlightFeaturesWidget extends StatelessWidget {
  const FlightFeaturesWidget({
    Key? key,
    required this.isLight,
    this.text,
    this.value,
  }) : super(key: key);

  final bool? isLight, value;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(8.w),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
            color: isLight! ? lightSecondary : Colors.black,
            borderRadius: BorderRadius.circular(10)),
        height: 50.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text!,
              style: GoogleFonts.rubik(
                fontWeight: FontWeight.bold,
              ),
            ),
            CupertinoSwitch(
              value: value!,
              onChanged: (val) {},
              activeColor: accentColor,
            )
          ],
        ));
  }
}
