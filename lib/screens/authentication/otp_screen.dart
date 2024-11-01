import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kanaf/controllers/size_controller.dart';
import 'package:kanaf/global_configs.dart';
import 'package:kanaf/widgets/authentication_bottom_sheet.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  String otpToken = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: SizedBox(
            width: SizeController.width,
            height: SizeController.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: globalPadding * 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      "کد را وارد کنید",
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    //pin code
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: PinCodeTextField(
                        controller: otpController,
                        appContext: context,
                        length: 6,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderWidth: 1,
                          borderRadius: globalBorderRadius * 1.5,
                          selectedColor: theme.colorScheme.primary,
                          inactiveColor: theme.colorScheme.outlineVariant,
                          fieldHeight: 56,
                          fieldWidth: 50,
                          activeColor: theme.colorScheme.primary,
                        ),
                        onChanged: (text) {
                          otpToken = otpController.text;
                        },
                        onSubmitted: (text) {

                        },
                        onCompleted: (text) {

                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    //timer
                    Row(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          textDirection: TextDirection.ltr,
                          children: [
                            Container(
                              width: 20,
                              height: 25,
                              alignment: Alignment.centerRight,
                              child: Text("2",style: theme.textTheme.bodySmall),
                            ),
                            const Text(':'),
                            Container(
                              width: 25,
                              height: 25,
                              alignment: Alignment.centerLeft,
                              child: Text("00",
                                  style: theme.textTheme.bodySmall),
                            ),
                          ],
                        ),
                        Text('ارسال مجدد',
                            style: theme.textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 16),
                    //edit phone number
                    InkWell(
                      onTap: () => Get.back(),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.message_edit,
                            size: 20,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${'تغییر شماره تماس'.tr} 09904503067',
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    //login button
                    AuthenticationBottomSheet(
                      isLoading: isLoading,
                      onTap: (){},
                    ),
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }
}
