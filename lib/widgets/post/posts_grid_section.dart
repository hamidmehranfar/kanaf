import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '/controllers/post_controller.dart';
import '/res/controllers_key.dart';
import '/global_configs.dart';
import '/models/post_item.dart';
import '/screens/post_screen.dart';
import '../custom_cached_image.dart';
import '../custom_error_widget.dart';
import '../custom_shimmer.dart';
import '../profile/edit_post_section.dart';

class PostsGridSection extends StatefulWidget {
  final bool isLoading;
  final bool isFailed;
  final bool isComeFromProfile;
  final Function() onTap;
  final List<Uint8List?> videosFrame;
  final EdgeInsets? padding;

  const PostsGridSection({
    super.key,
    required this.isLoading,
    required this.isFailed,
    required this.onTap,
    required this.isComeFromProfile,
    required this.videosFrame,
    this.padding,
  });

  @override
  State<PostsGridSection> createState() => _PostsGridSectionState();
}

class _PostsGridSectionState extends State<PostsGridSection> {
  PostController postController = Get.find(
    tag: ControllersKey.postControllerKey,
  );

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return widget.isLoading
        ? GridView.builder(
            padding: widget.padding,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return CustomShimmer(
                child: Container(
                  color: theme.colorScheme.onSurface,
                ),
              );
            },
          )
        : widget.isFailed
            ? Center(
                child: CustomErrorWidget(
                  onTap: () async {
                    await widget.onTap();
                  },
                ),
              )
            : MasonryGridView.count(
                padding: widget.padding,
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                itemCount: postController.posts.length,
                itemBuilder: (BuildContext context, int index) {
                  PostItem? item = postController.posts[index].items.isNotEmpty
                      ? postController.posts[index].items[0]
                      : null;

                  Widget? gridItem;

                  if (widget.videosFrame[index] == null) {
                    gridItem = CustomCachedImage(
                      url: item?.file ?? '',
                    );
                  } else {
                    gridItem = Image.memory(widget.videosFrame[index]!);
                  }

                  if (widget.isComeFromProfile) {
                    return InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: theme.colorScheme.primary,
                              child: EditPostSection(
                                post: postController.posts[index],
                              ),
                            );
                          },
                        ).then((value) async {
                          if (value != null && value) {
                            await widget.onTap();
                          }
                        });
                      },
                      child: Stack(
                        children: [
                          gridItem,
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: globalBorderRadius * 2,
                              ),
                              child: Image.asset(
                                "assets/images/edit-pen.png",
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return InkWell(
                    onTap: () {
                      postController.postCurrentIndex.value = index;
                      Get.to(
                        PostScreen(
                          postIndex: index + 1,
                          key: widget.key,
                        ),
                      );
                    },
                    child: gridItem,
                  );
                },
              );
  }
}
