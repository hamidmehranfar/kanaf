import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '/res/app_colors.dart';
import '/screens/create_project_screen.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/my_divider.dart';
import '/global_configs.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>{
  @override
  void initState() {
    super.initState();
  }

  Widget getButtons({required String text,
    required Function() onTap}){
    var theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(
          top: 4,
          bottom: 4,
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
              offset: const Offset(-15, -10),
              blurRadius: 50,
            )
          ]
        ),
        child: Center(
          child: Text(text, style: theme.textTheme.labelSmall,),
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(
        iconAsset: "assets/icons/arrow_back_19.png",
        onTap: ()=> Get.back(),
      ),
      body: SafeArea(
        child: Padding(
          padding: globalPadding * 9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 23,),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text("12".toPersianDigit(),
                                  style: theme.textTheme.titleMedium,),
                                Text("پست", style: theme.textTheme.titleMedium,),
                              ],
                            ),
                            Column(
                              children: [
                                Text("3".toPersianDigit(),
                                  style: theme.textTheme.titleMedium,),
                                Text("رتبه", style: theme.textTheme.titleMedium,),
                              ],
                            ),
                            Column(
                              children: [
                                Text("3".toPersianDigit(),
                                  style: theme.textTheme.titleMedium,),
                                Text("رتبه", style: theme.textTheme.titleMedium,),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getButtons(text: "ارتباط با کارفرما", onTap: (){

                            }),
                            getButtons(text: "ثبت پروژه با کنافکار", onTap: (){
                              Get.to(const CreateProjectScreen());
                            }),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 11,),
                  Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: globalAllPadding,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.sideColor,
                                width: 5
                              )
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset("assets/images/master_user.png",
                                width: 88,height: 88,),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: Container(
                              padding: globalAllPadding,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.sideColor
                                ),
                                child: const Icon(Icons.add, size: 18,)
                              ),
                            ),
                          )
                        ]
                      ),
                      const SizedBox(height: 2,),
                      Text("اسم و بیو", style: theme.textTheme.titleMedium,),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20,),
              MyDivider(
                color: theme.colorScheme.onSurface,
                height: 1,
                thickness: 1,
              ),
              const SizedBox(height: 6,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(4, (index){
                  return Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.inverseSurface
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10,),
              MyDivider(
                color: theme.colorScheme.onSurface,
                height: 1,
                thickness: 1,
              ),
              const SizedBox(height: 14,),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10
                  ),
                  itemBuilder: (context, index){
                    return Container(
                      color: theme.colorScheme.inverseSurface,
                      width: 80,
                      height: 80,
                    );
                  },
                )
              )
            ],
          ),
        ),
      )
    );
  }
}
