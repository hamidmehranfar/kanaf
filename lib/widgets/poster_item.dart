import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '/controllers/size_controller.dart';
import '/models/master.dart';
import '/widgets/small_button.dart';
import '/../global_configs.dart';
import '/../screens/details_screen.dart';
import '/../widgets/my_divider.dart';

class PosterItem extends StatelessWidget {
  final Master master;
  const PosterItem({super.key, required this.master});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return InkWell(
      onTap: (){
        Get.to(DetailsScreen(id: master.id,));
      },
      child: Container(
        width: SizeController.width(context),
        padding: globalPadding * 4,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: globalBorderRadius * 3,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child:Column(
                    children: [
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '${master.user.firstName ?? ''} ${master.user.lastName ?? ''}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4,),
                          Row(
                            children: [
                              //FIXME : fix here
                              // Text(poster.num.toString().toPersianDigit(),
                              //   style: theme.textTheme.labelMedium?.copyWith(
                              //     color: theme.colorScheme.tertiary,
                              //   ),
                              // ),
                              Text(master.workHourEnd.toString().toPersianDigit(),
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.tertiary,
                                ),
                              ),
                              const SizedBox(width: 1,),
                              Icon(Icons.stacked_bar_chart_outlined,
                                size: 13,color: theme.colorScheme.secondary,),
                              const SizedBox(width: 9,),
                              //FIXME : fix here
                              // Text(poster.rating.toString().toPersianDigit(),
                              //   style: theme.textTheme.labelMedium?.copyWith(
                              //     color: theme.colorScheme.tertiary,
                              //   ),
                              // ),
                              Text(master.workHourStart.toString().toPersianDigit(),
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.tertiary,
                                ),
                              ),
                              Icon(Icons.star,
                                size: 13,color: theme.colorScheme.secondary,),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 5,),
                      MyDivider(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        height: 2,
                        thickness: 2,
                      ),
                      const SizedBox(height: 6,),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SmallButton(
                          text: "جزئیات",
                          textColor: theme.colorScheme.onPrimary,
                          width: 73, height: 23,
                          shadow: [
                            BoxShadow(
                              color: theme.colorScheme.onPrimary,
                              offset: const Offset(-15, -10),
                              blurRadius: 50,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 13,),
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  child: Image.asset("assets/images/master_user.png",
                    width: 60,height: 60,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15,),
          ],
        ),
      )
    );
  }
}
