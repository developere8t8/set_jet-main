import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EstimatedTimeWidget extends StatelessWidget {
  const EstimatedTimeWidget({
    Key? key,
    required this.isLight,
  }) : super(key: key);

  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      // padding: EdgeInsets.symmetric(horizontal: 25.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isLight ? const Color(0xffF1F1F1) : Colors.black,
        image: DecorationImage(
          image: AssetImage(
            "assets/${isLight ? "Subtract_light" : "Subtract"}.png",
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Estimated Time",
            style: GoogleFonts.rubik(
                color:
                    isLight ? const Color(0x66242424) : const Color(0x66FFFFFF),
                fontSize: 18.sp),
          ),
          SizedBox(
            height: 10.h,
          ),
          const Text("3 hours 43 minutes")
        ],
      ),
    );
  }
}
