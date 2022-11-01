import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({Key? key, this.Onchange, this.label, this.obscureText, this.controller})
      : super(key: key);
  final Onchange;
  final label;
  final obscureText;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 331.w,
      height: 56.h,
      child: TextField(
        obscureText: obscureText == null ? false : obscureText,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            filled: true,
            hintStyle: GoogleFonts.rubik(color: Colors.grey[800]),
            labelText: label,
            fillColor: Colors.transparent),
        onChanged: Onchange,
        controller: controller,
      ),
    );
  }
}
