import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const bgColor = Colors.white;

const dateButtonLight = Color(0xffF1F1F1);

const lightSecondary = Color(0xfff5f5f5);

const lightSecondaryDarker = Color(0xffE0E0E0);

var lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: bgColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: bgColor,
    iconTheme: IconThemeData(color: Colors.black),
  ),
);

var lightText = GoogleFonts.rubik(
  color: Colors.white,
);
