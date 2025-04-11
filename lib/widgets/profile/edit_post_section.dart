import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '/controllers/post_controller.dart';
import '/res/controllers_key.dart';
import '/widgets/my_divider.dart';
import '/global_configs.dart';
import '/res/app_colors.dart';
import '/models/post.dart';
import '/models/post_item.dart';
import '../button_item.dart';
import '../custom_cached_image.dart';

class EditPostSection extends StatefulWidget {
  final Post post;
  final bool isMaster;

  const EditPostSection({
    super.key,
    required this.post,
    required this.isMaster,
  });

  @override
  State<EditPostSection> createState() => _EditPostSectionState();
}

class _EditPostSectionState extends State<EditPostSection> {
  PostController postController = Get.find(
    tag: ControllersKey.postControllerKey,
  );

  TextEditingController captionTextController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initEditValues();
  }

  void initEditValues() {
    postController.initPostValues();

    List<PostItem> items = widget.post.items;
    for (int i = 0; i < items.length; i++) {
      postController.networkImages.add(items[i].file);
    }

    captionTextController.text = widget.post.caption;
  }

  // Future<void> onPickFile(int index) async {
  //   if (isLoading) return;
  //   if (postController.images[index] == null &&
  //       postController.networkImages.length <= index) {
  //     setState(() {
  //       postController.picturesLoading[index] = true;
  //     });
  //     FilePickerResult? result =
  //         await FilePicker.platform.pickFiles(allowMultiple: true);
  //
  //     if (result != null) {
  //       List<File> files = result.paths.map((path) => File(path!)).toList();
  //       postController.images[index] = files.isNotEmpty ? files[0] : null;
  //     } else {
  //       // User canceled the picker
  //     }
  //
  //     setState(() {
  //       postController.picturesLoading[index] = false;
  //     });
  //   } else if (postController.networkImages.length > index) {
  //     setState(() {
  //       postController.networkImages.removeAt(index);
  //     });
  //   } else {
  //     setState(() {
  //       postController.images[index] = null;
  //     });
  //   }
  // }

  Future<void> editPost() async {
    if (captionTextController.text.isEmpty) {
      //FIXME : show error
      return;
    }
    if (widget.post.caption == captionTextController.text) {
      Get.back(result: false);
      return;
    }

    setState(() {
      isLoading = true;
    });

    await postController
        .editPostCaption(
      urlRequest: widget.isMaster ? "master" : "employer",
      postId: widget.post.id,
      caption: captionTextController.text,
    )
        .then(
      (value) {
        if (value) {
          Get.back(result: true);
        } else {
          //FIXME : show error
        }
      },
    );

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deletePost() async {
    setState(() {
      isLoading = true;
    });

    await postController
        .deletePost(
      postId: widget.post.id,
      urlRequest: widget.isMaster ? "master" : "employer",
    )
        .then((value) {
      if (value) {
        Get.back(result: true);
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 30),
          SizedBox(
            height: 330,
            child: GridView.builder(
              padding: globalPadding * 9,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                mainAxisExtent: 95,
              ),
              itemBuilder: (context, index) {
                // return Stack(
                //   children: [
                return postController.picturesLoading[index]
                    ? Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.onPrimary,
                        ),
                      )
                    : postController.networkImages.length > index
                        ? ClipRRect(
                            borderRadius: globalBorderRadius * 10,
                            child: CustomCachedImage(
                              url: postController.networkImages[index],
                              width: 105,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: 120,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: globalBorderRadius * 10,
                              color: theme.colorScheme.secondary
                                  .withValues(alpha: 0.4),
                            ),
                          );
                // Positioned(
                //   right: 0,
                //   bottom: 25,
                //   child: Container(
                //     width: 27,
                //     height: 27,
                //     padding: const EdgeInsets.all(2),
                //     decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: theme.colorScheme.onPrimary),
                //     child: Container(
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: theme.colorScheme.secondary,
                //       ),
                //       child: InkWell(
                //         onTap: () async {
                //           await onPickFile(index);
                //         },
                //         child: Icon(
                //           (postController.images[index] == null ||
                //                   postController.networkImages.length <=
                //                       index)
                //               ? Icons.add
                //               : Icons.close,
                //           size: 14,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                //   ],
                // );
              },
            ),
          ),
          // const SizedBox(height: 18),
          // if (postController.createPostLoading)
          //   SpinKitThreeBounce(
          //     size: 14,
          //     color: theme.colorScheme.onSecondary,
          //   )
          // else
          //   SmallButton(
          //     text: "آپلود عکس یا ویدئو",
          //     textColor: theme.colorScheme.onSecondary,
          //     width: 142,
          //     height: 27,
          //     shadow: [
          //       BoxShadow(
          //         color: theme.colorScheme.onPrimary,
          //         offset: const Offset(-20, -10),
          //         blurRadius: 25,
          //         spreadRadius: -10,
          //       ),
          //       BoxShadow(
          //         color: theme.colorScheme.onSecondary,
          //         offset: const Offset(20, 10),
          //         blurRadius: 20,
          //         spreadRadius: -5,
          //       ),
          //     ],
          //     onTap: () async {},
          //   ),
          // const SizedBox(height: 25),
          Container(
            height: 51,
            padding: const EdgeInsets.only(bottom: 5),
            margin: globalPadding * 10,
            decoration: BoxDecoration(
              color: AppColors.textFieldColor.withValues(alpha: 0.78),
              borderRadius: globalBorderRadius * 4,
            ),
            child: Row(
              children: [
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    controller: captionTextController,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.surface,
                    ),
                    scrollPadding: const EdgeInsets.only(bottom: 200),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "کپشن",
                      hintStyle: theme.textTheme.labelMedium?.copyWith(
                        color:
                            theme.colorScheme.onPrimary.withValues(alpha: 0.38),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8)
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: globalPadding * 5,
            child: const MyDivider(
              color: Color(0xFF333333),
              height: 1,
              thickness: 1,
            ),
          ),
          const SizedBox(height: 12),
          if (isLoading)
            SpinKitThreeBounce(
              size: 14,
              color: theme.colorScheme.onPrimary,
            )
          else
            ButtonItem(
              width: 180,
              height: 40,
              onTap: () async {
                await editPost();
              },
              title: "ذخیره",
              color: theme.colorScheme.tertiary,
            ),
          const SizedBox(height: 8),
          if (isLoading)
            SpinKitThreeBounce(
              size: 14,
              color: theme.colorScheme.onPrimary,
            )
          else
            ButtonItem(
              width: 180,
              height: 40,
              onTap: () async {
                await deletePost();
              },
              title: "حذف پست",
              color: theme.colorScheme.secondary,
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
