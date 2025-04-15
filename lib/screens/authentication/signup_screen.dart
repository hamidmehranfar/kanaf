import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '/widgets/choose_profile_image.dart';
import '/res/app_colors.dart';
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

  String? avatarImage;
  int? defaultIndex;

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
    if (firstNameTextController.text.isEmpty ||
        lastNameTextController.text.isEmpty) {
      //FIXME : show error
      // message = "لطفا نام خود را وارد کنید";
    }
    setState(() {
      isLoading = true;
    });

    bool response = await authController.verifyOtp(
      isSignUp: true,
      username: widget.username.toEnglishDigit(),
      otp: "1111",
      firstName: firstNameTextController.text,
      lastName: lastNameTextController.text,
      email: emailTextController.text,
      job: jobTextController.text,
      type: convertToIntroductionType(selectedValue),
      selectedAvatar: defaultIndex,
      avatar: avatarImage,
    );

    if (response) {
      bool result = await authController.getUser();
      if (result) {
        Get.offAll(const MainScreen());
      } else {
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
        child: SizedBox(
          width: SizeController.width(context),
          height: SizeController.height(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Padding(
                padding: globalPadding * 4,
                child: CustomTextField(
                  labelText: "نام",
                  enabled: !isLoading,
                  controller: firstNameTextController,
                  scrollPadding: const EdgeInsets.only(bottom: 450),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: globalPadding * 4,
                child: CustomTextField(
                  labelText: "نام خانوادگی",
                  enabled: !isLoading,
                  controller: lastNameTextController,
                  scrollPadding: const EdgeInsets.only(bottom: 400),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: globalPadding * 4,
                child: CustomTextField(
                  labelText: "ایمیل (اختیاری)",
                  enabled: !isLoading,
                  controller: emailTextController,
                  scrollPadding: const EdgeInsets.only(bottom: 350),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: globalPadding * 4,
                child: CustomTextField(
                  labelText: "شغل (اختیاری)",
                  enabled: !isLoading,
                  controller: jobTextController,
                  scrollPadding: const EdgeInsets.only(bottom: 280),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 52,
                padding: globalPadding * 3,
                margin: globalPadding * 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.21),
                  borderRadius: globalBorderRadius * 3,
                  border: Border.all(),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedValue,
                    dropdownColor: AppColors.sideColor,
                    isExpanded: true,
                    borderRadius: globalBorderRadius * 3,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black87,
                    ),
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
                            color: theme.colorScheme.onSecondary
                                .withValues(alpha: 0.9),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: theme.colorScheme.primary,
                        child: const ChooseProfileImage(),
                      );
                    },
                  ).then((value) {
                    if (value is String) {
                      setState(() {
                        avatarImage = value;
                        defaultIndex = null;
                      });
                    } else if (value is int) {
                      setState(() {
                        avatarImage =
                            "assets/images/default_avatar_$value.jpeg";
                        defaultIndex = value;
                      });
                    }
                  });
                },
                child: Container(
                  height: 52,
                  margin: globalPadding * 4,
                  padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiary.withValues(alpha: 0.21),
                    border: Border.all(),
                    borderRadius: globalBorderRadius * 3,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      avatarImage == null
                          ? Text(
                              'عکس پروفایل',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSecondary
                                    .withValues(alpha: 0.9),
                              ),
                              overflow: TextOverflow.fade,
                            )
                          : SizedBox(
                              width: 40,
                              height: 40,
                              child: ClipOval(
                                child: defaultIndex != null
                                    ? Image.asset(
                                        avatarImage!,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(avatarImage!),
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                      Row(
                        children: [
                          Text(
                            "انتخاب",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSecondary
                                  .withValues(alpha: 0.9),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward,
                            size: 14,
                            color: theme.colorScheme.onSecondary
                                .withValues(alpha: 0.9),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: globalPadding * 4,
                child: AuthenticationBottomSheet(
                  onTap: () async {
                    await signup();
                  },
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
