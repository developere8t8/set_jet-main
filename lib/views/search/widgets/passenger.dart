import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/theme/common.dart';

import '../../../theme/light.dart';

class PassengerWidget extends StatelessWidget {
  const PassengerWidget({
    Key? key,
    required this.isLight,
  }) : super(key: key);

  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
          color: isLight ? lightSecondary : Colors.black, borderRadius: BorderRadius.circular(10)),
      height: 82.h,
      child: Row(children: [
        Container(
          child: IconButton(onPressed: () {}, icon: Icon(Icons.remove)),
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.only(top: 8.h),
          child: Column(
            children: [
              Text(
                "Passengers",
                style: GoogleFonts.rubik(color: accentColor),
              ),
              const Expanded(
                child: FittedBox(fit: BoxFit.fitHeight, child: const Text("3")),
              ),
            ],
          ),
        )),
        Container(
          child: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
        )
      ]),
    );
  }
}
