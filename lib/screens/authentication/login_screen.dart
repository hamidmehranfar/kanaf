import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kanaf/controllers/size_controller.dart';
import 'package:kanaf/global_configs.dart';
import 'package:kanaf/widgets/authentication_bottom_sheet.dart';
import 'package:kanaf/widgets/custom_text_field.dart';

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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Iconsax.arrow_right_1),
        ),
      ),
      bottomSheet: AuthenticationBottomSheet(
        isLoading: isLoading,
        onTap: (){
          setState(() {
            isLoading = true;
          });
        },
      ),
      body: Container(
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
            CustomTextField(labelText: "شماره موبایل",enabled: !isLoading,),
            const SizedBox(height: 16,),
            CustomTextField(labelText: "رمز عبور",enabled: !isLoading,),
            TextButton(
              onPressed: (){

              },
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text("رمز عبور خود را فراموش کرده اید؟",
                style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16,)
          ],
        ),
      ),
    );
  }
}
