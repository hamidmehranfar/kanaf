import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:kanaf/controllers/size_controller.dart';
import 'package:kanaf/global_configs.dart';
import 'package:kanaf/screens/authentication/login_screen.dart';

class StartScreenButton extends StatelessWidget {
  const StartScreenButton({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: (){
        Get.to(const LoginScreen());
      },
      child: Container(
        padding: globalPadding * 4,
        height: 52,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.3),
              blurRadius: 40,
              offset: const Offset(0, 10),
            ),
          ],
          borderRadius: globalBorderRadius * 3
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: SizeController.width!/3.5,
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(IconlyBold.arrow_right,
                  color: theme.colorScheme.onSecondary,size: 24,),
              ),
            ),
            Text("Let's Start", style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSecondary,
                fontFamily: "LexendDeca"
            ),)
          ],
        ),
      ),
    );
  }
}
