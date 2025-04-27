import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/widgets/custom_error_widget.dart';
import '/widgets/custom_shimmer.dart';
import '/controllers/discussion_controller.dart';
import '/res/controllers_key.dart';
import '/widgets/discussion_forum/discussion_category_item.dart';
import '/models/discussion_category.dart';
import '/global_configs.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/my_divider.dart';

class DiscussionCategoriesListScreen extends StatefulWidget {
  const DiscussionCategoriesListScreen({super.key});

  @override
  State<DiscussionCategoriesListScreen> createState() =>
      _DiscussionCategoriesListScreenState();
}

class _DiscussionCategoriesListScreenState
    extends State<DiscussionCategoriesListScreen> {
  bool isLoading = false;
  bool isFailed = false;

  List<DiscussionCategory> categories = [];

  DiscussionController discussionController = Get.find(
    tag: ControllersKey.discussionControllerKey,
  );

  @override
  void initState() {
    super.initState();

    fetchDiscussionCategories();
  }

  Future<void> fetchDiscussionCategories() async {
    setState(() {
      isLoading = true;
      isFailed = false;
    });

    await discussionController.getCategories().then(
      (value) {
        if (value != null) {
          categories = value;
        } else {
          isFailed = true;
        }
      },
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(
        icon: Icons.menu,
        onTap: () {},
        hasShadow: true,
      ),
      backgroundColor: theme.colorScheme.primary,
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchDiscussionCategories();
        },
        child: ListView(
          shrinkWrap: true,
          padding: globalPadding * 10,
          children: [
            if (isLoading) ...[
              const SizedBox(height: 18),
              CustomShimmer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 48,
                      width: 250,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface,
                        borderRadius: globalBorderRadius,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Column(
                children: List.generate(
                  3,
                  (index) {
                    return CustomShimmer(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: 100,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.onSurface,
                                        borderRadius: globalBorderRadius * 2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: 200,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.onSurface,
                                        borderRadius: globalBorderRadius * 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onSurface,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else if (isFailed)
              CustomErrorWidget(
                onTap: () async {
                  await fetchDiscussionCategories();
                },
              )
            else ...[
              const SizedBox(height: 18),
              Center(
                child: Text(
                  "موضوع ها",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w300,
                    color: theme.colorScheme.secondary.withValues(alpha: 0.4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              MyDivider(
                color: theme.colorScheme.secondary.withValues(alpha: 0.55),
                height: 1,
                thickness: 1,
              ),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return DiscussionForumItem(category: categories[index]);
                },
                separatorBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      MyDivider(
                        color:
                            theme.colorScheme.secondary.withValues(alpha: 0.55),
                        height: 1,
                        thickness: 1,
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
              const SizedBox(height: 100),
            ]
          ],
        ),
      ),
    );
  }
}
