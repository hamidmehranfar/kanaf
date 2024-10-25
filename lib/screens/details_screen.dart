import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kanaf/controllers/size_controller.dart';
import '../global_configs.dart';

class DetailsScreen extends StatefulWidget {
  final String title;
  const DetailsScreen({super.key, required this.title});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with TickerProviderStateMixin{
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this,);
  }
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: const Icon(Iconsax.arrow_right_1),
        ),
        actions: [
          IconButton(
            onPressed: (){

            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
        shadowColor: theme.colorScheme.onSurface.withOpacity(0.5),
        elevation: 5,
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 300,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: globalAllPadding * 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: ClipRRect(
                                  borderRadius: globalBorderRadius * 2,
                                  child: Container(
                                  color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("3", style: theme.textTheme.bodyLarge,),
                                          Text("پست", style: theme.textTheme.bodyMedium!,),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("7", style: theme.textTheme.bodyLarge,overflow: TextOverflow.ellipsis,),
                                          Text("دنبال کننده", style: theme.textTheme.bodyMedium!,),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: theme.colorScheme.onSurface.withOpacity(0.5)
                                          ),
                                          borderRadius: globalBorderRadius * 2,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("1", style: theme.textTheme.titleLarge,),
                                            Text("رتبه کسب و کار", style: theme.textTheme.titleMedium!,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16,),
                          Text(widget.title, style: theme.textTheme.titleLarge,),
                          const SizedBox(height: 16,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FilledButton(
                                onPressed: (){},
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: globalBorderRadius,
                                    ),
                                    padding: EdgeInsets.zero,
                                    fixedSize: const Size.fromWidth(150)
                                  ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add_circle, color: theme.colorScheme.onPrimary,),
                                    const SizedBox(width: 5,),
                                    Text("دنبال کردن", style: theme.textTheme.bodyLarge,)
                                  ],
                                ),
                              ),
                              OutlinedButton(
                                onPressed: (){},
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: globalBorderRadius,
                                  ),
                                  padding: EdgeInsets.zero,
                                  fixedSize: const Size.fromWidth(150),
                                  side: BorderSide(color: theme.colorScheme.primary,),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.telegram_outlined, color: theme.colorScheme.primary,),
                                    const SizedBox(width: 5,),
                                    Text("پیام", style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: OutlinedButton(
                                  onPressed: (){},
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: globalBorderRadius,
                                    ),
                                    padding: EdgeInsets.zero,
                                    side: BorderSide(color: theme.colorScheme.primary,),
                                  ),
                                  child: Icon(Icons.phone, color: theme.colorScheme.primary,),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ),
                  bottom: TabBar(
                    dividerColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    indicatorColor: theme.colorScheme.onSurface,
                    indicatorSize: TabBarIndicatorSize.tab,
                    controller: tabController,
                    tabs: [
                      Tab(
                        child: Text("پست ها",
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      Tab(
                        child: Text("نظرات",
                          style: theme.textTheme.bodyMedium,),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: tabController,
              children: [
                GridView.builder(
                  itemCount: 20,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1/2
                  ),
                  itemBuilder: (context, index){
                    return Container(
                      height: 400,
                      color: index %2 == 0 ? theme.colorScheme.primary : theme.colorScheme.secondary,
                    );
                  }
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index){
                    if(index == 0){
                      return const SizedBox(height: 16,);
                    }
                    return Padding(
                      padding: globalPadding * 2,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.colorScheme.onPrimary,
                            width: 1
                          ),
                        ),
                        padding: globalAllPadding * 4,
                        child: Text(
                          "تست"
                        ),
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
