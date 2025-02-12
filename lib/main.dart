import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/controllers/master_controller.dart';
import 'package:kanaf/controllers/post_controller.dart';

import '/controllers/authentication_controller.dart';
import '/controllers/project_controller.dart';
import '/res/controllers_key.dart';
import '/screens/start_screen.dart';
import '/res/color_scheme.dart';
import '/res/input_decoration_theme.dart';
import 'res/text_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthenticationController authController = Get.put(
    AuthenticationController(),
    tag: ControllersKey.authControllerKey
  );

  MasterController masterController = Get.put(
    MasterController(),
    tag: ControllersKey.masterControllerKey,
  );

  ProjectController projectController = Get.put(
    ProjectController(),
    tag: ControllersKey.projectControllerKey,
  );

  PostController postController = Get.put(
    PostController(),
    tag: ControllersKey.postControllerKey,
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kanaf',
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
        fontFamily: "YekanBakh",
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
        fontFamily: "YekanBakh",
      ),
      locale: const Locale("fa"),
      home: const StartScreen(),
    );
  }
}