import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/size_controller.dart';

import '../../global_configs.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/my_divider.dart';
import '../../widgets/button_item.dart';

class WorksReportScreen extends StatelessWidget {
  const WorksReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    
    return Scaffold(
      appBar: CustomAppbar(
        onTap: (){
          Get.back();
        },
        iconAsset: "assets/icons/arrow_back_19.png",
      ),
      body: SizedBox(
        width: SizeController.width(context),
        height: SizeController.height(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 25,),
            Text("گزارش ها", style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.tertiary,
                fontWeight: FontWeight.w300
            ),),
            const SizedBox(height: 14,),
            Padding(
              padding: globalPadding * 11,
              child: MyDivider(
                color: theme.colorScheme.onSecondary,
                height: 1,thickness: 1,
              ),
            ),
            const SizedBox(height: 14,),
            ButtonItem(
              onTap: (){},
              title: "ثبت گزارش کار جدید",
              color: theme.colorScheme.tertiary,
            ),
            const SizedBox(height: 15,),
            Container(
              margin: globalPadding * 6,
              padding: globalPadding * 7,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: globalBorderRadius * 3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 10,),
                  Image.asset("assets/images/image.png",),
                  const SizedBox(height: 36,),
                  Text("ادمین کناف کار", style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),),
                  const SizedBox(height: 6,),
                  MyDivider(color: theme.colorScheme.onSurface,
                      height: 1, thickness: 1,
                  ),
                  const SizedBox(height: 4,),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("تایید شده", style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w300
                            ),),
                            Text("نظر ادمین کناف کار", style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w300
                            ),)
                          ],
                        ),
                      ),
                      const SizedBox(width: 2,),
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primary,
                        child: Image.asset("assets/images/master_user.png",
                          width: 36, height: 36,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 44,)
                ],
              ),
            ),
            const SizedBox(height: 24,),
            Padding(
              padding: globalPadding * 11,
              child: MyDivider(
                color: theme.colorScheme.onSecondary,
                height: 1,thickness: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
