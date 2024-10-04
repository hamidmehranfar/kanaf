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
      bottomNavigationBar: Theme(
        data: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(Iconsax.home_2),
              label: "خانه"
            ),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.search_normal),
                label: "جستجو"
            ),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.message),
                label: "چت"
            ),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.messages),
                label: "تالار گفتگو"
            ),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.profile_circle),
                label: "پروفایل"
            ),
          ],
          currentIndex: currentIndex,
          onTap: (int index){
            setState(() {
              currentIndex = index;
            });
          },
          selectedItemColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.outline,
          unselectedItemColor: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
