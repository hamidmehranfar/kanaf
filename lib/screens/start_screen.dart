import 'package:flutter/material.dart';
import 'package:kanaf/widgets/step_widget.dart';

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
      body: SizedBox(
        width: SizeController.width(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/start_screen/construction_ruler_pencil.png",
              fit: BoxFit.cover,
              height: 480,
              width: SizeController.width(context),
            ),
            const SizedBox(height: 10),
            const StepWidget(
              selectedIndex: 0,
              length: 3,
              isReverse: true,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: globalPadding * 5,
              child: Text(
                AppStrings.welcomeText,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: globalPadding * 5,
              child: Text(
                AppStrings.appText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: globalPadding * 5,
              child: Text(
                "لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است، چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است، و برای شرایط فعلی تکنولوژی ",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSecondary.withOpacity(0.5),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: globalPadding * 5,
              child: const StartScreenButton(),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}
