import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '/controllers/authentication_controller.dart';
import '/res/controllers_key.dart';
import '../main_screen.dart';
import '/res/enums/introduction_type.dart';
import '/controllers/size_controller.dart';
import '/global_configs.dart';
import '/widgets/authentication_bottom_sheet.dart';
import '/widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  final String username;
  const SignupScreen({super.key, required this.username});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isLoading = false;

  List<String> introductionTypes = [
    'نحوه ی آشنایی(اختیاری)',
    convertIntroductionToString(IntroductionType.fromKanafApp),
    convertIntroductionToString(IntroductionType.fromSMS),
    convertIntroductionToString(IntroductionType.fromFriends),
    convertIntroductionToString(IntroductionType.fromGoogle),
    convertIntroductionToString(IntroductionType.others),
  ];

  String selectedValue = '';

  AuthenticationController authController = Get.find(
    tag: ControllersKey.authControllerKey,
  );

  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController jobTextController = TextEditingController();

  Future<void> signup() async {
    if(firstNameTextController.text.isEmpty || lastNameTextController.text.isEmpty){
      //FIXME : show error
      // message = "لطفا نام خود را وارد کنید";
    }
    setState(() {
      isLoading = true;
    });

    String? response = await authController.verifyOtp(
      isSignUp: true,
      username: widget.username.toEnglishDigit(),
      otp: "1111",
      firstName: firstNameTextController.text,
      lastName: lastNameTextController.text,
      email: emailTextController.text,
      job: jobTextController.text,
      type: convertToIntroductionType(selectedValue)
    );

    if(response!=null){
      bool result = await authController.getUser(response);
      if(result){
        Get.offAll(const MainScreen());
      }
      else{
        //FIXME : show error
      }
    }
  }

  @override
  void initState() {
    super.initState();
    selectedValue = introductionTypes[0];
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: SizeController.width(context),
          height: SizeController.height(context),
          padding: globalPadding * 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 140,),
              CustomTextField(
                labelText: "نام",
                enabled: !isLoading,
                controller: firstNameTextController,
              ),
              const SizedBox(height: 16,),
              CustomTextField(
                labelText: "نام خانوادگی",
                enabled: !isLoading,
                controller: lastNameTextController,
              ),
              const SizedBox(height: 16,),
              CustomTextField(
                labelText: "ایمیل (اختیاری)",
                enabled: !isLoading,
                controller: emailTextController,
              ),
              const SizedBox(height: 16,),
              CustomTextField(
                labelText: "شغل (اختیاری)",
                enabled: !isLoading,
                controller: jobTextController,
              ),
              const SizedBox(height: 16,),
              Container(
                height: 52,
                padding: globalPadding * 3,
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.21),
                  borderRadius: globalBorderRadius * 4,
                  border: Border.all(),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedValue,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue ?? '';
                      });
                    },
                    items: introductionTypes
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSecondary.withValues(
                                alpha: 0.9
                            ),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24,),
              AuthenticationBottomSheet(
                onTap: () async {
                  await signup();
                },
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
