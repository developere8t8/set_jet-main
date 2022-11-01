import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/common.dart';
import '../../../theme/dark.dart';
import '../../../theme/light.dart';

class TripTypeSelector extends StatelessWidget {
  const TripTypeSelector({
    Key? key,
    required this.isLight,
    this.index,
    this.onOneway,
    this.onRoundTrip,
    this.onMultiLeg,
  }) : super(key: key);

  final bool isLight;
  final int? index;
  final Function? onOneway, onRoundTrip, onMultiLeg;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: isLight ? lightSecondary : darkSecondary,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onOneway as void Function()?,
              child: Container(
                  height: 100.h,
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: index == 0 ? accentColor : null,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          "assets/icons/oneway${index == 0 ? "_selected" : isLight ? "_light" : ""}.png",
                        ),
                      ),
                      Text(
                        "One Way",
                        style: GoogleFonts.rubik(
                            color: index == 0
                                ? Colors.white
                                : const Color(0xFF707070)),
                      )
                    ],
                  )),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onRoundTrip as void Function()?,
              child: Container(
                  height: 100.h,
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: index == 1 ? accentColor : null,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          "assets/icons/roundtrip${index == 1 ? "_selected" : isLight ? "_light" : ""}.png",
                        ),
                      ),
                      Text(
                        "Round Trip",
                        style: GoogleFonts.rubik(
                          color: index == 1 ? Colors.white : Color(0xFF707070),
                        ),
                      )
                    ],
                  )),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onMultiLeg as void Function()?,
              child: Container(
                  height: 100.h,
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (index == 2) ? accentColor : null,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          "assets/icons/multileg${index == 2 ? "_selected" : isLight ? "_light" : ""}.png",
                        ),
                      ),
                      Text(
                        "Multileg",
                        style: GoogleFonts.rubik(
                          color: index == 2
                              ? Colors.white
                              : const Color(0xFF707070),
                        ),
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
