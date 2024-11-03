import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:kanaf/controllers/size_controller.dart';
import 'package:kanaf/global_configs.dart';

class StartScreenButton extends StatelessWidget {
  const StartScreenButton({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: (){},
      child: Container(
        padding: globalPadding * 4,
        height: 52,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow,
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 4),
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
            Text("Let's Start", style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSecondary
            ),)
          ],
        ),
      ),
    );
      FilledButton(
      onPressed: (){},
      style: FilledButton.styleFrom(
        backgroundColor: theme.colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: globalBorderRadius * 3,
        ),
        fixedSize: const Size.fromHeight(52,),
        padding: globalPadding * 4,
        elevation: 8,

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
          Text("Let's Start", style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onSecondary
          ),)
        ],
      ),
    );
  }
}
