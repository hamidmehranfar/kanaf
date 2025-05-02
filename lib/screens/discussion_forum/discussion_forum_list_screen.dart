import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '/screens/discussion_forum/create_discussion_screen.dart';
import '/widgets/discussion_forum/discussion_forum_item.dart';
import '/global_configs.dart';
import '/widgets/custom_shimmer.dart';
import '/widgets/my_divider.dart';
import '/controllers/discussion_controller.dart';
import '/models/discussion.dart';
import '/models/discussion_category.dart';
import '/res/controllers_key.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/custom_error_widget.dart';

class DiscussionForumListScreen extends StatefulWidget {
  final DiscussionCategory category;

  const DiscussionForumListScreen({
    super.key,
    required this.category,
  });

  @override
  State<DiscussionForumListScreen> createState() =>
      _DiscussionForumListScreenState();
}

class _DiscussionForumListScreenState extends State<DiscussionForumListScreen> {
  bool isLoading = false;
  bool isFailed = false;

  DiscussionController discussionController = Get.find(
    tag: ControllersKey.discussionControllerKey,
  );

  @override
  void initState() {
    super.initState();

    discussionController.pagingController = PagingController(firstPageKey: 1);
    discussionController.pagingController!
        .addPageRequestListener((pageKey) async {
      await fetchCategoryMessages(pageKey);
    });
  }

  Future<void> fetchCategoryMessages(int pageKey) async {
    final newItems = await discussionController.getDiscussions(
      categoryId: widget.category.id,
      pageKey: pageKey,
    );
    if (newItems == null) {
      discussionController.pagingController!.error =
          discussionController.apiMessage;
    } else {
      final lastPage = newItems.length < 10;
      if (lastPage) {
        discussionController.pagingController!.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        discussionController.pagingController!
            .appendPage(newItems, nextPageKey);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(
        onTap: () {
          Navigator.of(context).pop();
        },
        iconAsset: "assets/icons/arrow_back_19.png",
        hasShadow: true,
      ),
      backgroundColor: theme.colorScheme.primary,
      body: RefreshIndicator(
        onRefresh: () async {
          discussionController.pagingController!.refresh();
        },
        child: Stack(
          children: [
            Padding(
              padding: globalPadding * 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  Text(
                    widget.category.name,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: theme.colorScheme.tertiary,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 16),
                  MyDivider(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.55),
                    height: 1,
                    thickness: 1,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: PagedListView.separated(
                      pagingController: discussionController.pagingController!,
                      separatorBuilder: (context, index) {
                        return Column(
                          children: [
                            const SizedBox(height: 10),
                            MyDivider(
                              color: theme.colorScheme.secondary
                                  .withValues(alpha: 0.55),
                              height: 1,
                              thickness: 1,
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                      builderDelegate: PagedChildBuilderDelegate(
                        itemBuilder:
                            (BuildContext context, Discussion item, int index) {
                          return DiscussionForumItem(discussion: item);
                        },
                        noMoreItemsIndicatorBuilder: (context) {
                          return const SizedBox(height: 36);
                        },
                        noItemsFoundIndicatorBuilder: (context) {
                          return const Center(
                            child: Text("موردی یافت نشد"),
                          );
                        },
                        firstPageErrorIndicatorBuilder: (context) {
                          return CustomErrorWidget(onTap: () {
                            discussionController.pagingController!.refresh();
                          });
                        },
                        firstPageProgressIndicatorBuilder: (context) {
                          return CustomShimmer(
                            child: Column(
                              children: [
                                Container(
                                  margin: globalPadding * 6,
                                  height: 400,
                                  decoration: BoxDecoration(
                                    borderRadius: globalBorderRadius * 3,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            Positioned(
              bottom: 120,
              left: 16,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return CreateDiscussionScreen(
                          categoryId: widget.category.id,
                        );
                      },
                    ),
                  ).then((value) {
                    if (value != null && value is bool && value) {
                      discussionController.pagingController!.refresh();
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 6,
                    bottom: 6,
                    left: 4,
                    right: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: globalBorderRadius * 3,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "گفتگوی جدید",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 8,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.add, size: 15),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
