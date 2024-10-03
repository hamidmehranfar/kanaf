import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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
    tabController = TabController(length: 3, vsync: this,);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){

          },
          icon: const Icon(Iconsax.arrow_left_2),),
        title: Text("Hamid", style:theme.textTheme.titleLarge ,),
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
          width: MediaQuery.of(context).size.width,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
              return [
                SliverAppBar(
                  expandedHeight: 320,
                  flexibleSpace: FlexibleSpaceBar(
                    background: getFlexibleSpace(theme)
                  ),
                  bottom: TabBar(
                    dividerColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    labelColor: theme.colorScheme.onSurface,
                    indicatorColor: theme.colorScheme.onSurface,
                    indicatorSize: TabBarIndicatorSize.tab,
                    controller: tabController,
                    tabs: const [
                      Tab(icon: Icon(Iconsax.grid_1)),
                      Tab(icon: Icon(Iconsax.video_square)),
                      Tab(icon: Icon(Iconsax.user_square)),
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
                GridView.builder(
                    itemCount: 20,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1/2
                    ),
                    itemBuilder: (context, index){
                      return Container(
                        height: 400,
                        color: index %2 == 0 ? theme.colorScheme.primary : theme.colorScheme.error,
                      );
                    }
                ),
                GridView.builder(
                    itemCount: 20,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2
                    ),
                    itemBuilder: (context, index){
                      return Container(

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

  Widget getFlexibleSpace(var theme){
    return Padding(
      padding: globalPadding * 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: globalBorderRadius * 2,
                child: Image.asset("assets/images/user.png",width: 96,),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("3'248", style: theme.textTheme.titleLarge,),
                          Text("Posts", style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.shadow),),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("511K", style: theme.textTheme.titleLarge,overflow: TextOverflow.ellipsis,),
                          Text("Followers", style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.shadow),),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("1,944", style: theme.textTheme.titleLarge,),
                          Text("Following", style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.shadow),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text("Hamid Mehranfar | College\nUniversity of Isfahan", style: theme.textTheme.bodyLarge,),
          const SizedBox(height: 10,),
          Row(
            children: [
              SizedBox(
                width: 80,
                height: 48,
                child: Stack(
                  children: [
                    Positioned(
                      left: 30,
                      child: ClipRRect(
                        child: Image.asset("assets/images/user.png",width: 48,),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: ClipRRect(
                        child: Image.asset("assets/images/user.png",width: 48,),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: Text.rich(TextSpan(
                    text: "Followed by ",
                    style: theme.textTheme.bodyLarge,
                    children: [
                      TextSpan(
                          text: "Hamid ",
                          style: theme.textTheme.titleLarge
                      ),
                      TextSpan(
                          text: "and ",
                          style: theme.textTheme.bodyLarge
                      ),
                      TextSpan(
                          text: "Javad",
                          style: theme.textTheme.titleLarge
                      ),
                    ]
                ),),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilledButton(
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: const Size(90,30),
                    shape: RoundedRectangleBorder(
                        borderRadius: globalBorderRadius
                    ),
                  ),
                  onPressed: (){

                  },
                  child: Text("Follow", style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.surface),)
              ),
              FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: const Size(90,30),
                      shape: RoundedRectangleBorder(
                          borderRadius: globalBorderRadius
                      ),
                      alignment: Alignment.center
                  ),
                  onPressed: (){

                  },
                  child: Text("Message", style: theme.textTheme.titleMedium)
              ),
              FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: const Size(90,30),
                      shape: RoundedRectangleBorder(
                          borderRadius: globalBorderRadius
                      ),
                      alignment: Alignment.center
                  ),
                  onPressed: (){

                  },
                  child: Text("Contact", style: theme.textTheme.titleMedium)
              ),
              IconButton(
                  onPressed: (){

                  },
                  icon: const Icon(Iconsax.user_cirlce_add)
              )
            ],
          ),
        ],
      ),
    );
  }
}
