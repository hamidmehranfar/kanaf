import 'package:flutter/material.dart';

import '/global_configs.dart';
import '/screens/services_list_screen.dart';
import '/widgets/custom_appbar.dart';
import '/controllers/size_controller.dart';
import '/res/enums/master_services.dart';
import '/widgets/master_services_items.dart';
import '/widgets/my_divider.dart';

class MasterServicesScreen extends StatefulWidget {
  const MasterServicesScreen({super.key});

  @override
  State<MasterServicesScreen> createState() => _MasterServicesScreenState();
}

class _MasterServicesScreenState extends State<MasterServicesScreen> {
  bool filterClick = false;

  void onSeeAllPressed(context, service){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return ServicesListScreen(service: service);
    }));
  }

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
          width: SizeController.width(context),
          height: SizeController.height(context),
          child: Stack(
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      InkWell(
                        onTap: ()=> onSeeAllPressed(context, MasterServices.kanafWorker),
                        child: Container(
                          width: 75,
                          height: 30,
                          margin: const EdgeInsets.only(top: 10, right: 20),
                          decoration: BoxDecoration(
                            borderRadius: globalBorderRadius * 3,
                            color: theme.colorScheme.tertiary.withValues(alpha: 0.75),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_back_ios,size: 8,
                                color: theme.colorScheme.onPrimary,),
                              Text("مشاهده همه", style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("کنافکار ها",
                                  style: theme.textTheme.headlineLarge?.copyWith(
                                      color: theme.colorScheme.tertiary,
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                                const SizedBox(width: 64),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 44, right: 7),
                              child: MyDivider(
                                color: theme.colorScheme.onSecondary,
                                height: 10,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: SizeController.width(context),
                    height: 170,
                    child: ListView.separated(
                      padding: globalPadding * 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){
                        return const MasterServicesItems(service: MasterServices.kanafWorker);
                      },
                      separatorBuilder: (context, index){
                        return const SizedBox(width: 9,);
                      },
                      itemCount: 4,
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Row(
                    children: [
                      InkWell(
                        onTap: ()=> onSeeAllPressed(context, MasterServices.kanafWorker),
                        child: Container(
                          width: 75,
                          height: 30,
                          margin: const EdgeInsets.only(top: 10, right: 20),
                          decoration: BoxDecoration(
                            borderRadius: globalBorderRadius * 3,
                            color: theme.colorScheme.tertiary.withValues(alpha: 0.75),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_back_ios,size: 8,
                                color: theme.colorScheme.onPrimary,),
                              Text("مشاهده همه", style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("لاین نور",
                                  style: theme.textTheme.headlineLarge?.copyWith(
                                      color: theme.colorScheme.tertiary,
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                                const SizedBox(width: 64),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 44, right: 7),
                              child: MyDivider(
                                color: theme.colorScheme.onSecondary,
                                height: 10,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: SizeController.width(context),
                    height: 170,
                    child: ListView.separated(
                      padding: globalPadding * 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){
                        return const MasterServicesItems(service: MasterServices.opticalLineWorker);
                      },
                      separatorBuilder: (context, index){
                        return const SizedBox(width: 9,);
                      },
                      itemCount: 4,
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Row(
                    children: [
                      InkWell(
                        onTap: ()=> onSeeAllPressed(context, MasterServices.kanafWorker),
                        child: Container(
                          width: 75,
                          height: 30,
                          margin: const EdgeInsets.only(top: 10, right: 20),
                          decoration: BoxDecoration(
                            borderRadius: globalBorderRadius * 3,
                            color: theme.colorScheme.tertiary.withValues(alpha: 0.75),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_back_ios,size: 8,
                                color: theme.colorScheme.onPrimary,),
                              Text("مشاهده همه", style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("نقاش ها",
                                  style: theme.textTheme.headlineLarge?.copyWith(
                                      color: theme.colorScheme.tertiary,
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                                const SizedBox(width: 64),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 44, right: 7),
                              child: MyDivider(
                                color: theme.colorScheme.onSecondary,
                                height: 10,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: SizeController.width(context),
                    height: 170,
                    child: ListView.separated(
                      padding: globalPadding * 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){
                        return const MasterServicesItems(service: MasterServices.painterWorker);
                      },
                      separatorBuilder: (context, index){
                        return const SizedBox(width: 9,);
                      },
                      itemCount: 4,
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Row(
                    children: [
                      InkWell(
                        onTap: ()=> onSeeAllPressed(context, MasterServices.kanafWorker),
                        child: Container(
                          width: 75,
                          height: 30,
                          margin: const EdgeInsets.only(top: 10, right: 20),
                          decoration: BoxDecoration(
                            borderRadius: globalBorderRadius * 3,
                            color: theme.colorScheme.tertiary.withValues(alpha: 0.75),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_back_ios,size: 8,
                                color: theme.colorScheme.onPrimary,),
                              Text("مشاهده همه", style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("برق کار ها",
                                  style: theme.textTheme.headlineLarge?.copyWith(
                                      color: theme.colorScheme.tertiary,
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                                const SizedBox(width: 64),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 44, right: 7),
                              child: MyDivider(
                                color: theme.colorScheme.onSecondary,
                                height: 10,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: SizeController.width(context),
                    height: 170,
                    child: ListView.separated(
                      padding: globalPadding * 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){
                        return const MasterServicesItems(service: MasterServices.painterWorker);
                      },
                      separatorBuilder: (context, index){
                        return const SizedBox(width: 9,);
                      },
                      itemCount: 4,
                    ),
                  ),
                  const SizedBox(height: 150,)
                ],
              ),
              Positioned(
                left: 0,
                top: 10,
                child: InkWell(
                  onTap: ()=> setState(() {
                    filterClick = !filterClick;
                  }),
                  child: Container(
                    width: 100,

                    decoration: BoxDecoration(
                      borderRadius: globalBorderRadius * 2,
                      color: theme.colorScheme.tertiary,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.settings_outlined,size: 24,
                              color: theme.colorScheme.onSurface,),
                            Text("فیلتر کنید", style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),),
                          ],
                        ),
                        const SizedBox(height: 8,),
                        if(filterClick)...[
                          Container(
                            padding: globalPadding * 4,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary,
                              borderRadius: globalBorderRadius * 3,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 6,),
                                Text("انتخاب شهر", style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSecondary
                                ),),
                                const SizedBox(height: 6,),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ]
                      ],
                    ),
                  ),
                )
              )
            ],
          ),
        )
    );
  }
}
