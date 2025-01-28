import 'package:flutter/material.dart';

import '/controllers/size_controller.dart';
import '/global_configs.dart';
import '/res/app_strings.dart';
import '/widgets/start_screen_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Container(
        width: SizeController.width(context),
        padding: globalPadding * 5,
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
            const SizedBox(height: 16,),
            Text(AppStrings.appText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),),
            const SizedBox(height: 6,),
            Text("لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است، چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است، و برای شرایط فعلی تکنولوژی ",
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSecondary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 40,),
            const StartScreenButton()
          ],
        ),
      ),
    );
  }
}
