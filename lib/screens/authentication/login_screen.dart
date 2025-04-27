import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/widgets/error_snack_bar.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '/widgets/step_widget.dart';
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
    if (textController.text.isEmpty) {
      showSnackbarMessage(
        context: context,
        message: "شماره همراه خود را وارد کنید",
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

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
      showSnackbarMessage(
          context: context, message: authController.apiMessage ?? '');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: SizedBox(
        width: SizeController.width(context),
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/start_screen/construction_ruler_pencil.png",
                width: SizeController.width(context),
                height: 490,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              const StepWidget(
                selectedIndex: 1,
                length: 3,
                isReverse: true,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: globalPadding * 12,
                child: Text(
                  AppStrings.welcomeText,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: globalPadding * 12,
                child: CustomTextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    textController.text = value.toPersianDigit();
                  },
                  // scrollPadding: const EdgeInsets.only(bottom: 70),
                  hintText: "شماره همراه",
                  controller: textController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: globalPadding * 12,
                child: LoginButton(
                  isLoading: isLoading,
                  onTap: () async {
                    await login();
                  },
                  buttonText: "وارد شوید",
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
