import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/controllers/authentication_controller.dart';
import 'package:kanaf/controllers/size_controller.dart';
import 'package:kanaf/global_configs.dart';
import 'package:kanaf/res/controllers_key.dart';
import 'package:kanaf/screens/home_screen.dart';
import 'package:kanaf/widgets/custom_text_field.dart';
import 'package:kanaf/widgets/login_button.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../res/app_strings.dart';
import '../main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  TextEditingController controller = TextEditingController();

  AuthenticationController authController = Get.find(
    tag: ControllersKey.authControllerKey,
  );

  Future<void> login() async{
    setState(() {
      isLoading = true;
    });

    if(controller.text.isEmpty){
      //FIXME : ask this for its error type
      return;
    }

    bool result = await authController.login(controller.text.toEnglishDigit());
    result = await authController.verifyOtp(controller.text.toEnglishDigit(), "1111");

    if(result){
      Get.offAll(()=> const MainScreen());
    }
    else{
      //FIXME : ask this
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
                Image.asset("assets/images/start_screen/person.png", width: 115,height: 335,),
                const SizedBox(height: 16,),
                Text(AppStrings.welcomeText,
                  style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                  ),),
                const SizedBox(height: 18,),
                CustomTextField(
                  onChanged: (value){
                    controller.text = value.toPersianDigit();
                  },
                  hintText: "شماره همراه",
                  controller: controller,
                ),
                const SizedBox(height: 25,),
                LoginButton(
                  isLoading : isLoading,
                  onTap: (){
                    Get.offAll(const MainScreen());
                  },
                  // onTap: login,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
