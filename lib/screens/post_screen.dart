import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '/widgets/post/post_item_section.dart';
import '/controllers/post_controller.dart';
import '/res/controllers_key.dart';
import '/widgets/custom_appbar.dart';

class PostScreen extends StatefulWidget {
  final int postIndex;

  const PostScreen({
    super.key,
    required this.postIndex,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  PostController postController = Get.find(
    tag: ControllersKey.postControllerKey,
  );

  final ItemScrollController itemScrollController = ItemScrollController();

  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  Worker? itemIndexWorker;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemScrollController.jumpTo(index: widget.postIndex);

      itemPositionsListener.itemPositions.addListener(() {
        addItemPositionListener();
      });

      postController.initVideoControllers();
    });
  }

  @override
  void dispose() {
    super.dispose();

    itemIndexWorker?.dispose();

    for (var videoControllers in postController.videoControllers) {
      videoControllers.$1.forEach((_, controller) {
        controller.dispose();
      });
    }
  }

  void addItemPositionListener() {
    final positions = itemPositionsListener.itemPositions.value;

    // Select items visible in viewport
    final visibleItems = positions
        .where((item) => item.itemTrailingEdge > 0 && item.itemLeadingEdge < 1)
        .toList();

    if (visibleItems.isEmpty) return;

    // Find the item whose leading edge is closest to the top (0.0)
    visibleItems.sort((a, b) => (a.itemLeadingEdge - 0.0)
        .abs()
        .compareTo((b.itemLeadingEdge - 0.0).abs()));

    final currentIndex = visibleItems.first.index;

    if (currentIndex == 0) return;

    final postIndex = currentIndex - 1;

    if (postController.postCurrentIndex.value != postIndex) {
      postController.postCurrentIndex.value = postIndex;

      postController.currentPlayedVideoController?.pause();

      final (controllers, carousalIndex, isVideo) =
          postController.videoControllers[postIndex];

      if (controllers.isNotEmpty && isVideo) {
        controllers[carousalIndex]?.play();
        postController.currentPlayedVideoController =
            controllers[carousalIndex];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: CustomAppbar(
        iconAsset: "assets/icons/arrow_back_19.png",
        onTap: () {
          for (var videoControllers in postController.videoControllers) {
            videoControllers.$1.forEach((_, controller) {
              controller.dispose();
            });
          }
          Get.back();
        },
        hasShadow: true,
      ),
      body: SafeArea(
        bottom: true,
        top: false,
        child: ScrollablePositionedList.builder(
          itemCount: postController.posts.length + 1,
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
          itemBuilder: (context, index) {
            if (index == 0) return const SizedBox(height: 25);
            return PostItemSection(
              index: index - 1,
              post: postController.posts[index - 1],
            );
          },
        ),
      ),
    );
  }
}
