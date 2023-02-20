import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// color
const kColorGrey = Color(0xffD9D8D8);
const kColorIconGrey = Color(0xffD6CCC6);
const kColorSoftGrey = Color(0xff707070);
const kColorOrange = Color(0xffFE8235);
const kColorBrown = Color(0xff573926);
const kColor2x1 = Color(0xffF4F3F1);

// text style
final TextStyle kHeading5 =
    GoogleFonts.epilogue(fontSize: 25, fontWeight: FontWeight.w400);
final TextStyle kHeading5Bold = GoogleFonts.epilogue(
    fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 0.15);
final TextStyle kTitle = GoogleFonts.epilogue(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.15,
    color: kColorBrown);
final TextStyle kSubtitle = GoogleFonts.epilogue(
    fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15);
final TextStyle kBodyText = GoogleFonts.epilogue(
    fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.25);
final TextStyle kBodyTextRubik = GoogleFonts.rubik(
    fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.25);
final TextStyle kButton = GoogleFonts.epilogue(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.25,
    color: kColorOrange);

// text theme
final kTextTheme = TextTheme(
  headline5: kHeading5,
  headline6: kHeading5Bold,
  subtitle1: kSubtitle,
  bodyText2: kBodyText,
);

// const kColorScheme = ColorScheme(
//   primary: kMikadoYellow,
//   primaryContainer: kMikadoYellow,
//   secondary: kPrussianBlue,
//   secondaryContainer: kPrussianBlue,
//   surface: kRichBlack,
//   background: kRichBlack,
//   error: Colors.red,
//   onPrimary: kRichBlack,
//   onSecondary: Colors.white,
//   onSurface: Colors.white,
//   onBackground: Colors.white,
//   onError: Colors.white,
//   brightness: Brightness.dark,
// );
