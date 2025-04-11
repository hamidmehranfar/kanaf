import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/models/master.dart';
import 'package:kanaf/widgets/custom_cached_image.dart';

import '/screens/details_screen.dart';
import '/global_configs.dart';
import '/res/enums/master_services.dart';

class MasterServicesItems extends StatelessWidget {
  final MasterServices service;
  final Master master;

  const MasterServicesItems({
    super.key,
    required this.service,
    required this.master,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: () {
        Get.to(
          DetailsScreen(
            id: master.id,
            isComeFromProfile: false,
          ),
        );
      },
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: globalBorderRadius * 10,
          color: theme.colorScheme.primary,
        ),
        child: Column(
          children: [
            ClipOval(
              child: CustomCachedImage(
                url: master.user.avatar ?? '',
                width: 95,
                height: 87,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) {
                  return Icon(
                    Icons.star,
                    color: theme.colorScheme.tertiary,
                    size: 12,
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
            Text(
              master.user.firstName ?? '',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            // Container(
            //   padding: EdgeInsets.zero,
            //   width: 80,
            //   height: 20,
            //   decoration: BoxDecoration(
            //     color: theme.colorScheme.tertiary.withOpacity(0.75),
            //     borderRadius: globalBorderRadius * 3,
            //     border: Border.all(
            //         color: theme.colorScheme.onSurface.withOpacity(0.5)),
            //     boxShadow: [
            //       BoxShadow(
            //         color: theme.colorScheme.onPrimary,
            //         offset: const Offset(-10, -15),
            //         blurRadius: 38,
            //       )
            //     ],
            //   ),
            //   child: Center(
            //     child: Text(
            //       "بررسی سابقه",
            //       style: theme.textTheme.labelMedium
            //           ?.copyWith(color: theme.colorScheme.onPrimary),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
