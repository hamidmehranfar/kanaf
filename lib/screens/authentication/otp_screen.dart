import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../widgets/step_widget.dart';
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

    // String? response = await authController.verifyOtp(
    //   widget.username, textController.text,
    // );

    String? response = await authController.verifyOtp(
      isSignUp: false,
      username: widget.username.toEnglishDigit(),
      otp: "1111",
    );

    if (response != null) {
      bool result = await authController.getUser(response);
      if (result) {
        Get.offAll(const MainScreen());
      } else {
        //FIXME : show error
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
                  selectedIndex: 2,
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
                  onChanged: (value) {
                    textController.text = value.toPersianDigit();
                  },
                  hintText: "کد تأیید",
                  scrollPadding: const EdgeInsets.only(bottom: 100),
                  controller: textController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                LoginButton(
                  isLoading: isLoading,
                  onTap: () async {
                    await otpVerification();
                  },
                  buttonText: "ارسال کد",
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
