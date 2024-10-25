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
                          Text(widget.title, style: theme.textTheme.titleLarge,)
                        ],
                      ),
                    )
                  ),
                  bottom: TabBar(
                    dividerColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 3.0), //hight of indicator
                      insets: EdgeInsets.symmetric(horizontal: 30.0), //give some padding to reduce the size of indicator
                    ),
                    labelColor: theme.colorScheme.onSurface,
                    indicatorColor: theme.colorScheme.onSurface,
                    indicatorSize: TabBarIndicatorSize.tab,
                    controller: tabController,
                    tabs: [
                      Tab(
                        child: SizedBox(
                          width: SizeController.width!/2,
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(child: Text("پست ها")),
                              ),
                              Container(
                                width: 1,
                                height: 20,
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              )
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: SizedBox(
                          width: SizeController.width!/2 - 40,
                          child: Center(child: Text("نظرات")),
                        ),
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
