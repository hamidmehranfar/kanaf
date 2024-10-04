import 'package:flutter/material.dart';
import 'package:kanaf/widgets/my_divider.dart';

class MasterServicesScreen extends StatelessWidget {
  const MasterServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("اوستا کارها", style: theme.textTheme.titleLarge,),
        bottom: MyDivider(
          color: theme.colorScheme.inverseSurface,
          height: 1,
          thickness: 1,
        )
      ),
    );
  }
}
