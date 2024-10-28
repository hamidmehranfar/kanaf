import 'package:flutter/material.dart';
import '/controllers/size_controller.dart';
import '/models/enums/master_services.dart';
import '/widgets/master_services_items.dart';
import '/widgets/my_divider.dart';

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
      body: SizedBox(
        height: SizeController.height,
        child: Column(
          children: [
            const SizedBox(height: 16,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MasterServicesItems(
                    service: MasterServices.master,
                  ),
                  MasterServicesItems(
                    service: MasterServices.opticalLine,
                  ),
                  MasterServicesItems(
                    service: MasterServices.painter,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16,),
          ],
        ),
      )
    );
  }
}
