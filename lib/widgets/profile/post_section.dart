import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/controllers/post_controller.dart';
import 'package:kanaf/res/controllers_key.dart';

import '/global_configs.dart';
import '/res/app_colors.dart';
import '../small_button.dart';

class PostSection extends StatefulWidget {
  const PostSection({super.key});

  @override
  State<PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<PostSection> {
  List<File?> images = List.generate(6, (index) => null);
  List<bool> picturesLoading = List.generate(6, (index) => false);

  bool createPostLoading = false;
  bool createPostFailed = false;

  PostController postController = Get.find(
    tag: ControllersKey.postControllerKey,
  );

  Future<void> createPost() async {
    setState(() {
      createPostLoading = true;
      createPostFailed = false;
    });

    setState(() {
      createPostLoading = false;
    });
  }

  Future<void> onPickFile(int index) async {
    if (images[index] == null) {
      setState(() {
        picturesLoading[index] = true;
      });
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        images[index] = files.isNotEmpty ? files[0] : null;
      } else {
        // User canceled the picker
      }

      setState(() {
        picturesLoading[index] = false;
      });
    } else {
      setState(() {
        images[index] = null;
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
                  picturesLoading[index]
                      ? Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.onPrimary,
                          ),
                        )
                      : images[index] != null
                          ? Image.file(
                              images[index]!,
                              width: 150,
                              height: 100,
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
                            images[index] == null ? Icons.add : Icons.close,
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
        const SizedBox(
          height: 18,
        ),
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
          onTap: () {},
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
              const SizedBox(
                width: 15,
              ),
              Expanded(
                  child: TextField(
                style: theme.textTheme.labelLarge
                    ?.copyWith(color: theme.colorScheme.surface),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: "کپشن",
                    hintStyle: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimary
                            .withValues(alpha: 0.38))),
              )),
              const SizedBox(
                width: 8,
              )
            ],
          ),
        ),
        const SizedBox(height: 32)
      ],
    );
  }
}
