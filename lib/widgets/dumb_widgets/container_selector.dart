import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/theme/common.dart';

class ContainerSelector extends StatelessWidget {
  const ContainerSelector({
    Key? key,
    required this.isLight,
    this.onpressed,
    this.icon,
    this.title,
    this.subtitle,
    this.value,
  }) : super(key: key);

  final bool isLight;
  final onpressed;
  final icon;
  final title;
  final subtitle;
  final value;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onpressed,
      child: Container(
          height: 100.h,
          decoration: BoxDecoration(
            color: !isLight ? Color(0xFF3A3A3A) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 0.5.w,
              color: (!isLight)
                  ? (value)
                      ? accentColor
                      : Colors.transparent
                  : (value)
                      ? accentColor
                      : Color(0xFF919191),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0, right: 14.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 35,
                  color: (!isLight)
                      ? (value)
                          ? accentColor
                          : Colors.white
                      : (value)
                          ? accentColor
                          : Color(0xFF919191),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.rubik(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: (!isLight)
                            ? (value)
                                ? accentColor
                                : Colors.white
                            : (value)
                                ? accentColor
                                : Color(0xFF919191),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.rubik(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: (!isLight)
                            ? (value)
                                ? accentColor
                                : Colors.white
                            : (value)
                                ? accentColor
                                : Color(0xFF919191),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
