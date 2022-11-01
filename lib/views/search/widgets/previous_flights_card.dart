import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/core/locator.dart';
import 'package:set_jet/core/router_constants.dart';
import 'package:set_jet/theme/light.dart';
import 'package:stacked_services/stacked_services.dart';

class PreviousFlightSearches extends StatelessWidget {
  const PreviousFlightSearches({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;

    return GestureDetector(
      onTap: () {
        locator<NavigationService>().navigateTo(searchResultsViewRoute);
      },
      child: Container(
        margin: EdgeInsets.only(top: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isLight ? lightSecondary : Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
                child: Text(
              "KHPN",
              style: GoogleFonts.rubik(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
            )),
            Expanded(
                child: Text(
              "Weshchester County Airport",
              style: GoogleFonts.rubik(
                  color: isLight
                      ? const Color(0x66242424)
                      : const Color(0x66ffffff)),
            ))
          ],
        ),
      ),
    );
  }
}
