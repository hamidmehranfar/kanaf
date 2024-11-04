import 'package:flutter/material.dart';
import 'package:kanaf/global_configs.dart';
import 'package:kanaf/screens/home_screen.dart';
import 'package:kanaf/screens/search_screen.dart';
import 'package:kanaf/widgets/custom_bottom_navbar.dart';

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
    Scaffold(
      backgroundColor: Colors.green,
        body: Center(child: Text("talar page"),)
    ),
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
      bottomNavigationBar: CustomBottomNavBar(
        onTap: (int index){
          setState(() {
            print(index);
            currentIndex = index;
          });
        },
      )
    );
  }
}
