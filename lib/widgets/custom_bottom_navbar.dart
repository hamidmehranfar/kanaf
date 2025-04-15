import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/controllers/size_controller.dart';
import '/global_configs.dart';

class CustomBottomNavBar extends StatefulWidget {
  final Function(int index) onTap;

  const CustomBottomNavBar({super.key, required this.onTap});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int selectedTab = 2;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 13,
      ),
      width: SizeController.width(context),
      height: 110,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: globalBorderRadius * 6,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.tertiary,
                    offset: const Offset(-3, -3),
                  ),
                  BoxShadow(
                    color: theme.colorScheme.onSecondary,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedTab = 0;
                              });
                              widget.onTap(0);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/user.svg",
                                  width: 30,
                                  height: 30,
                                  colorFilter: ColorFilter.mode(
                                    selectedTab == 0
                                        ? theme.colorScheme.tertiary
                                        : theme.colorScheme.secondary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "پروفایل",
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedTab = 1;
                              });
                              widget.onTap(1);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/chat.svg",
                                  width: 30,
                                  height: 30,
                                  colorFilter: ColorFilter.mode(
                                    selectedTab == 1
                                        ? theme.colorScheme.tertiary
                                        : theme.colorScheme.secondary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                Text(
                                  "چت",
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedTab = 3;
                              });
                              widget.onTap(3);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/talar.svg",
                                  width: 30,
                                  height: 30,
                                  colorFilter: ColorFilter.mode(
                                    selectedTab == 3
                                        ? theme.colorScheme.tertiary
                                        : theme.colorScheme.secondary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                Text(
                                  "تالار گفتگو",
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedTab = 4;
                              });
                              widget.onTap(4);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/search.svg",
                                  width: 30,
                                  height: 30,
                                  colorFilter: ColorFilter.mode(
                                    selectedTab == 4
                                        ? theme.colorScheme.tertiary
                                        : theme.colorScheme.secondary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                Text(
                                  "جستجو",
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
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
              onTap: () {
                setState(() {
                  selectedTab = 2;
                });
                widget.onTap(2);
              },
              child: Container(
                height: 60,
                padding: globalPadding * 4,
                decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary, shape: BoxShape.circle),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    SvgPicture.asset(
                      selectedTab == 2
                          ? "assets/icons/home_selected.svg"
                          : "assets/icons/home.svg",
                      width: 30,
                      height: 30,
                    ),
                    Text(
                      "خانه",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: selectedTab == 2
                            ? theme.colorScheme.tertiary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
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
