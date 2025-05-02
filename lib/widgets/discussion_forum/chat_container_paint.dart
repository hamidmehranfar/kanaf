import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:kanaf/res/app_colors.dart';
import 'package:kanaf/widgets/my_divider.dart';

import '../error_snack_bar.dart';
import '/res/enums/reaction_type.dart';
import '/controllers/discussion_controller.dart';
import '/models/discussion.dart';
import '/controllers/authentication_controller.dart';
import '/models/discussion_answer.dart';
import '/res/controllers_key.dart';
import '/global_configs.dart';
import '../custom_cached_image.dart';

class ChatContainerPaint extends StatefulWidget {
  final DiscussionAnswer? answer;
  final Discussion? discussion;
  final bool isMainMessage;

  const ChatContainerPaint({
    super.key,
    this.answer,
    this.isMainMessage = false,
    this.discussion,
  });

  @override
  State<ChatContainerPaint> createState() => _ChatContainerPaintState();
}

class _ChatContainerPaintState extends State<ChatContainerPaint> {
  bool isLikeLoading = false;
  bool isDislikeLoading = false;

  bool likeValue = false;
  bool dislikeValue = false;

  AuthenticationController authController = Get.find(
    tag: ControllersKey.authControllerKey,
  );

  DiscussionController discussionController = Get.find(
    tag: ControllersKey.discussionControllerKey,
  );

  String name = "";
  String text = "";
  String userAvatar = "";
  bool isSent = false;

