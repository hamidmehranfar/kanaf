import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/widgets/error_snack_bar.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '/widgets/step_widget.dart';
import '/controllers/authentication_controller.dart';
import '/controllers/size_controller.dart';
import '/global_configs.dart';
import '/res/controllers_key.dart';
import '/widgets/custom_text_field.dart';
import '/widgets/login_button.dart';
import '/res/app_strings.dart';
import '../main_screen.dart';

class OtpScreen extends StatefulWidget {
  final String username;

  const OtpScreen({super.key, required this.username});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool isLoading = false;

  AuthenticationController authController = Get.find(
    tag: ControllersKey.authControllerKey,
  );

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> otpVerification() async {
    setState(() {
      isLoading = true;
    });

    bool response = await authController.verifyOtp(
      isSignUp: false,
      username: widget.username.toEnglishDigit(),
      otp: "1111",
    );

    if (response) {
      bool result = await authController.getUser();
      if (result) {
        Get.offAll(const MainScreen());
      } else {
        showSnackbarMessage(
            context: context, message: authController.apiMessage ?? '');
      }
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
                selectedIndex: 2,
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
                  onChanged: (value) {
                    textController.text = value.toPersianDigit();
                  },
                  hintText: "کد تأیید",
                  // scrollPadding: const EdgeInsets.only(bottom: 100),
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
                    await otpVerification();
                  },
                  buttonText: "ارسال کد",
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
