import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/controllers/authentication_controller.dart';
import 'package:kanaf/res/controllers_key.dart';
import 'package:kanaf/screens/start_screen.dart';

import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthenticationController authController = Get.find(
    tag: ControllersKey.authControllerKey,
  );

  bool userResultGotten = false;
  bool durationFinished = false;

  bool? resultValue;

  @override
  void initState() {
    super.initState();

    fetchUser();

    Future.delayed(const Duration(seconds: 2), () {
      durationFinished = true;
      if (userResultGotten) {
        navigateScreens();
      }
    });
  }

  Future<void> fetchUser() async {
    await authController.getSavedToken().then((_) async {
      if (authController.userToken != null) {
        await authController.getUser().then((value) {
          resultValue = value;
          userResultGotten = true;

          if (durationFinished) {
            navigateScreens();
          }
        });
      } else {
        userResultGotten = true;
      }
    });
  }

  void navigateScreens() {
    if (resultValue ?? false) {
      Get.off(const MainScreen());
    } else {
      Get.off(const StartScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "اپلیکیشن کناف کار",
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
