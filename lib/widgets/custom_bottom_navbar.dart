import 'package:flutter/material.dart';
import '/../controllers/size_controller.dart';
import '/../global_configs.dart';

class CustomBottomNavBar extends StatefulWidget {
  final Function(int index) onTap;
  const CustomBottomNavBar({super.key, required this.onTap});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 13,
      ),
      width: SizeController.width,
      height: 100,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(
                top: 10,bottom: 10,left: 20,right: 20
              ),
              decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: globalBorderRadius * 6
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            widget.onTap(4);
                          },
                          child: Column(
                            children: [
                              Icon(Icons.person, size: 25,
                                color: theme.colorScheme.secondary,),
                              Text("پروفایل", style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onPrimary
                              ),),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            widget.onTap(3);
                          },
                          child: Column(
                            children: [
                              Icon(Icons.chat, size: 25,
                                color: theme.colorScheme.secondary,),
                              Text("چت", style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onPrimary
                              ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 80,),
                  SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            widget.onTap(1);
                          },
                          child: Column(
                            children: [
                              Icon(Icons.settings_outlined, size: 25,
                                color: theme.colorScheme.secondary,),
                              Text("تالار گفتگو", style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onPrimary
                              ),),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            widget.onTap(0);
                          },
                          child: Column(
                            children: [
                              Icon(Icons.search, size: 25,
                                color: theme.colorScheme.secondary,),
                              Text("جستجو", style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onPrimary
                              ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            child:InkWell(
              onTap: (){
                widget.onTap(0);
              },
              child: Container(
                height: 50,
                padding: globalPadding * 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary,
                  shape: BoxShape.circle
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 5,),
                    Icon(Icons.home_filled, size: 25,
                      color: theme.colorScheme.tertiary,
                    ),
                    Text("خانه", style: theme.textTheme.labelMedium,)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
