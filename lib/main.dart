import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'screens/HomeScreen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
      .copyWith(statusBarIconBrightness: Brightness.dark));

  runApp(
    GetMaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff1e6091),
        accentColor: Colors.white,
        scaffoldBackgroundColor: Colors.grey[300],
        colorScheme: ColorScheme.light(
          primary: Color(0xff2d77ad),
          secondary: Color(0xff94d0d2),
        ),
      ),
      home: MyApp(),
      title: 'AddIT',
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}
