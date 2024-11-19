import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/widgets/authentication_bottom_sheet.dart';

import '../../controllers/size_controller.dart';
import '../../global_configs.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
          icon: const Icon(Icons.arrow_right),
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
        width: SizeController.width(context),
        height: SizeController.height(context),
        padding: globalPadding * 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32,),
            Text("فراموشی رمز عبور",
              style: theme.textTheme.titleLarge,),
            const SizedBox(height: 8,),
            Text("شماره موبایل خود را وارد کنید .",
              style: theme.textTheme.titleMedium,),
            const SizedBox(height: 48,),
            CustomTextField(labelText: "شماره موبایل",enabled: !isLoading,),
            const SizedBox(height: 16,)
          ],
        ),
      ),
    );
  }
}
