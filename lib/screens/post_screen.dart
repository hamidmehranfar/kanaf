import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/widgets/post/post_item_section.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemScrollController.jumpTo(index: widget.postIndex);
    });
  }

  // Future<void> addComment() async {
  //   var theme = Theme.of(context);
  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(builder: (context, setDialogState) {
  //         return Dialog(
  //           child: Padding(
  //             padding: globalPadding * 4,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 const SizedBox(height: 24),
  //                 Text(
  //                   "افزودن نظر",
  //                   style: theme.textTheme.titleLarge,
  //                 ),
  //                 const SizedBox(height: 16),
  //                 CustomTextField(
  //                   controller: commentController,
  //                   hintText: "نظر خود را وارد کنید",
  //                   maxLines: 3,
  //                 ),
  //                 const SizedBox(height: 56),
  //                 isCreateCommentsLoading
  //                     ? SpinKitThreeBounce(
  //                         size: 16,
  //                         color: theme.colorScheme.primary,
  //                       )
  //                     : Center(
  //                         child: FilledButton(
  //                           onPressed: () async {
  //                             setDialogState(() {
  //                               isCreateCommentsLoading = true;
  //                             });
  //
  //                             setDialogState(() {
  //                               isCreateCommentsLoading = false;
  //                             });
  //                           },
  //                           style: FilledButton.styleFrom(
  //                             backgroundColor: theme.colorScheme.primary,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: globalBorderRadius * 2,
  //                             ),
  //                             fixedSize: const Size.fromWidth(160),
  //                           ),
  //                           child: Text(
  //                             'ثبت نظر',
  //                             style: theme.textTheme.titleMedium?.copyWith(
  //                               color: theme.colorScheme.onPrimary,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                 const SizedBox(height: 24),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  //     },
  //   ).then(
  //     (value) {
  //       if (value) {
  //         Get.snackbar(
  //           'موفق',
  //           'نظر با موفقیت ساخته شد',
  //         );
  //       } else if (!value) {
  //         Get.snackbar(
  //           'نا موفق',
  //           postController.apiMessage,
  //         );
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: CustomAppbar(
        iconAsset: "assets/icons/arrow_back_19.png",
        onTap: () => Get.back(),
      ),
      body: SafeArea(
        bottom: true,
        top: false,
        child: ScrollablePositionedList.builder(
          itemCount: postController.posts.length,
          itemScrollController: itemScrollController,
          itemBuilder: (context, index) {
            return PostItemSection(
              post: postController.posts[index],
            );
          },
        ),
      ),
    );
  }
}
