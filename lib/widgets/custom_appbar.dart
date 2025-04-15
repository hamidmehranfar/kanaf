import 'package:flutter/material.dart';
import 'package:kanaf/global_configs.dart';
import 'package:kanaf/res/app_strings.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;
  final IconData? icon;
  final String? iconAsset;
  final bool hasShadow;

  const CustomAppbar({
    super.key,
    required this.onTap,
    this.icon,
    this.iconAsset,
    this.hasShadow = false,
  });

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
              bottomRight: Radius.circular(25)),
          boxShadow: hasShadow
              ? [
                  BoxShadow(
                    color: theme.colorScheme.onSurface,
                    blurRadius: 20,
                    spreadRadius: 20,
                  )
                ]
              : null),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/portrait.png",
                  width: 44,
                  height: 44,
                ),
              ),
              Text(
                AppStrings.kanafSlogan,
                style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w300),
              ),
              InkWell(
                onTap: onTap,
                child: icon != null
                    ? Icon(
                        icon,
                        size: 40,
                        color: theme.colorScheme.onPrimary,
                      )
                    : iconAsset != null
                        ? Image.asset(
                            iconAsset!,
                            width: 40,
                            height: 40,
                          )
                        : Container(),
              ),
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
