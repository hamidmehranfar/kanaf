import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/controllers/size_controller.dart';
import 'package:kanaf/global_configs.dart';
import 'package:kanaf/widgets/custom_text_field.dart';
import 'package:kanaf/widgets/login_button.dart';

import '../../res/app_strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: globalPadding * 12,
        child: SizedBox(
          width: SizeController.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 140),
                Image.asset("assets/images/start_screen/person.png", width: 115,height: 335,),
                const SizedBox(height: 16,),
                Text(AppStrings.welcomeText,
                  style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontFamily: "LexendDeca"
                  ),),
                const SizedBox(height: 18,),
                const CustomTextField(hintText: "شماره همراه",),
                const SizedBox(height: 25,),
                const LoginButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
