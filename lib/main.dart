import 'package:flutter/material.dart';
import 'package:kanaf/screens/first_screen.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: lightColorScheme,
        inputDecorationTheme: lightInputDecorationTheme,
        textTheme: textTheme,
        dividerColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        inputDecorationTheme: darkInputDecorationTheme,
        textTheme: textTheme,
        dividerColor: Colors.transparent,
        hoverColor: Colors.transparent,
        iconTheme: const IconThemeData(
          size: 20
        ),
        fontFamily: "IranSans"
      ),
      home: const FirstScreen(),
    );
  }
}
