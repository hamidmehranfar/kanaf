import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../controllers/size_controller.dart';
import '../../global_configs.dart';
import '../../widgets/authentication_bottom_sheet.dart';
import '../../widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Iconsax.arrow_right_1),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: SizeController.width,
          height: SizeController.height,
          padding: globalPadding * 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32,),
              Text("ورود به حساب کاربری",
                style: theme.textTheme.titleLarge,),
              const SizedBox(height: 8,),
              Text("شماره موبایل و رمز عبورتان را وارد کنید .",
                style: theme.textTheme.titleMedium,),
              const SizedBox(height: 48,),
              CustomTextField(labelText: "نام",enabled: !isLoading,),
              const SizedBox(height: 16,),
              CustomTextField(labelText: "نام خانوادگی",enabled: !isLoading,),
              const SizedBox(height: 16,),
              CustomTextField(labelText: "شماره تماس",enabled: !isLoading,),
              const SizedBox(height: 16,),
              CustomTextField(labelText: "ایمیل",enabled: !isLoading,),
              const SizedBox(height: 24,),
              AuthenticationBottomSheet(
                onTap: (){

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
