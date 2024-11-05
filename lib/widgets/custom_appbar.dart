import 'package:flutter/material.dart';
import 'package:kanaf/global_configs.dart';
import 'package:kanaf/res/app_strings.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget{
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    
    return Container(
      height: 90,
      padding: globalPadding * 6,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25)
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.notifications,
                size: 40,color: Color(0xFFA4F7F9),),
              Text(AppStrings.kanafSlogan, style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w300
              ),),
              Image.asset("assets/images/user_ava.png", width: 44,height: 44,),
            ],
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(80);
}
