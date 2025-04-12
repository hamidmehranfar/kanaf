import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';

import '/res/enums/media_type.dart';
import '/controllers/post_controller.dart';
import '/res/controllers_key.dart';
import '/global_configs.dart';
import '/res/app_colors.dart';
import '../small_button.dart';

class PostSection extends StatefulWidget {
  const PostSection({super.key});

  @override
  State<PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<PostSection> {
  PostController postController = Get.find(
    tag: ControllersKey.postControllerKey,
  );

  @override
  void initState() {
    super.initState();
    postController.initCaptionTextController();
  }

  Future<void> onPickFile(int index) async {
    if (postController.createPostLoading) return;
    if (postController.images[index].$1 == null) {
      setState(() {
        postController.picturesLoading[index] = true;
      });
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
      );

      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();

        File? selectedFile = files.isNotEmpty ? files[0] : null;
        MediaType? type;
        String? filePath = selectedFile?.path;

        if (filePath != null) {
          String? mimeType = lookupMimeType(filePath);
          if (mimeType?.startsWith('image/') ?? false) {
            type = MediaType.image;
          } else if (mimeType?.startsWith('video/') ?? false) {
            type = MediaType.video;
          }
        }

        postController.images[index] = (selectedFile, type);
      } else {
        // User canceled the picker
      }

      setState(() {
        postController.picturesLoading[index] = false;
      });
    } else {
      setState(() {
        postController.images[index] = (null, null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 30),
        SizedBox(
          height: 335,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 1,
              mainAxisExtent: 110,
            ),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  postController.picturesLoading[index]
                      ? Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.onPrimary,
                          ),
                        )
                      : postController.images[index].$1 != null
                          ? postController.images[index].$2 == MediaType.image
                              ? ClipRRect(
                                  borderRadius: globalBorderRadius * 10,
                                  child: Image.file(
                                    postController.images[index].$1!,
                                    width: 150,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text(
                                  postController.images[index].$1?.path
                                          .split('/')
                                          .last ??
                                      '',
                                  style: theme.textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                )
                          : InkWell(
                              onTap: () async {
                                await onPickFile(index);
                              },
                              child: Container(
                                width: 150,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: globalBorderRadius * 10,
                                  color: theme.colorScheme.secondary
                                      .withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                  Positioned(
                    right: 0,
                    bottom: 10,
                    child: Container(
                      width: 27,
                      height: 27,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.onPrimary),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.secondary,
                        ),
                        child: InkWell(
                          onTap: () async {
                            await onPickFile(index);
                          },
                          child: Icon(
                            (postController.images[index].$1 == null)
                                ? Icons.add
                                : Icons.close,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 18),
        if (postController.createPostLoading)
          SpinKitThreeBounce(
            size: 14,
            color: theme.colorScheme.onSecondary,
          )
        else
          SmallButton(
            text: "آپلود عکس یا ویدئو",
            textColor: theme.colorScheme.onSecondary,
            width: 142,
            height: 27,
            shadow: [
              BoxShadow(
                color: theme.colorScheme.onPrimary,
                offset: const Offset(-20, -10),
                blurRadius: 25,
                spreadRadius: -10,
              ),
              BoxShadow(
                color: theme.colorScheme.onSecondary,
                offset: const Offset(20, 10),
                blurRadius: 20,
                spreadRadius: -5,
              ),
            ],
            onTap: () async {},
          ),
        const SizedBox(height: 25),
        Container(
          height: 51,
          padding: const EdgeInsets.only(bottom: 5),
          margin: globalPadding * 3,
          decoration: BoxDecoration(
            color: AppColors.textFieldColor.withValues(alpha: 0.78),
            borderRadius: globalBorderRadius * 4,
          ),
          child: Row(
            children: [
              const SizedBox(width: 15),
              Expanded(
                child: TextField(
                  controller: postController.captionTextController,
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
        const SizedBox(height: 32)
      ],
    );
  }
}
