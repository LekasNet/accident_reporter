import 'package:accident_reporter/commons/constants.dart';
import 'package:accident_reporter/domains/requests/getVehicles.dart';
import 'package:accident_reporter/pages/MainPage.dart';
import 'package:accident_reporter/pages/SignPage.dart';
import 'package:flutter/material.dart';
import 'package:window_rounded_corners/window_rounded_corners.dart';

import 'commons/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    fetchVehicles();
     // Вызов функции загрузки данных о транспортных средствах
  }

  @override
  Widget build(BuildContext context) {
    WindowCorners.init();
    setCorners();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: AppTheme.themeMode,
      theme: AppTheme.theme,
      home: SafeArea(
        bottom: false,
        child: LoginSignupPage(),
      ),
    );
  }
}