  bool replyClick = false;
  bool replyLoading = false;
  TextEditingController replyTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    initValues();
  }

  void initValues() {
    isSent = !widget.isMainMessage
        ? authController.user?.userName == widget.answer?.user.userName
        : false;
    name = (widget.isMainMessage
            ? widget.discussion?.user.firstName
            : widget.answer?.user.firstName) ??
        "";
    text = (widget.isMainMessage
            ? widget.discussion?.text
            : widget.answer?.answer) ??
        "";
    userAvatar = (widget.isMainMessage
            ? widget.discussion?.user.avatar
            : widget.answer?.user.avatar) ??
        "";
    likeValue = widget.isMainMessage
        ? widget.discussion?.currentUserReaction?.reaction == ReactionType.like
        : widget.answer?.currentUserReaction?.reaction == ReactionType.like;

    dislikeValue = widget.isMainMessage
        ? widget.discussion?.currentUserReaction?.reaction ==
            ReactionType.dislike
        : widget.answer?.currentUserReaction?.reaction == ReactionType.dislike;
  }

  Future<void> replyAnswer() async {
    setState(() {
      replyLoading = true;
    });

    await discussionController
        .sendAnswerMessage(
      message: replyTextController.text,
      discussion: widget.answer?.discussionId ?? -1,
      repliedAnswer: widget.answer?.id,
    )
        .then(
      (value) {
        if (value != null) {
          widget.answer?.repliedAnswers.add(value);
          replyTextController.text = "";
          replyClick = false;
        } else {
          showSnackbarMessage(
            context: context,
            message: discussionController.apiMessage,
          );
        }
      },
    );

    setState(() {
      replyLoading = false;
    });
  }

  Future<void> likeAnswerReaction() async {
    // reaction = 1 is for like and reaction = 2 is for dislike

    setState(() {
      isLikeLoading = true;
    });

    await discussionController
        .discussionAnswerReaction(
      reaction: 1,
      discussionId: widget.answer!.id,
    )
        .then(
      (value) {
        if (value) {
          likeValue = true;
        } else {
          showSnackbarMessage(
            context: context,
            message: discussionController.apiMessage,
          );
        }
      },
    );

    setState(() {
      isLikeLoading = false;
    });
  }

  Future<void> dislikeAnswerReaction() async {
    // reaction = 1 is for like and reaction = 2 is for dislike

    setState(() {
      isDislikeLoading = true;
    });

    await discussionController
        .discussionAnswerReaction(
      reaction: 2,
      discussionId: widget.answer!.id,
    )
        .then(
      (value) {
        if (value) {
          dislikeValue = true;
        } else {
          showSnackbarMessage(
            context: context,
            message: discussionController.apiMessage,
          );
        }
      },
    );

    setState(() {
      isDislikeLoading = false;
    });
  }

  Future<void> likeDiscussionReaction() async {
    // reaction = 1 is for like and reaction = 2 is for dislike

    setState(() {
      isLikeLoading = true;
    });

    await discussionController
        .discussionReaction(
      reaction: 1,
      discussionId: widget.discussion!.id,
    )
        .then(
      (value) {
        if (value) {
          likeValue = true;

          // refresh like and dislikes that shown in discussion list screen
          if (discussionController.pagingController != null) {
            discussionController.pagingController!.refresh();
          }
        } else {
          showSnackbarMessage(
            context: context,
            message: discussionController.apiMessage,
          );
        }
      },
    );

    setState(() {
      isLikeLoading = false;
    });
  }

  Future<void> dislikeDiscussionReaction() async {
    // reaction = 1 is for like and reaction = 2 is for dislike

    setState(() {
      isDislikeLoading = true;
    });

    await discussionController
        .discussionReaction(
      reaction: 2,
      discussionId: widget.discussion!.id,
    )
        .then(
      (value) {
        if (value) {
          dislikeValue = true;

          // refresh like and dislikes that shown in discussion list screen
          if (discussionController.pagingController != null) {
            discussionController.pagingController!.refresh();
          }
        } else {
          showSnackbarMessage(
            context: context,
            message: discussionController.apiMessage,
          );
        }
      },
    );

    setState(() {
      isDislikeLoading = false;
    });
  }

  Future<void> removeAnswerLikeReaction() async {
    setState(() {
      isLikeLoading = true;
    });

    await discussionController
        .removeDiscussionAnswerReaction(
      reactionId: widget.answer?.currentUserReaction?.id ?? -1,
    )
        .then(
      (value) {
        if (value) {
          likeValue = false;
        } else {
          showSnackbarMessage(
            context: context,
            message: discussionController.apiMessage,
          );
        }
      },
    );

    setState(() {
      isLikeLoading = false;
    });
  }

  Future<void> removeAnswerDislikeReaction() async {
    setState(() {
      isDislikeLoading = true;
    });

    await discussionController
        .removeDiscussionAnswerReaction(
      reactionId: widget.answer?.currentUserReaction?.id ?? -1,
    )
        .then(
      (value) {
        if (value) {
          dislikeValue = false;
        } else {
          showSnackbarMessage(
            context: context,
            message: discussionController.apiMessage,
          );
        }
      },
    );

    setState(() {
      isDislikeLoading = false;
    });
  }

  Future<void> removeDiscussionLikeReaction() async {
    setState(() {
      isLikeLoading = true;
    });

    await discussionController
        .removeDiscussionReaction(
      reactionId: widget.discussion?.currentUserReaction?.id ?? -1,
    )
        .then(
      (value) {
        if (value) {
          likeValue = false;

          // refresh like and dislikes that shown in discussion list screen
          if (discussionController.pagingController != null) {
            discussionController.pagingController!.refresh();
          }
        } else {
          showSnackbarMessage(
            context: context,
            message: discussionController.apiMessage,
          );
        }
      },
    );

    setState(() {
      isLikeLoading = false;
    });
  }

  Future<void> removeDiscussionDislikeReaction() async {
    setState(() {
      isDislikeLoading = true;
    });

    await discussionController
        .removeDiscussionReaction(
      reactionId: widget.discussion?.currentUserReaction?.id ?? -1,
    )
        .then(
      (value) {
        if (value) {
          dislikeValue = false;

          // refresh like and dislikes that shown in discussion list screen
          if (discussionController.pagingController != null) {
            discussionController.pagingController!.refresh();
          }
        } else {
          showSnackbarMessage(
            context: context,
            message: discussionController.apiMessage,
          );
        }
      },
    );

    setState(() {
      isDislikeLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: isSent ? 170 : 230,
          padding: EdgeInsets.only(
            left: widget.isMainMessage ? 20 : 16,
            right: widget.isMainMessage ? 16 : 12,
            top: 20,
            bottom: 5,
          ),
          margin: const EdgeInsets.only(top: 50),
          decoration: BoxDecoration(
            borderRadius: globalBorderRadius * 2,
            color: isSent
                ? theme.colorScheme.tertiary.withValues(alpha: 0.73)
                : theme.colorScheme.secondary.withValues(alpha: 0.33),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: widget.isMainMessage ? 20 : 12,
                    color: theme.colorScheme.surface.withValues(alpha: 0.75),
                  ),
                ),
              ),
              if (widget.discussion != null &&
                  widget.discussion?.image != null) ...[
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: globalBorderRadius * 3,
                    child: CustomCachedImage(
                      url: widget.discussion!.image!,
                      width: 165,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ] else
                SizedBox(height: widget.isMainMessage ? 10 : 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: widget.isMainMessage ? 13 : 9,
                    fontWeight: widget.isMainMessage
                        ? FontWeight.w400
                        : FontWeight.w500,
                    color: theme.colorScheme.surface.withValues(alpha: 0.75),
                  ),
                ),
              ),
              if ((!widget.isMainMessage &&
                      (widget.answer?.repliedAnswers.isNotEmpty ?? false)) ||
                  replyClick) ...[
                const SizedBox(height: 4),
                MyDivider(
                  color: AppColors.paleBlack.withValues(alpha: 0.4),
                  height: 1,
                  thickness: 1,
                ),
                const SizedBox(height: 4),
                ...widget.answer!.repliedAnswers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final replied = entry.value;
                  final isLast =
                      index == widget.answer!.repliedAnswers.length - 1;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        replied.user.firstName ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color:
                              theme.colorScheme.surface.withValues(alpha: 0.75),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        replied.answer ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color:
                              theme.colorScheme.surface.withValues(alpha: 0.75),
                        ),
                      ),
                      if (!isLast) ...[
                        const SizedBox(height: 4),
                        MyDivider(
                          color: AppColors.paleBlack.withValues(alpha: 0.2),
                          height: 1,
                          thickness: 1,
                        ),
                        const SizedBox(height: 4),
                      ],
                    ],
                  );
                }),
                if (replyClick) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: replyLoading
                            ? SpinKitThreeBounce(
                                size: 14,
                                color: AppColors.textFieldColor,
                              )
                            : InkWell(
                                onTap: () async {
                                  await replyAnswer();
                                },
                                child: Transform.rotate(
                                  angle: 180 * math.pi / 180,
                                  child: Icon(
                                    Icons.send,
                                    color: AppColors.paleBlack,
                                  ),
                                ),
                              ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: globalPadding * 3,
                          decoration: BoxDecoration(
                            borderRadius: globalBorderRadius * 4,
                            color: AppColors.textFieldColor
                                .withValues(alpha: 0.78),
                          ),
                          child: Center(
                            child: TextField(
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.surface,
                              ),
                              controller: replyTextController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                hintText: "پیام",
                                hintStyle:
                                    theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.surface
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              scrollPadding: const EdgeInsets.only(bottom: 200),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  isLikeLoading
                      ? SpinKitThreeBounce(
                          size: 6,
                          color: theme.colorScheme.primary,
                        )
                      : InkWell(
                          onTap: () async {
                            if (widget.isMainMessage) {
                              if (likeValue) {
                                await removeDiscussionLikeReaction();
                              } else {
                                await likeDiscussionReaction();
                              }
                            } else {
                              if (likeValue) {
                                await removeAnswerLikeReaction();
                              } else {
                                await likeAnswerReaction();
                              }
                            }
                          },
                          child: Icon(
                            likeValue
                                ? Icons.thumb_up
                                : Icons.thumb_up_alt_outlined,
                            size: 12,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                  const SizedBox(width: 6),
                  isDislikeLoading
                      ? SpinKitThreeBounce(
                          size: 6,
                          color: theme.colorScheme.primary,
                        )
                      : InkWell(
                          onTap: () async {
                            if (widget.isMainMessage) {
                              if (dislikeValue) {
                                await removeDiscussionDislikeReaction();
                              } else {
                                await dislikeDiscussionReaction();
                              }
                            } else {
                              if (dislikeValue) {
                                await removeAnswerDislikeReaction();
                              } else {
                                await dislikeAnswerReaction();
                              }
                            }
                          },
                          child: Icon(
                            dislikeValue
                                ? Icons.thumb_down
                                : Icons.thumb_down_alt_outlined,
                            size: 12,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                  if (!widget.isMainMessage) ...[
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        setState(() {
                          replyClick = !replyClick;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.replay,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "پاسخ $name",
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontSize: 12,
                              color: theme.colorScheme.secondary
                                  .withValues(alpha: 0.61),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Container(
          padding: globalAllPadding / 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surface,
          ),
          child: ClipOval(
            child: CustomCachedImage(
              url: userAvatar,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
