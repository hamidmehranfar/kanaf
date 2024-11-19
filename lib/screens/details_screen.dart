import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '/../controllers/size_controller.dart';
import '/../widgets/custom_appbar.dart';
import '/../widgets/my_divider.dart';
import '../global_configs.dart';

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
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(
        onTap: ()=>Get.back(),
      ),
      body: SafeArea(
        child: Padding(
          padding: globalPadding * 11,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10,),
              SizedBox(
                width: SizeController.width(context),
                height: 120,
                child: Stack(
                  children: [
                    Positioned(
                      top:50,
                      left: 0,
                      right: 0,
                      child: MyDivider(
                        color: theme.colorScheme.onSurface,
                        height: 1,
                        thickness: 1,
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle
                        ),
                        child: Image.asset("assets/images/master_user.png",),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width:90,
                            height: 36,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.tertiary,
                              borderRadius: globalBorderRadius * 3
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            width:90,
                            height: 36,
                            decoration: BoxDecoration(
                                color: theme.colorScheme.tertiary,
                                borderRadius: globalBorderRadius * 3
                            ),
                          ),
                        ],
                      )
                    )
                  ],
                ),
              ),
              Container(
                width:90,
                height: 36,
                decoration: BoxDecoration(
                    color: theme.colorScheme.tertiary,
                    borderRadius: globalBorderRadius * 3
                ),
              ),
              const SizedBox(height: 16,),
              Padding(
                padding: globalPadding * 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("3".toPersianDigit(), style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w400
                        ),),
                        Text("پست", style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w400
                        ),),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("1".toPersianDigit(), style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w400
                        ),),
                        Text("سابقه", style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w400
                        ),),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("3".toPersianDigit(), style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w400
                        ),),
                        Text("رتبه", style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w400
                        ),),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16,),
              MyDivider(
                color: theme.colorScheme.onSurface,
                height: 1,
                thickness: 1,
              ),
              const SizedBox(height: 12,),
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
