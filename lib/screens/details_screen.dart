import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kanaf/screens/post_screen.dart';
import 'package:get/get.dart';

import '/widgets/profile/edit_post_section.dart';
import '/controllers/master_controller.dart';
import '/controllers/post_controller.dart';
import '/controllers/project_controller.dart';
import '/models/post_item.dart';
import '/widgets/custom_cached_image.dart';
import '/widgets/custom_error_widget.dart';
import '/widgets/custom_shimmer.dart';
import '/res/controllers_key.dart';
import '/res/app_colors.dart';
import '/screens/create_project_screen.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/my_divider.dart';
import '/global_configs.dart';

class DetailsScreen extends StatefulWidget {
  final int id;
  final bool isComeFromProfile;

  const DetailsScreen({
    super.key,
    required this.id,
    required this.isComeFromProfile,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isLoading = true;
  bool isProfileFailed = false;

  bool isPostsFailed = false;

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

    await masterController.getMaster(widget.id).then((value) async {
      if (!value) {
        isProfileFailed = true;
      }
    });

    await postController.getPosts(widget.id).then((value) {
      if (!value) {
        isPostsFailed = true;
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  Widget getButtons({
    required String text,
    required Function() onTap,
    double? width,
  }) {
    var theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.tertiary.withValues(alpha: 0.75),
          borderRadius: globalBorderRadius * 3,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onPrimary,
              offset: const Offset(-15, -10),
              blurRadius: 50,
            )
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.labelSmall,
          ),
        ),
      ),
    );
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
                                  getButtons(
                                    text: "ارتباط با کارفرما",
                                    onTap: () {},
                                    width: 100,
                                  ),
                                  getButtons(
                                    text: "ثبت پروژه با کنافکار",
                                    onTap: () {
                                      Get.to(const CreateProjectScreen());
                                    },
                                    width: 100,
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
                          Stack(
                            children: [
                              Container(
                                padding: globalAllPadding,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: widget.isComeFromProfile
                                        ? AppColors.avatarBorderColor
                                        : AppColors.sideColor,
                                    width: 5,
                                  ),
                                ),
                                child: ClipOval(
                                  child: CustomCachedImage(
                                    url: masterController.master?.user.avatar ??
                                        '',
                                    width: 88,
                                    height: 88,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: widget.isComeFromProfile
                                    ? Image.asset(
                                        "assets/images/edit-pen.png",
                                        width: 30,
                                        height: 30,
                                      )
                                    : Container(
                                        padding: globalAllPadding,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.sideColor,
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            masterController.master?.bio ?? '',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // MyDivider(
                  //   color: theme.colorScheme.onSurface,
                  //   height: 1,
                  //   thickness: 1,
                  // ),
                  // const SizedBox(height: 6,),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: List.generate(4, (index){
                  //     return Container(
                  //       width: 55,
                  //       height: 55,
                  //       decoration: BoxDecoration(
                  //           shape: BoxShape.circle,
                  //           color: theme.colorScheme.inverseSurface
                  //       ),
                  //     );
                  //   }),
                  // ),
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

                                Widget itemImage = CustomCachedImage(
                                  url: item?.file ?? '',
                                );

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
                                        itemImage,
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
                                  child: itemImage,
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ));
  }
}
