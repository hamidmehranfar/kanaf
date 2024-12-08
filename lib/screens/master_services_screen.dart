import 'package:flutter/material.dart';
import 'package:kanaf/global_configs.dart';
import 'package:kanaf/screens/services_list_screen.dart';
import 'package:kanaf/widgets/master_service_label_item.dart';
import '../widgets/custom_appbar.dart';
import '/controllers/size_controller.dart';
import '/models/enums/master_services.dart';
import '/widgets/master_services_items.dart';
import '/widgets/my_divider.dart';
import 'home_screen.dart';

class MasterServicesScreen extends StatelessWidget {
  const MasterServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppbar(
        onTap: (){
          Navigator.of(context).pop();
        },
        iconAsset: "assets/icons/arrow_back_19.png",
      ),
      body: SizedBox(
        width: SizeController.width(context),
        height: SizeController.height(context),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 14,),
            MasterServiceLabelItem(
              label: "استادکارها",
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return const ServicesListScreen(service: MasterServices.master);
                })
              );
            }),
            const SizedBox(height: 5,),
            Padding(
              padding: globalPadding * 11,
              child: MyDivider(
                color: theme.colorScheme.onSecondary,
                height: 1,
                thickness: 1,
              ),
            ),
            const SizedBox(height: 22,),
            SizedBox(
              width: SizeController.width(context),
              height: 170,
              child: ListView.separated(
                padding: globalPadding * 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index){
                  return const MasterServicesItems(service: MasterServices.master);
                },
                separatorBuilder: (context, index){
                  return const SizedBox(width: 9,);
                },
                itemCount: 4,
              ),
            ),
            const SizedBox(height: 16,),
            MasterServiceLabelItem(
                label: "لاین نور",
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return const ServicesListScreen(service: MasterServices.master);
                  })
                  );
                }),
            const SizedBox(height: 5,),
            Padding(
              padding: globalPadding * 11,
              child: MyDivider(
                color: theme.colorScheme.onSecondary,
                height: 1,
                thickness: 1,
              ),
            ),
            const SizedBox(height: 22,),
            SizedBox(
              width: SizeController.width(context),
              height: 170,
              child: ListView.separated(
                padding: globalPadding * 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index){
                  return const MasterServicesItems(service: MasterServices.opticalLine);
                },
                separatorBuilder: (context, index){
                  return const SizedBox(width: 9,);
                },
                itemCount: 4,
              ),
            ),
            const SizedBox(height: 16,),
            MasterServiceLabelItem(
              label: "نقاش",
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return const ServicesListScreen(service: MasterServices.master);
                }));
              }
            ),
            const SizedBox(height: 5,),
            Padding(
              padding: globalPadding * 11,
              child: MyDivider(
                color: theme.colorScheme.onSecondary,
                height: 1,
                thickness: 1,
              ),
            ),
            const SizedBox(height: 22,),
            SizedBox(
              width: SizeController.width(context),
              height: 170,
              child: ListView.separated(
                padding: globalPadding * 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index){
                  return const MasterServicesItems(service: MasterServices.painter);
                },
                separatorBuilder: (context, index){
                  return const SizedBox(width: 9,);
                },
                itemCount: 4,
              ),
            ),
            const SizedBox(height: 150,)
          ],
        ),
      )
    );
  }
}
