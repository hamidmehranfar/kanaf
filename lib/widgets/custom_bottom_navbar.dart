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
      height: 110,
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
                  borderRadius: globalBorderRadius * 6,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.tertiary,
                    offset: const Offset(-3,-3)
                  ),
                  BoxShadow(
                    color: theme.colorScheme.onSecondary,
                    offset: const Offset(3, 3)
                  )
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed:(){
                            widget.onTap(0);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Column(
                            children: [
                              Image.asset("assets/icons/user_icon.png",
                                width: 30, height: 30,
                              ),
                              const SizedBox(height: 2,),
                              Text("پروفایل", style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onPrimary
                              ),),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed:(){
                            widget.onTap(1);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child:Column(
                            children: [
                              Image.asset("assets/icons/pen_icon.png",
                                width: 30, height: 30,
                              ),
                              Text("چت", style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onPrimary
                              ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 60,),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed:(){
                            widget.onTap(3);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Column(
                            children: [
                              Image.asset("assets/icons/conversation_icon.png",
                                width: 30, height: 30,
                              ),
                              Text("تالار گفتگو", style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onPrimary
                              ),),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed:(){
                            widget.onTap(4);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Column(
                            children: [
                              Image.asset("assets/icons/search_icon.png",
                                width: 30,height: 30,),
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
            child: GestureDetector(
              onTap: (){
                widget.onTap(2);
              },
              child: Container(
                height: 60,
                padding: globalPadding * 4,
                decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary,
                    shape: BoxShape.circle
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 5,),
                    Image.asset("assets/icons/home_icon.png",
                      width: 30, height: 30,
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
