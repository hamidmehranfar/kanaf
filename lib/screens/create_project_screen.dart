import 'package:flutter/material.dart';

import '/controllers/size_controller.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/button_item.dart';
import '/global_configs.dart';
import '/res/app_colors.dart';
import '/widgets/my_divider.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppbar(
        onTap: (){
          Navigator.of(context).pop();
        },
        iconAsset: "assets/icons/arrow_back_19.png",
      ),
      body: SizedBox(
        height: SizeController.height(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              Text("ایجاد پروژه", style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w300,
                color: theme.colorScheme.tertiary
              ),),
              const SizedBox(height: 14),
              Padding(
                padding: globalPadding * 11,
                child: MyDivider(
                  color: theme.colorScheme.onSecondary,
                  height: 1,
                  thickness: 1,
                ),
              ),
              const SizedBox(height: 13),
              Container(
                margin: globalPadding * 6,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: globalBorderRadius * 6,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    Column(
                      verticalDirection: VerticalDirection.up,
                      children: [
                        InkWell(
                          onTap: (){
          
                          },
                          child: Container(
                              width: 100,
                              padding: const EdgeInsets.only(
                                  top: 3,
                                  bottom: 5,
                                  left: 8,
                                  right: 8
                              ),
                              decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiary.withOpacity(0.75),
                                  borderRadius: globalBorderRadius * 3,
                                  border: Border(
                                    top: BorderSide(
                                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: theme.colorScheme.onPrimary,
                                        offset: const Offset(-5, -5),
                                        blurRadius: 50,
                                        spreadRadius: 5
                                    )
                                  ]
                              ),
                              child: Center(
                                child: Text("اپلود عکس", style: theme.textTheme.bodyLarge,),
                              )
                          ),
                        ),
                        const SizedBox(height: 18),
                        Padding(
                          padding: globalPadding * 7,
                          child: ClipRRect(
                            borderRadius: globalBorderRadius * 5,
                            child: Image.asset("assets/images/image.png"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13,),
                    Padding(
                      padding: globalPadding * 8,
                      child: MyDivider(
                        color: theme.colorScheme.onSurface,
                        height: 1,
                        thickness: 1,
                      ),
                    ),
                    const SizedBox(height: 14,),
                    Container(
                      margin: globalPadding * 10,
                      padding: const EdgeInsets.only(bottom: 5, right: 9,left: 9),
                      decoration: BoxDecoration(
                        color: AppColors.textFieldColor,
                        borderRadius: globalBorderRadius * 4,
                      ),
                      child: TextField(
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.surface
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "قیمت",
                          hintStyle: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.surface.withOpacity(0.5)
                          )
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      margin: globalPadding * 10,
                      padding: const EdgeInsets.only(bottom: 5, right: 9,left: 9),
                      decoration: BoxDecoration(
                        color: AppColors.textFieldColor,
                        borderRadius: globalBorderRadius * 4,
                      ),
                      child: TextField(
                        style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.surface
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "متراژ",
                            hintStyle: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.surface.withOpacity(0.5)
                            )
                        ),
                      ),
                    ),
                    const SizedBox(height: 23),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: globalPadding * 11,
                child: MyDivider(
                  color: theme.colorScheme.onSecondary,
                  height: 1,thickness: 1,
                ),
              ),
              const SizedBox(height: 12),
              ButtonItem(
                onTap: (){},
                title: "ایجاد",
                color: theme.colorScheme.tertiary,
                textStyle: theme.textTheme.bodyLarge,
              )
            ],
          ),
        ),
      ),
    );
  }
}
