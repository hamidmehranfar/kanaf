import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kanaf/screens/authentication/signup_screen.dart';
import 'package:kanaf/screens/home_screen.dart';
import 'package:kanaf/screens/authentication/login_screen.dart';
import 'package:kanaf/screens/main_screen.dart';
import 'package:kanaf/screens/test.dart';
import '/res/color_scheme.dart';
import '/res/input_decoration_theme.dart';

import 'res/text_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: lightColorScheme,
        inputDecorationTheme: lightInputDecorationTheme,
        textTheme: textTheme,
        dividerColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        iconTheme: const IconThemeData(
            size: 20
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        inputDecorationTheme: darkInputDecorationTheme,
        textTheme: textTheme,
        dividerColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        iconTheme: const IconThemeData(
          size: 20
        ),
        fontFamily: "IranSans",
      ),
      locale: const Locale("fa"),
      home: const LoginScreen(),
    );
  }
}
