import 'package:flutter/material.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    indicatorColor: Colors.white,
    primaryColor: Color(0xff1e6091),
    accentColor: Colors.white,
    scaffoldBackgroundColor: Colors.grey[300],
    colorScheme: ColorScheme.light(
      primary: Color(0xff2d77ad),
      secondary: Color(0xff94d0d2),
    ),
  );
  final darkTheme = ThemeData.dark().copyWith(
    primaryColor: Color(0xff16364e),
    indicatorColor: Colors.white,

    // accentColor: Colors.white,
    accentColorBrightness: Brightness.light,
    colorScheme: ColorScheme.dark(
      primary: Color(0xff2d77ad),
      secondary: Color(0xff94d0d2),
      surface: Color(0xff16364e),
    ),
  );
}
