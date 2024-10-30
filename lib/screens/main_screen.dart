import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kanaf/global_configs.dart';
import 'package:kanaf/screens/home_screen.dart';
import 'package:kanaf/screens/search_screen.dart';

import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  List<Widget> screens = [
    Navigator(
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          builder:(context){
            return const HomeScreen();
          }
        );
      },
    ),
    Navigator(
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
            builder:(context){
              return const SearchScreen(isMainScreen: true,);
            }
        );
      },
    ),
    Center(child: Text("chat page"),),
    Center(child: Text("talar page"),),
    Navigator(
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
            builder:(context){
              return const ProfileScreen();
            }
        );
      },
    ),
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
        items: [
          BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                width: 45,
                decoration: BoxDecoration(
                  borderRadius: globalBorderRadius * 10,
                  color: currentIndex==0 ? theme.colorScheme.primary.withOpacity(0.5) :
                  null,
                ),
                child: const Icon(Iconsax.home_2),
              ),
              label: "خانه"
          ),
          BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                width: 45,
                decoration: BoxDecoration(
                  borderRadius: globalBorderRadius * 10,
                  color: currentIndex==1 ? theme.colorScheme.primary.withOpacity(0.5) :
                  null,
                ),
                child: const Icon(Iconsax.search_normal)
              ),
              label: "جستجو"
          ),
          BottomNavigationBarItem(
              icon: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  width: 45,
                  decoration: BoxDecoration(
                    borderRadius: globalBorderRadius * 10,
                    color: currentIndex==2 ? theme.colorScheme.primary.withOpacity(0.5) :
                    null,
                  ),
                child: const Icon(Iconsax.message)
              ),
              label: "چت"
          ),
          BottomNavigationBarItem(
              icon: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  width: 45,
                  decoration: BoxDecoration(
                    borderRadius: globalBorderRadius * 10,
                    color: currentIndex==3 ? theme.colorScheme.primary.withOpacity(0.5) :
                    null,
                  ),
                child: const Icon(Iconsax.messages)
              ),
              label: "تالار گفتگو"
          ),
          BottomNavigationBarItem(
              icon: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  width: 45,
                  decoration: BoxDecoration(
                    borderRadius: globalBorderRadius * 10,
                    color: currentIndex==4 ? theme.colorScheme.primary.withOpacity(0.5) :
                    null,
                  ),
                child: const Icon(Iconsax.profile_circle)
              ),
              label: "پروفایل"
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index){
          setState(() {
            currentIndex = index;
          });
        },
        selectedFontSize: 12,
        unselectedFontSize: 12,
        backgroundColor: Color(0xFFCAD8DC),
        selectedItemColor: theme.colorScheme.onSurface,
        unselectedItemColor: theme.colorScheme.inverseSurface,
      )
    );
  }
}
