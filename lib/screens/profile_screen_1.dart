import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kanaf/controllers/size_controller.dart';
import 'package:kanaf/widgets/my_divider.dart';

import '../global_configs.dart';

class ProfileScreen1 extends StatefulWidget {
  const ProfileScreen1({super.key});

  @override
  State<ProfileScreen1> createState() => _ProfileScreen1State();
}

class _ProfileScreen1State extends State<ProfileScreen1> with TickerProviderStateMixin{
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
          backgroundColor: theme.colorScheme.secondary.withOpacity(0.2),
          leading: IconButton(
            onPressed: (){

            },
            icon: const Icon(Iconsax.arrow_right_1),),

          centerTitle: true,
          actions: [
            IconButton(
              onPressed: (){

              },
              icon: const Icon(Iconsax.more),),
          ],
        ),
        body: SafeArea(
          child: SizedBox(
            width: SizeController.width,
            height: SizeController.height,
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  color: theme.colorScheme.secondary.withOpacity(0.2),
                  child: Column(
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
                                Text("511K", style: theme.textTheme.titleLarge,overflow: TextOverflow.ellipsis,),
                                Text("دنبال کننده", style: theme.textTheme.bodyMedium!,),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("1,944", style: theme.textTheme.titleLarge,),
                                Text("دنبال شونده", style: theme.textTheme.bodyMedium!,),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8,)
                    ],
                  ),
                )
              ],
            )
          ),
        )
    );
  }
}
