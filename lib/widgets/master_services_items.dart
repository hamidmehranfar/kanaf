import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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
          height: 50,
          child: ListView.separated(
            padding: globalPadding*2,
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            separatorBuilder: (context, index){
              return const SizedBox(width: 10,);
            },
            itemBuilder: (context, index){
              return Container(
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: globalBorderRadius * 2,
                  color: theme.colorScheme.secondary.withOpacity(0.3)
                ),
                child: Center(
                  child: Text(
                    "حمید مهران فر",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge!.copyWith(color: Colors.black),
                  ),
                ),
              );
            }
          ),
        )
      ],
    );
  }
}
