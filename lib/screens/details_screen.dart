import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:kanaf/screens/profile/create_post_story_screen.dart';
import 'package:path_provider/path_provider.dart';

import '/res/enums/media_type.dart';
import '/widgets/shadow_button.dart';
import '/screens/post_screen.dart';
import '/widgets/profile/edit_post_section.dart';
import '/controllers/master_controller.dart';
import '/controllers/post_controller.dart';
import '/controllers/project_controller.dart';
import '/models/post_item.dart';
import '/widgets/custom_cached_image.dart';
import '/widgets/custom_error_widget.dart';
import '/widgets/custom_shimmer.dart';
import '/res/controllers_key.dart';
import '/screens/create_project_screen.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/my_divider.dart';
import '/global_configs.dart';

class DetailsScreen extends StatefulWidget {
  final int id;
  final bool isComeFromProfile;
  final bool? isMaster;

  const DetailsScreen({
    super.key,
    required this.id,
    required this.isComeFromProfile,
    this.isMaster,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isLoading = true;
  bool isProfileFailed = false;

  bool isPostsFailed = false;

  List<Uint8List?> videosFirstFrame = [];

  ProjectController profileController = Get.put(
    ProjectController(),
    tag: ControllersKey.profileControllerKey,
  );

  PostController postController = Get.find(
    tag: ControllersKey.postControllerKey,
  );

  MasterController masterController = Get.find(
    tag: ControllersKey.masterControllerKey,
  );

  @override
  void initState() {
    super.initState();
    _fetchProfileAndPosts();
  }

  Future<void> _fetchProfileAndPosts() async {
    setState(() {
      isLoading = true;
      isProfileFailed = false;
      isPostsFailed = false;
    });

    String urlRequest = "";
    if (widget.isMaster ?? true) {
      urlRequest = "master";
    } else {
      urlRequest = "employer";
    }

    videosFirstFrame.clear();

    await masterController
        .getMasterOrEmployer(
      id: widget.id,
      urlRequest: urlRequest,
    )
        .then((value) async {
      if (!value) {
        isProfileFailed = true;
      }
    });

    await postController
        .getPosts(
      profileId: widget.id,
      urlRequest: urlRequest,
    )
        .then((value) async {
      if (!value) {
        isPostsFailed = true;
      } else {
        for (var post in postController.posts) {
          if (post.items.isNotEmpty) {
            if (post.items[0].itemType == MediaType.video) {
              videosFirstFrame.add(await getFirstFrame(post.items[0].file));
            } else {
              videosFirstFrame.add(null);
            }
          }
        }
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  Future<Uint8List?> getFirstFrame(String videoUrl) async {
    try {
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/temp_video.mp4';

      // Download video using Dio
      Dio dio = Dio();
      await dio.download(videoUrl, filePath);

      // Generate thumbnail from the downloaded file
      final thumbnail = await VideoThumbnail.thumbnailData(
        video: filePath,
        imageFormat: ImageFormat.PNG,
        maxWidth: 128,
        quality: 75,
      );

      return thumbnail;
    } catch (e) {
      return null;
    }
  }

  TextStyle? getStyle(ThemeData theme) {
    if (widget.isComeFromProfile) {
      return theme.textTheme.titleMedium?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
      );
    } else {
      return theme.textTheme.titleMedium;
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(
        iconAsset: "assets/icons/arrow_back_19.png",
        onTap: () => Get.back(),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _fetchProfileAndPosts();
          },
          child: Padding(
            padding: globalPadding * 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isLoading)
                  CustomShimmer(
                      child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: globalBorderRadius,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 40,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: globalBorderRadius,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: globalBorderRadius,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 40,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: globalBorderRadius,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: globalBorderRadius,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 40,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: globalBorderRadius,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 80,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: globalBorderRadius,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: globalBorderRadius,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 12),
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 60,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: globalBorderRadius,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      )
                    ],
                  ))
                else if (isProfileFailed)
                  Center(
                    child: CustomErrorWidget(onTap: () async {
                      await _fetchProfileAndPosts();
                    }),
                  )
                else ...[
                  const SizedBox(height: 23),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Column(
                            //       children: [
                            //         Text(
                            //           postController.posts.length
                            //               .toString()
                            //               .toPersianDigit(),
                            //           style: getStyle(theme),
                            //         ),
                            //         Text(
                            //           "پست",
                            //           style: getStyle(theme),
                            //         ),
                            //       ],
                            //     ),
                            //     Column(
                            //       children: [
                            //         Text(
                            //           "3".toPersianDigit(),
                            //           style: getStyle(theme),
                            //         ),
                            //         Text(
                            //           "رتبه",
                            //           style: getStyle(theme),
                            //         ),
                            //       ],
                            //     ),
                            //     Column(
                            //       children: [
                            //         Text(
                            //           "3".toPersianDigit(),
                            //           style: getStyle(theme),
                            //         ),
                            //         Text(
                            //           "رتبه",
                            //           style: getStyle(theme),
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // ),
                            if (!widget.isComeFromProfile) ...[
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ShadowButton(
                                    onTap: () {},
                                    width: 100,
                                    text: "ارتباط با استاد کار",
                                  ),
                                  ShadowButton(
                                    onTap: () {
                                      Get.to(const CreateProjectScreen());
                                    },
                                    width: 100,
                                    text: "ثبت پروژه با استادکار",
                                  ),
                                ],
                              ),
                            ]
                          ],
                        ),
                      ),
                      const SizedBox(width: 11),
                      Column(
                        children: [
                          ClipOval(
                            child: CustomCachedImage(
                              url: masterController.master?.user.avatar ?? '',
                              width: 88,
                              height: 88,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 2),
                          SizedBox(
                            width: 90,
                            child: Text(
                              "${masterController.master?.user.firstName ?? ''} ${masterController.master?.user.lastName ?? ''}",
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
                if (masterController.master?.bio?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 14),
                  Text(
                    masterController.master?.bio ?? '',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
                if (widget.isComeFromProfile && !isLoading) ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 0.3,
                        child: FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.colorScheme.tertiary,
                            fixedSize: const Size(134, 36),
                          ),
                          child: Text(
                            "چت",
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilledButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const CreatePostStoryScreen(
                                  isStory: false,
                                );
                              },
                            ),
                          ).then((value) async {
                            if (value != null && value) {
                              await _fetchProfileAndPosts();
                            }
                          });
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.colorScheme.tertiary,
                          fixedSize: const Size(134, 36),
                        ),
                        child: Text(
                          "پست جدید",
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 10),
                MyDivider(
                  color: theme.colorScheme.onSurface,
                  height: 1,
                  thickness: 1,
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: isLoading
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                      : isPostsFailed
                          ? Center(
                              child: CustomErrorWidget(
                                onTap: () async {
                                  await _fetchProfileAndPosts();
                                },
                              ),
                            )
                          : MasonryGridView.count(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              itemCount: postController.posts.length,
                              itemBuilder: (BuildContext context, int index) {
                                PostItem? item =
                                    postController.posts[index].items.isNotEmpty
                                        ? postController.posts[index].items[0]
                                        : null;

                                Widget? gridItem;

                                if (videosFirstFrame[index] == null) {
                                  gridItem = CustomCachedImage(
                                    url: item?.file ?? '',
                                  );
                                } else {
                                  gridItem =
                                      Image.memory(videosFirstFrame[index]!);
                                }

                                if (widget.isComeFromProfile) {
                                  return InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            backgroundColor:
                                                theme.colorScheme.primary,
                                            child: EditPostSection(
                                              isMaster:
                                                  widget.isMaster ?? false,
                                              post: postController.posts[index],
                                            ),
                                          );
                                        },
                                      ).then((value) async {
                                        if (value != null && value) {
                                          await _fetchProfileAndPosts();
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
                                              borderRadius:
                                                  globalBorderRadius * 2,
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
                                    Get.to(
                                      PostScreen(
                                        postId: postController.posts[index].id,
                                      ),
                                    );
                                  },
                                  child: gridItem,
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
