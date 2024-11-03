import 'package:flutter/material.dart';
import 'package:kanaf/global_configs.dart';
import 'package:kanaf/res/app_strings.dart';
import 'package:kanaf/widgets/start_screen_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: globalPadding * 5,
        child: Column(
          children: [
            const SizedBox(height: 510),
            Text("به کناف‌کار خوش اومدی!!",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface
              ),),
            const SizedBox(height: 16,),
            Text(AppStrings.appText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline
              ),),
            const SizedBox(height: 6,),
            Text("لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است، چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است، و برای شرایط فعلی تکنولوژی ",
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSecondary.withOpacity(0.5)
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
