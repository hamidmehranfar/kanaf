import 'package:flutter/material.dart';
import '/../controllers/size_controller.dart';
import '/../widgets/custom_bottom_navbar.dart';
import '/../screens/home_screen.dart';
import '/../screens/search_screen.dart';

import 'profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 2;
  List<Widget> screens = [
    Navigator(
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
            builder:(context){
              return const ProfileScreen();
            }
        );
      },
    ),
    Center(child: Text("chat page"),),
    Navigator(
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
            builder:(context){
              return const HomeScreen();
            }
        );
      },
    ),
    Scaffold(
        backgroundColor: Colors.green,
        body: Center(child: Text("talar page"),)
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
  ];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SizedBox(
        width: SizeController.width,
        height: SizeController.height,
        child: Stack(
          children: [
            IndexedStack(
              index: currentIndex,
              children: screens,
            ),
            Positioned(
              bottom: 0,
              child: CustomBottomNavBar(onTap: (int index){
                setState(() {
                  print("clicked index : $index");
                  currentIndex = index;
                });
              },)
            ),
          ]
        ),
      ),
    );
  }
}
