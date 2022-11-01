import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/theme/common.dart';

class SocialButton extends StatelessWidget {
  const SocialButton(
      {Key? key,
      this.onpressed,
      this.text,
      this.color,
      this.textColor,
      this.icon})
      : super(key: key);
  final Function? onpressed;
  final String? text;
  final Color? color;
  final Color? textColor;
  final String? icon;
  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 294.w,
      height: 56.h,
      child: MaterialButton(
        onPressed: onpressed as void Function()?,
        color: color,
        textColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 2,
                child: Image.asset(
                  icon!,
                  height: 23.h,
                )),
            Expanded(
              flex: 5,
              child: Text(
                text!,
                style: GoogleFonts.rubik(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
