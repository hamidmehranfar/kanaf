import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kanaf/global_configs.dart';
import 'package:kanaf/screens/home_screen.dart';
import 'package:kanaf/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  List<Widget> screens = [
    const HomeScreen(),
    Center(child: Text("search page"),),
    Center(child: Text("chat page"),),
    Center(child: Text("talar page"),),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.colorScheme.outline,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            backgroundColor: theme.colorScheme.primary,
            icon: Container(
              padding: bottomNavigationIconPadding,
              decoration: BoxDecoration(
                  borderRadius: globalBorderRadius * 3,
                  color: currentIndex == 0 ? theme.colorScheme.primary.withOpacity(0.2) : Colors.transparent
              ),
              child: Icon(Iconsax.home_2),
            ),
            label: "خانه"
          ),
          BottomNavigationBarItem(
              icon: Container(
                padding: bottomNavigationIconPadding,
                decoration: BoxDecoration(
                  borderRadius: globalBorderRadius * 3,
                  color: currentIndex == 1 ? theme.colorScheme.primary.withOpacity(0.2) : Colors.transparent
                ),
                child: Icon(Iconsax.search_normal),
              ),
              label: "جستجو"
          ),
          BottomNavigationBarItem(
              icon: Container(
                padding: bottomNavigationIconPadding,
                decoration: BoxDecoration(
                    borderRadius: globalBorderRadius * 3,
                    color: currentIndex == 2 ? theme.colorScheme.primary.withOpacity(0.2) : Colors.transparent
                ),
                child: Icon(Iconsax.message),
              ),
              label: "چت"
          ),
          BottomNavigationBarItem(
              icon: Container(
                padding: bottomNavigationIconPadding,
                decoration: BoxDecoration(
                    borderRadius: globalBorderRadius * 3,
                    color: currentIndex == 3 ? theme.colorScheme.primary.withOpacity(0.2) : Colors.transparent
                ),
                child: Icon(Iconsax.messages),
              ),
              label: "تالار گفتگو"
          ),
          BottomNavigationBarItem(
              icon: Container(
                padding: bottomNavigationIconPadding,
                decoration: BoxDecoration(
                    borderRadius: globalBorderRadius * 3,
                    color: currentIndex == 4 ? theme.colorScheme.primary.withOpacity(0.2) : Colors.transparent
                ),
                child: Icon(Iconsax.profile_circle),
              ),
              label: "پروفایل"
          ),
        ],
        selectedItemColor: Colors.black,
        currentIndex: currentIndex,
        onTap: (int index){
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
