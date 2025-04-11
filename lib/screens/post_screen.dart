import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '/controllers/size_controller.dart';
import '/widgets/my_divider.dart';
import '/widgets/colapsing_text.dart';
import '/widgets/custom_text_field.dart';
import '/models/post_comment.dart';
import '/models/like.dart';
import '/res/enums/media_type.dart';
import '/widgets/custom_error_widget.dart';
import '/widgets/custom_shimmer.dart';
import '/controllers/post_controller.dart';
import '/res/controllers_key.dart';
import '/widgets/custom_cached_image.dart';
import '/models/post.dart';
import '/global_configs.dart';
import '/widgets/custom_appbar.dart';

class PostScreen extends StatefulWidget {
  final int postId;

  const PostScreen({
    super.key,
    required this.postId,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  int imagesCurrentIndex = 0;

  bool isLoading = true;
  bool isFailed = false;

  bool isPostLiked = false;
  bool isPostDisliked = false;
  bool likeOperationLoading = false;
  int? likeId;

  bool isCreateCommentsLoading = false;
  bool isCommentsLoading = false;
  List<PostComment>? comments;

  bool isVideoLoading = false;
  bool isVideoCompleted = false;

  bool isStop = false;

  Post? post;

  TextEditingController commentController = TextEditingController();

  PostController postController = Get.find(
    tag: ControllersKey.postControllerKey,
  );

  Map<String, VideoPlayerController?> controllers = {};

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  Future<void> fetchPost() async {
    setState(() {
      isLoading = true;
      isCommentsLoading = true;
      isFailed = false;
    });

    await postController.getPostDetails(widget.postId).then((value) async {
      if (value.$1 != null) {
        post = value.$1;

        isPostLiked = value.$2;
        fetchComments();
      } else {
        isFailed = true;
      }
    });

    if ((post?.items.isNotEmpty ?? false) &&
        post?.items[imagesCurrentIndex].itemType == MediaType.video) {
      fetchVideo(post?.items[imagesCurrentIndex].file ?? '');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchComments() async {
    setState(() {
      isCommentsLoading = true;
    });

    await postController.getPostComments(post?.id ?? 0).then(
      (commentsList) {
        comments = commentsList;
      },
    );

    setState(() {
      isCommentsLoading = false;
    });
  }

  Future<void> dislikePost() async {
    setState(() {
      likeOperationLoading = true;
    });
    await postController.deletePostLikes(likeId ?? -1).then((value) {
      if (value) {
        isPostLiked = !isPostLiked;
      }
    });

    setState(() {
      likeOperationLoading = false;
    });
  }

  Future<void> likePost() async {
    setState(() {
      likeOperationLoading = true;
    });

    await postController.createPostLikes(post!.id).then((value) {
      if (value.$1) {
        isPostLiked = !isPostLiked;
        likeId = value.$2;
      }
    });

    setState(() {
      likeOperationLoading = false;
    });
  }

  Future<void> addComment() async {
    var theme = Theme.of(context);
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return Dialog(
            child: Padding(
              padding: globalPadding * 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    "افزودن نظر",
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: commentController,
                    hintText: "نظر خود را وارد کنید",
                    maxLines: 3,
                  ),
                  const SizedBox(height: 56),
                  isCreateCommentsLoading
                      ? SpinKitThreeBounce(
                          size: 16,
                          color: theme.colorScheme.primary,
                        )
                      : Center(
                          child: FilledButton(
                            onPressed: () async {
                              setDialogState(() {
                                isCreateCommentsLoading = true;
                              });

                              await postController
                                  .createComments(
                                post?.id ?? 0,
                                commentController.text,
                              )
                                  .then(
                                (value) {
                                  Get.back(result: value);
                                },
                              );

                              setDialogState(() {
                                isCreateCommentsLoading = false;
                              });
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: globalBorderRadius * 2,
                              ),
                              fixedSize: const Size.fromWidth(160),
                            ),
                            child: Text(
                              'ثبت نظر',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        });
      },
    ).then(
      (value) {
        if (value) {
          Get.snackbar(
            'موفق',
            'نظر با موفقیت ساخته شد',
          );
        } else if (!value) {
          Get.snackbar(
            'نا موفق',
            postController.apiMessage,
          );
        }
      },
    );
  }

  Future<void> fetchVideo(String url) async {
    setState(() {
      isVideoLoading = true;
    });

    if (controllers[url] == null) {
      isVideoCompleted = false;
      controllers[url] = VideoPlayerController.networkUrl(Uri.parse(url));

      await controllers[url]!.initialize();

      controllers[url]!.addListener(() {
        if (controllers[url]!.value.isCompleted) {
          setState(() {
            isVideoCompleted = true;
            isStop = true;
          });
        }
      });

      controllers[url]!.play();
    }

    setState(() {
      isVideoLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();

    controllers.forEach((key, value) {
      value?.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: CustomAppbar(
        iconAsset: "assets/icons/arrow_back_19.png",
        onTap: () => Get.back(),
      ),
      body: SizedBox(
        width: SizeController.width(context),
        height: SizeController.height(context),
        child: ListView(
          shrinkWrap: true,
          children: [
            if (isLoading) ...[
              const SizedBox(height: 16),
              CustomShimmer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 320,
                      decoration: BoxDecoration(
                        borderRadius: globalBorderRadius * 4,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 100,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: globalBorderRadius,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 200,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: globalBorderRadius,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              )
            ] else if (isFailed)
              CustomErrorWidget(
                onTap: () {
                  fetchPost();
                },
              )
            else ...[
              const SizedBox(height: 16),
              Container(
                color: theme.colorScheme.primary,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          post?.user.firstName ?? "",
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipOval(
                            child: Image.network(
                              post?.user.avatar ?? "",
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              CarouselSlider(
                items: List.generate(
                  post?.items.length ?? 0,
                  (int index) {
                    return post?.items[index].itemType == MediaType.image
                        ? CustomCachedImage(
                            url: post?.items[index].file ?? '',
                            fit: BoxFit.cover,
                            height: 360,
                            width: SizeController.width(context),
                          )
                        : SizedBox(
                            height: 360,
                            child: Column(
                              children: [
                                if (isVideoLoading) ...[
                                  CustomShimmer(
                                    child: Container(
                                      height: 320,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  )
                                ] else ...[
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        isStop = !isStop;

                                        setState(() {
                                          if (isVideoCompleted) {
                                            isVideoCompleted = false;
                                            controllers[
                                                    post?.items[index].file]!
                                                .seekTo(
                                              const Duration(seconds: 0),
                                            );
                                          }
                                          if (isStop) {
                                            controllers[
                                                    post?.items[index].file]!
                                                .pause();
                                          } else {
                                            controllers[
                                                    post?.items[index].file]!
                                                .play();
                                          }
                                        });
                                      },
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              height: 360,
                                              width: double.infinity,
                                              color: Colors.grey
                                                  .withValues(alpha: 0.3),
                                              child: AspectRatio(
                                                aspectRatio: controllers[post
                                                        ?.items[index].file]!
                                                    .value
                                                    .aspectRatio,
                                                child: VideoPlayer(
                                                  controllers[
                                                      post?.items[index].file]!,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            bottom: 0,
                                            right: 0,
                                            left: 0,
                                            child: Icon(
                                              isStop
                                                  ? Icons.play_circle
                                                  : Icons.pause_circle,
                                              size: 56,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ]
                              ],
                            ),
                          );
                  },
                ),
                options: CarouselOptions(
                  height: 360,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  initialPage: imagesCurrentIndex,
                  onPageChanged: (index, changeReason) {
                    if (post?.items[index].itemType == MediaType.video) {
                      fetchVideo(post?.items[index].file ?? '');
                    }
                    setState(() {
                      imagesCurrentIndex = index;
                    });
                  },
                ),
              ),
              const SizedBox(height: 4),
              isLoading
                  ? CustomShimmer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 16),
                            width: 100,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: globalBorderRadius,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: addComment,
                          child: SvgPicture.asset(
                            "assets/icons/message.svg",
                            width: 21,
                            height: 21,
                          ),
                        ),
                        const SizedBox(width: 20),
                        likeOperationLoading
                            ? SizedBox(
                                width: 32,
                                height: 32,
                                child: SpinKitThreeBounce(
                                  color: theme.colorScheme.secondary,
                                  size: 20,
                                ),
                              )
                            : InkWell(
                                onTap: () async {
                                  if (isPostLiked) {
                                    await dislikePost();
                                  } else {
                                    await likePost();
                                  }
                                },
                                child: Icon(
                                  isPostLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 32,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                        const SizedBox(width: 16),
                      ],
                    ),
              Padding(
                padding: globalPadding * 4,
                child: Text(
                  "بیو",
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: globalPadding * 4,
                child: CollapsingText(
                  text: post?.caption ?? '',
                ),
              ),
              // const SizedBox(height: 24),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "نظرات",
              //       style: theme.textTheme.headlineSmall,
              //     ),
              //     OutlinedButton(
              //       style: OutlinedButton.styleFrom(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: globalBorderRadius * 2,
              //         ),
              //       ),
              //       onPressed: () async {
              //         isCreateCommentsLoading = false;
              //         commentController.text = '';
              //         await addComment();
              //       },
              //       child: Text(
              //         "افزودن نظر",
              //         style: theme.textTheme.bodyLarge,
              //       ),
              //     )
              //   ],
              // ),
              // const SizedBox(height: 16),
              // ListView.separated(
              //   shrinkWrap: true,
              //   separatorBuilder: (context, index) {
              //     return Column(
              //       children: [
              //         const SizedBox(height: 12),
              //         MyDivider(
              //           color: theme.colorScheme.onSecondary
              //               .withValues(alpha: 0.2),
              //           height: 1,
              //           thickness: 1,
              //         ),
              //         const SizedBox(height: 12),
              //       ],
              //     );
              //   },
              //   itemCount:
              //       (comments?.length ?? 0) > 2 ? 2 : comments?.length ?? 0,
              //   itemBuilder: (context, index) {
              //     return Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Row(
              //           children: [
              //             ClipOval(
              //               child: CustomCachedImage(
              //                 url: comments?[index].user.avatar ?? '',
              //                 width: 50,
              //                 height: 50,
              //               ),
              //             ),
              //             const SizedBox(width: 5),
              //             Expanded(
              //               child: Text(
              //                 "${comments?[index].user.firstName ?? ''} ${comments?[index].user.lastName ?? ''}",
              //                 style: theme.textTheme.titleLarge?.copyWith(
              //                   fontSize: 16,
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //         const SizedBox(height: 12),
              //         CollapsingText(
              //           text: comments?[index].comment ?? '',
              //         ),
              //       ],
              //     );
              //   },
              // ),
              // if ((comments?.length ?? 0) > 2) ...[
              //   const SizedBox(height: 5),
              //   TextButton(
              //     onPressed: () {},
              //     child: Text(
              //       "مشاهده ی بیشتر",
              //       style: theme.textTheme.bodyMedium,
              //     ),
              //   ),
              // ],
              const SizedBox(height: 50),
            ],
          ],
        ),
      ),
    );
  }
}
