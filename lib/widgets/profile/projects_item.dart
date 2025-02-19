import 'package:flutter/material.dart';

import '/models/project.dart';
import '/global_configs.dart';
import '../my_divider.dart';

class ProjectsItem extends StatelessWidget {
  final Project project;
  const ProjectsItem({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      margin: globalPadding * 6,
      padding: globalPadding * 7,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: globalBorderRadius * 3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 10,),
          Image.asset("assets/images/image.png",),
          const SizedBox(height: 36,),
          Text(project.profileUser?.firstName ?? "", style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),),
          const SizedBox(height: 6,),
          MyDivider(color: theme.colorScheme.onSurface,
            height: 1, thickness: 1,
          ),
          const SizedBox(height: 4,),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(project.state, style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w300
                    ),),
                    //FIXME : ask this
                    // Text("نظر ادمین کناف کار", style: theme.textTheme.bodyMedium?.copyWith(
                    //     color: theme.colorScheme.onPrimary,
                    //     fontWeight: FontWeight.w300
                    // ),)
                  ],
                ),
              ),
              const SizedBox(width: 2,),
              CircleAvatar(
                backgroundColor: theme.colorScheme.primary,
                child: Image.asset("assets/images/master_user.png",
                  width: 36, height: 36,
                ),
              ),
            ],
          ),
          const SizedBox(height: 44,)
        ],
      ),
    );
  }
}
