import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/widgets/step_widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '/screens/authentication/otp_screen.dart';
import '/controllers/authentication_controller.dart';
import '/controllers/size_controller.dart';
import '/global_configs.dart';
import '/res/controllers_key.dart';
import '/screens/authentication/signup_screen.dart';
import '/widgets/custom_text_field.dart';
import '/widgets/login_button.dart';
import '/res/app_strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  AuthenticationController authController = Get.find(
    tag: ControllersKey.authControllerKey,
  );

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    if (textController.text.isEmpty) {
      // FIXME : ask this for its error type
      return;
    }

    var result =
        await authController.login(textController.text.toEnglishDigit());
    if (result.$2) {
      if (result.$1) {
        Get.to(
          OtpScreen(
            username: textController.text,
          ),
        );
      } else {
        Get.to(
          SignupScreen(
            username: textController.text,
          ),
        );
      }
    } else {
      Get.showSnackbar(
        GetSnackBar(
          title: 'خطا',
          message: authController.apiMessage != null
              ? authController.apiMessage!.isEmpty
                  ? 'خطایی رخ داده است'
                  : authController.apiMessage
              : 'خطایی رخ داده است',
          duration: const Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: globalPadding * 12,
        child: SizedBox(
          width: SizeController.width(context),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 140),
                Image.asset(
                  "assets/images/start_screen/person.png",
                  width: 115,
                  height: 335,
                ),
                const SizedBox(height: 10),
                const StepWidget(
                  selectedIndex: 1,
                  length: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.welcomeText,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 18),
                CustomTextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    textController.text = value.toPersianDigit();
                  },
                  scrollPadding: const EdgeInsets.only(bottom: 100),
                  hintText: "شماره همراه",
                  controller: textController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                LoginButton(
                  isLoading: isLoading,
                  onTap: () async {
                    await login();
                  },
                  buttonText: "وارد شوید",
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
