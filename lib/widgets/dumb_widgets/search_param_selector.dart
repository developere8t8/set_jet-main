import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/light.dart';

class SearchParamWidget extends StatelessWidget {
  const SearchParamWidget({Key? key, this.icon, this.text}) : super(key: key);

  final IconData? icon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            // SizedBox(
            //   height: 10.h,
            // ),
            Expanded(
              child: Text(
                text!,
                style: lightText.copyWith(fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
