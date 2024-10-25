import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/global_configs.dart';
import 'package:kanaf/models/poster.dart';
import 'package:kanaf/screens/details_screen.dart';
import 'package:kanaf/widgets/my_divider.dart';

class PosterItem extends StatelessWidget {
  final Poster poster;
  const PosterItem({super.key, required this.poster});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return InkWell(
      onTap: (){
        Get.to(DetailsScreen(title: poster.title,));
      },
      child: SizedBox(
        height: 128,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(poster.title, style: theme.textTheme.titleLarge,),
                        Text(poster.address, style: theme.textTheme.bodyMedium,)
                      ],
                    ),
                  ),
                  Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: globalBorderRadius * 2,
                      ),
                      child: Image.asset("assets/images/logo_test.jpg", width: 150,fit: BoxFit.cover,)
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8,),
            MyDivider(color: theme.colorScheme.inverseSurface, height: 1, thickness: 0.5),
          ],
        ),
      ),
    );
  }
}
