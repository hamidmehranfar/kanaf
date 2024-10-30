import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '/controllers/size_controller.dart';
import '/widgets/my_divider.dart';
import '/widgets/profile_item.dart';

import '../global_configs.dart';

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
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary.withOpacity(0.3),
          automaticallyImplyLeading: false,
          centerTitle: true,
          // actions: [
          //   IconButton(
          //     onPressed: (){
          //
          //     },
          //     icon: const Icon(Iconsax.more),),
          // ],
        ),
        body: SafeArea(
          child: Container(
            width: SizeController.width,
            height: SizeController.height,
            color: theme.colorScheme.primary.withOpacity(0.3),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32,),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: globalBorderRadius * 2,
                        child: Image.asset("assets/images/user.png",width: 100,),
                      ),
                    ),
                    const SizedBox(height: 12,),
                    Text("حمید", style: theme.textTheme.titleLarge,),
                    const SizedBox(height: 12,),
                    Text("09900990099", style: theme.textTheme.titleMedium,),
                    const SizedBox(height: 12,),
                    Padding(
                      padding: globalPadding * 3,
                      child: MyDivider(
                        color: theme.colorScheme.inverseSurface.withOpacity(0.5),
                        height: 1,
                        thickness: 1,
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("3'248", style: theme.textTheme.titleLarge,),
                              Text("پست", style: theme.textTheme.bodyMedium!,),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("10", style: theme.textTheme.titleLarge,overflow: TextOverflow.ellipsis,),
                              Text("امتیاز", style: theme.textTheme.bodyMedium!,),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("knf23", style: theme.textTheme.titleLarge,),
                              Text("کد معرف", style: theme.textTheme.bodyMedium!,),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8,)
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: globalPadding * 4,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      color: theme.colorScheme.surface,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      padding: globalPadding * 6,
                      children: [
                        const SizedBox(height: 24,),
                        ProfileItem(
                          title: "پست ها",
                          icon: Icons.person_2_outlined,
                          onTap: (){

                          },
                        ),
                        const SizedBox(height: 48,),
                        ProfileItem(
                          title: "پروفایل",
                          icon: Icons.notifications_outlined,
                          onTap: (){

                          },
                        ),
                        const SizedBox(height: 48,),
                        ProfileItem(
                          title: "تنظیمات",
                          icon: Icons.settings_outlined,
                          onTap: (){

                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ),
        )
    );
  }
}
