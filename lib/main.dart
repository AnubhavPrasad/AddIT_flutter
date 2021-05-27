import 'package:add_it/theme/ThemeService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:add_it/theme/themes.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/HomeScreen.dart';

void main() async {
  await GetStorage.init();
  runApp(
    GetMaterialApp(
      theme: Themes().lightTheme,
      darkTheme: Themes().darkTheme,
      themeMode: ThemeService().getThemeMode(),
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
