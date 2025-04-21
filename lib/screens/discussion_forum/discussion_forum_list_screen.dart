import 'package:flutter/material.dart';
import 'package:kanaf/global_configs.dart';
import 'package:kanaf/widgets/custom_appbar.dart';
import 'package:kanaf/widgets/my_divider.dart';

class DiscussionForumListScreen extends StatefulWidget {
  const DiscussionForumListScreen({super.key});

  @override
  State<DiscussionForumListScreen> createState() =>
      _DiscussionForumListScreenState();
}

class _DiscussionForumListScreenState extends State<DiscussionForumListScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(
        icon: Icons.menu,
        onTap: () {},
      ),
      body: ListView(
        shrinkWrap: true,
        padding: globalPadding * 10,
        children: [
          const SizedBox(height: 18),
          Text(
            "موضوع ها",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w300,
              color: theme.colorScheme.secondary.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 18),
          MyDivider(
            color: theme.colorScheme.secondary.withValues(alpha: 0.55),
            height: 1,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
