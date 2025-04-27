import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:kanaf/widgets/shadow_button.dart';

import '../../widgets/error_snack_bar.dart';
import '/controllers/discussion_controller.dart';
import '/controllers/authentication_controller.dart';
import '/res/controllers_key.dart';
import '/widgets/custom_cached_image.dart';
import '/res/app_colors.dart';
import '/widgets/button_item.dart';
import '/global_configs.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/my_divider.dart';

class CreateDiscussionScreen extends StatefulWidget {
  final int categoryId;

  const CreateDiscussionScreen({super.key, required this.categoryId});

  @override
  State<CreateDiscussionScreen> createState() => _CreateDiscussionScreenState();
}

class _CreateDiscussionScreenState extends State<CreateDiscussionScreen> {
  bool uploadImageLoading = false;
  File? selectedFile;

  bool createDiscussionLoading = false;

  AuthenticationController authController = Get.find(
    tag: ControllersKey.authControllerKey,
  );

  DiscussionController discussionController = Get.find(
    tag: ControllersKey.discussionControllerKey,
  );

  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();

  Future<void> onPickFile() async {
    if (createDiscussionLoading) return;
    if (selectedFile == null) {
      setState(() {
        uploadImageLoading = true;
      });
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
      );

      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();

        selectedFile = files.isNotEmpty ? files[0] : null;
      } else {
        // User canceled the picker
      }

      setState(() {
        uploadImageLoading = false;
      });
    } else {
      setState(() {
        selectedFile = null;
      });
    }
  }

  Future<void> createDiscussion() async {
    if (textController.text.isEmpty || titleController.text.isEmpty) {
      showSnackbarMessage(
        context: context,
        message: "مقادیر را وارد کنید",
      );
      return;
    }

    setState(() {
      createDiscussionLoading = true;
    });

    await discussionController
        .createDiscussion(
      categoryId: widget.categoryId,
      title: titleController.text,
      text: textController.text,
    )
        .then((value) {
      if (value) {
        Navigator.of(context).pop(true);
      } else {
        showSnackbarMessage(
          context: context,
          message: discussionController.apiMessage,
        );
      }
    });

    setState(() {
      createDiscussionLoading = false;
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
      body: ListView(
        shrinkWrap: true,
        padding: globalPadding * 6,
        children: [
          const SizedBox(height: 25),
          Center(
            child: Text(
              "ایجاد گفتگو",
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w300,
                color: theme.colorScheme.tertiary,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: globalPadding * 11,
            child: MyDivider(
              color: theme.colorScheme.onSecondary,
              height: 1,
              thickness: 1,
            ),
          ),
          const SizedBox(height: 26),
          Container(
            decoration: BoxDecoration(
              borderRadius: globalBorderRadius * 5,
              color: theme.colorScheme.primary,
            ),
            child: Column(
              children: [
                const SizedBox(height: 23),
                Padding(
                  padding: globalPadding * 10,
                  child: uploadImageLoading
                      ? Center(
                          child: SizedBox(
                            width: 250,
                            height: 170,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        )
                      : selectedFile != null
                          ? ClipRRect(
                              borderRadius: globalBorderRadius * 10,
                              child: Image.file(
                                selectedFile!,
                                width: 250,
                                height: 170,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: 250,
                              height: 170,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    theme.colorScheme.surface
                                        .withValues(alpha: 0.9),
                                    theme.colorScheme.surface
                                        .withValues(alpha: 0.05),
                                  ],
                                  stops: const [0.6, 1],
                                ),
                                borderRadius: globalBorderRadius * 10,
                                color: theme.colorScheme.secondary
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                ),
                const SizedBox(height: 16),
                ShadowButton(
                  onTap: () async {
                    await onPickFile();
                  },
                  width: 100,
                  text: selectedFile == null ? "آپلود عکس" : "حذف عکس",
                  shadow: [
                    BoxShadow(
                      color: theme.colorScheme.onPrimary,
                      offset: const Offset(0, 10),
                      blurRadius: 40,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: globalPadding * 5.5,
                  child: MyDivider(
                    color: AppColors.textFieldColor,
                    height: 1,
                    thickness: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: globalPadding * 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            authController.user?.firstName ?? '',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(width: 5),
                          ClipOval(
                            child: CustomCachedImage(
                              url: authController.user?.avatar ?? '',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 46,
                        margin: const EdgeInsets.only(left: 40),
                        padding: globalPadding * 3,
                        decoration: BoxDecoration(
                          borderRadius: globalBorderRadius * 4,
                          color: AppColors.textFieldColor,
                        ),
                        child: TextField(
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.surface,
                          ),
                          controller: titleController,
                          scrollPadding: const EdgeInsets.only(bottom: 250),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "عنوان",
                            hintStyle: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.surface
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 46,
                        margin: const EdgeInsets.only(left: 40),
                        padding: globalPadding * 3,
                        decoration: BoxDecoration(
                          borderRadius: globalBorderRadius * 4,
                          color: AppColors.textFieldColor,
                        ),
                        child: TextField(
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.surface,
                          ),
                          controller: textController,
                          scrollPadding: const EdgeInsets.only(bottom: 250),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "متن",
                            hintStyle: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.surface
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 34),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: globalPadding * 11,
            child: MyDivider(
              color: AppColors.textFieldColor,
              height: 1,
              thickness: 1,
            ),
          ),
          const SizedBox(height: 12),
          (createDiscussionLoading)
              ? SpinKitThreeBounce(
                  size: 14,
                  color: theme.colorScheme.onSecondary,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonItem(
                      width: 200,
                      onTap: () async => await createDiscussion(),
                      isButtonDisable: createDiscussionLoading,
                      title: "ایجاد گفتگو",
                      color: theme.colorScheme.tertiary.withValues(alpha: 0.75),
                      textStyle: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
          const SizedBox(height: 100)
        ],
      ),
    );
  }
}
