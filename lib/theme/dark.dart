import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const bgColorDark = Color(0xff242424);

const darkSecondary = Color(0xff404040);

const dateButtonDark = Color(0xff000000);
var darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: bgColorDark,
  appBarTheme: const AppBarTheme(
    backgroundColor: bgColorDark,
    iconTheme: IconThemeData(color: Colors.white),
  ),
);

var darkText = GoogleFonts.rubik(
  color: Colors.black,
);

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// const bgColor = Color(0xff242424);

// const darkSecondary = Color(0xff404040);

// const dateButtonDark = Color(0xff000000);
// var darkTheme = ThemeData.dark().copyWith(
//   scaffoldBackgroundColor: bgColor,
//   appBarTheme: const AppBarTheme(
//     backgroundColor: bgColor,
//     iconTheme: IconThemeData(color: Colors.white),
//   ),
// );

// var darkText = GoogleFonts.rubik(
//   color: Colors.black,
// );
