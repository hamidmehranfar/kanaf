import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../widgets/error_snack_bar.dart';
import '/widgets/custom_shimmer.dart';
import '/global_configs.dart';
import '/res/app_colors.dart';
import '/widgets/discussion_forum/chat_container_paint.dart';
import '/widgets/my_divider.dart';
import '/controllers/size_controller.dart';
import '/models/discussion.dart';
import '/controllers/discussion_controller.dart';
import '/models/discussion_answer.dart';
import '/res/controllers_key.dart';
import '/widgets/custom_appbar.dart';

class DiscussionForumChatScreen extends StatefulWidget {
  final Discussion discussion;

  const DiscussionForumChatScreen({
    super.key,
    required this.discussion,
  });

  @override
  State<DiscussionForumChatScreen> createState() =>
      _DiscussionForumChatScreenState();
}

class _DiscussionForumChatScreenState extends State<DiscussionForumChatScreen> {
  bool isLoading = true;
  bool isFailed = false;

  bool sendMessageLoading = false;

  List<DiscussionAnswer> answers = [];

  DiscussionController discussionController = Get.find(
    tag: ControllersKey.discussionControllerKey,
  );

  TextEditingController messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchMessages();
  }

  Future<void> fetchMessages() async {
    setState(() {
      isLoading = true;
    });

    await discussionController
        .getDiscussionMessages(
      discussionId: widget.discussion.id,
    )
        .then(
      (value) {
        if (value != null) {
          answers = value;
        } else {
          isFailed = true;
        }
      },
    );

    setState(() {
      isLoading = false;
    });
  }

  Future<void> sendMessage() async {
    if (messageTextController.text.isEmpty) return;

    setState(() {
      sendMessageLoading = true;
    });

    await discussionController
        .sendAnswerMessage(
      message: messageTextController.text,
      discussion: widget.discussion.id,
    )
        .then((answer) {
      if (answer != null) {
        answers.insert(0, answer);
        messageTextController.text = "";
      } else {
        showSnackbarMessage(
          context: context,
          message: discussionController.apiMessage,
        );
      }
    });

    setState(() {
      sendMessageLoading = false;
    });
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
      ),
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(
        bottom: true,
        child: SizedBox(
          width: SizeController.width(context),
          height: SizeController.height(context),
          child: Stack(
            children: [
              ListView(
                shrinkWrap: true,
                padding: globalPadding * 10,
                children: [
                  const SizedBox(height: 30),
                  ChatContainerPaint(
                    discussion: widget.discussion,
                    isMainMessage: true,
                  ),
                  const SizedBox(height: 23),
                  MyDivider(
                    color: AppColors.paleBlack,
                    height: 1,
                    thickness: 1,
                  ),
                  const SizedBox(height: 16),
                  if (isLoading)
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomShimmer(
                            child: Container(
                              width: 160,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: globalBorderRadius * 2,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: CustomShimmer(
                            child: Container(
                              width: 160,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: globalBorderRadius * 2,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomShimmer(
                            child: Container(
                              width: 160,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: globalBorderRadius * 2,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: answers.length + 1,
                      itemBuilder: (context, index) {
                        if (index == answers.length) {
                          return const SizedBox(height: 100);
                        }
                        return ChatContainerPaint(
                          key: ValueKey(answers[index].id),
                          answer: answers[index],
                        );
                      },
                    ),
                ],
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Container(
                  width: SizeController.width(context),
                  height: 63,
                  margin: globalPadding * 6,
                  padding: const EdgeInsets.only(
                      left: 11, right: 11, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: globalBorderRadius * 5,
                    color: theme.colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.tertiary,
                        offset: const Offset(-3, -3),
                      ),
                      BoxShadow(
                        color: theme.colorScheme.onSecondary,
                        offset: const Offset(3, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: sendMessageLoading
                            ? SpinKitThreeBounce(
                                size: 14,
                                color: theme.colorScheme.tertiary,
                              )
                            : InkWell(
                                onTap: () async {
                                  await sendMessage();
                                },
                                child: SvgPicture.asset(
                                  "assets/icons/message_sent.svg",
                                  width: 28,
                                  height: 28,
                                ),
                              ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: globalPadding * 3,
                          decoration: BoxDecoration(
                            borderRadius: globalBorderRadius * 4,
                            color: AppColors.textFieldColor
                                .withValues(alpha: 0.78),
                          ),
                          child: TextField(
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.surface,
                            ),
                            controller: messageTextController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              hintText: "پیام",
                              hintStyle: theme.textTheme.labelMedium?.copyWith(
                                color:
                                    theme.colorScheme.surface.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(width: 5),
                      // SizedBox(
                      //   width: 25,
                      //   height: 25,
                      //   child: IconButton(
                      //           onPressed: () async {
                      //             await sendMessage();
                      //           },
                      //           style: IconButton.styleFrom(
                      //             tapTargetSize:
                      //                 MaterialTapTargetSize.shrinkWrap,
                      //             padding: EdgeInsets.zero,
                      //           ),
                      //           icon: Icon(
                      //             Icons.attach_file,
                      //             size: 25,
                      //             color: theme.colorScheme.tertiary,
                      //           ),
                      //         ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
