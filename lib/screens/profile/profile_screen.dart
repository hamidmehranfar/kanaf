import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '/screens/profile/create_post_story_screen.dart';
import '/screens/profile/works_report_screen.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/my_divider.dart';
import '/widgets/button_item.dart';
import '/global_configs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin{
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 1, vsync: this,);
  }
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
        appBar: CustomAppbar(
          onTap: (){},
          icon: Icons.menu,
        ),
        body: SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 25,),
              Center(
                child: Text("احمد احمدی", style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.w300
                ),),
              ),
              const SizedBox(height: 14,),
              Padding(
                padding: globalPadding * 11,
                child: MyDivider(
                  color: theme.colorScheme.onSecondary,
                  height: 1,thickness: 1,
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: globalBorderRadius * 10,
                ),
                child: Image.asset("assets/images/master_profile.png",
                  width: 150,height: 150),
              ),
              const SizedBox(height: 7,),
              Padding(
                padding: globalPadding * 11,
                child: MyDivider(
                  color: theme.colorScheme.onSecondary,
                  height: 1,thickness: 1,
                ),
              ),
              const SizedBox(height: 6,),
              Padding(
                padding: globalPadding * 12,
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
                        Text("امتیاز", style: theme.textTheme.titleMedium?.copyWith(
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
                        Text("کد معرف", style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w400
                        ),),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6,),
              Padding(
                padding: globalPadding * 11,
                child: MyDivider(
                  color: theme.colorScheme.onSecondary,
                  height: 1,thickness: 1,
                ),
              ),
              const SizedBox(height: 25,),
              Column(
                children: [
                  ButtonItem(
                    onTap: (){
                      Get.to(const WorksReportScreen());
                    },
                    title: "گزارش کارها",
                    color: theme.colorScheme.tertiary,
                  ),
                  const SizedBox(height: 11,),
                  ButtonItem(
                    onTap: (){},
                    title: "ویرایش صفحه",
                    color: theme.colorScheme.secondary.withValues(
                      alpha: 0.53
                    ),
                  ),
                  const SizedBox(height: 11,),
                  ButtonItem(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:(context){
                            return const CreatePostStoryScreen(
                              isStory: false,
                            );
                          }
                        )
                      );
                    },
                    title: "پست جدید",
                    color: theme.colorScheme.secondary.withValues(
                        alpha: 0.53
                    ),
                  ),
                  const SizedBox(height: 11,),
                  ButtonItem(
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder:(context){
                                return const CreatePostStoryScreen(
                                  isStory: true,
                                );
                              }
                          )
                      );
                    },
                    title: "استوری جدید",
                    color: theme.colorScheme.secondary.withValues(
                        alpha: 0.53
                    ),
                  ),
                  const SizedBox(height: 11,),
                  ButtonItem(
                    onTap: (){},
                    title: "ایجاد گزارش",
                    color: theme.colorScheme.secondary.withValues(
                        alpha: 0.53
                    ),
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
              const SizedBox(height: 100,),
            ],
          )
        )
    );
  }
}
