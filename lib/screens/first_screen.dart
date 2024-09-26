import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("سلام", style: Theme.of(context).textTheme.titleLarge,),
      ),
    );
  }
}
