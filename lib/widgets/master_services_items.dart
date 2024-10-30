import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kanaf/screens/services_list_screen.dart';
import '/global_configs.dart';
import '/models/enums/master_services.dart';

class MasterServicesItems extends StatelessWidget {
  final MasterServices service;
  const MasterServicesItems({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: globalPadding * 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(convertServiceToString(service), style: theme.textTheme.headlineSmall,),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context){
                      return ServicesListScreen(service : service);
                    })
                  );
                },
                child: Row(
                  children: [
                    Text("مشاهده همه", style: theme.textTheme.titleMedium,),
                    const SizedBox(width: 4,),
                    const Icon(Iconsax.arrow_left_2)
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 8,),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: globalPadding*2,
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            separatorBuilder: (context, index){
              return const SizedBox(width: 10,);
            },
            itemBuilder: (context, index){
              return Container(
                padding: globalAllPadding * 2,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: globalBorderRadius * 2,
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 2
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/user.png",
                      fit: BoxFit.cover,width: 50,height: 50,),
                    Text(
                      "حمید مهران فر",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge!.copyWith(color: Colors.black),
                    ),
                  ],
                ),
              );
            }
          ),
        )
      ],
    );
  }
}
