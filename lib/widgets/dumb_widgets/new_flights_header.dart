import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/model/usermodel.dart';
import 'package:set_jet/views/search/search_view.dart';
import 'package:set_jet/views/search_results/search_results_view.dart';
import 'package:set_jet/widgets/dumb_widgets/saerchcharter.dart';

class NewFlightsHeader extends StatefulWidget {
  final UserData data;
  const NewFlightsHeader({Key? key, required this.data}) : super(key: key);

  @override
  State<NewFlightsHeader> createState() => _NewFlightsHeaderState();
}

class _NewFlightsHeaderState extends State<NewFlightsHeader> {
  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SearchResultsView(data: widget.data)));
      },
      child: Container(
        height: 90.h,
        margin: EdgeInsets.symmetric(
          vertical: 35.h,
          horizontal: 25.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: (isLight ? const Color(0xffF5F5F5) : const Color(0xff404040)),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 24.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Search New\nFlights",
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Positioned(
              height: 86.h,
              right: 10.w,
              top: -10.h,
              child: Image.asset("assets/new_flights.png"),
            )
          ],
        ),
      ),
    );
  }
}
