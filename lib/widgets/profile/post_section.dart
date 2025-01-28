import 'package:flutter/material.dart';

import '/global_configs.dart';
import '/res/app_colors.dart';
import '../small_button.dart';

class PostSection extends StatefulWidget {
  const PostSection({super.key});

  @override
  State<PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<PostSection> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 30),
        SizedBox(
          height: 335,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 1,
              mainAxisExtent: 110,
            ),
            itemBuilder: (context, index){
              return Stack(
                children: [
                  Container(
                    width: 150,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: globalBorderRadius * 10,
                      color: theme.colorScheme.secondary.withValues(alpha: 0.4),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 10,
                    child: Container(
                      width: 27,
                      height: 27,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.onPrimary
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.secondary,
                        ),
                        child: const Icon(Icons.add, size: 14,),
                      ),
                    )
                  )
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 18,),
        SmallButton(
          text: "آپلود عکس یا ویدئو",
          textColor: theme.colorScheme.onSecondary,
          width: 142,
          height: 27,
          shadow: [
            BoxShadow(
              color: theme.colorScheme.onPrimary,
              offset: const Offset(-20, -10),
              blurRadius: 25,
              spreadRadius: -10,
            ),
            BoxShadow(
              color: theme.colorScheme.onSecondary,
              offset: const Offset(20, 10),
              blurRadius: 20,
              spreadRadius: -5,
            ),
          ],
          onTap: (){

          },
        ),
        const SizedBox(height: 25),
        Container(
          height: 51,
          padding: const EdgeInsets.only(bottom: 5),
          margin: globalPadding * 3,
          decoration: BoxDecoration(
            color: AppColors.textFieldColor.withValues(alpha: 0.78),
            borderRadius: globalBorderRadius * 4,
          ),
          child: Row(
            children: [
              const SizedBox(width: 15,),
              Expanded(
                  child: TextField(
                    style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.surface
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: "کپشن",
                        hintStyle: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onPrimary.withValues(alpha: 0.38)
                        )
                    ),
                  )
              ),
              const SizedBox(width: 8,)
            ],
          ),
        ),
        const SizedBox(height: 32)
      ],
    );
  }
}
