import 'package:flutter/material.dart';
import 'package:kanaf/res/color_scheme.dart';

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
        dividerColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      home: const Scaffold(),
    );
  }
}
