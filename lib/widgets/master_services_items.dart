import 'package:flutter/material.dart';
import '/../screens/services_list_screen.dart';
import '/global_configs.dart';
import '/models/enums/master_services.dart';

class MasterServicesItems extends StatelessWidget {
  final MasterServices service;
  const MasterServicesItems({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return const ServicesListScreen(service: MasterServices.master);
        }));
      },
      child: Container(
        width: 90,
        height: 170,
        decoration: BoxDecoration(
          borderRadius: globalBorderRadius * 10,
          color: theme.colorScheme.primary
        ),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset("assets/images/master_user.png",
                width: 87,height: 87,fit: BoxFit.fill,)
            ),
            const SizedBox(height: 6,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index){
               return Icon(Icons.star, color: theme.colorScheme.tertiary,
                 size: 12,
               );
             }),
            ),
            const SizedBox(height: 6,),
            Text("علی موحدی", style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onPrimary
            ),),
            Container(
                padding: EdgeInsets.zero,
                width : 70,
                height: 20,
                decoration: BoxDecoration(
                    color: theme.colorScheme.tertiary.withOpacity(0.75),
                    borderRadius: globalBorderRadius * 3,
                    border: Border.all(
                        color: theme.colorScheme.onSurface.withOpacity(0.5)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.onPrimary,
                        offset: const Offset(-10, -15),
                        blurRadius: 38,
                      )
                    ]
                ),
                child: Center(
                  child: Text("بررسی سابقه", style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onPrimary
                  ),),
                )
            )
          ],
        ),
      ),
    );
  }
}
