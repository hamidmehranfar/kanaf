import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kanaf/models/post.dart';

import '/global_configs.dart';
import '/res/app_colors.dart';
import '../small_button.dart';

class StorySection extends StatefulWidget {
  final Post? post;
  const StorySection({super.key, this.post});

  @override
  State<StorySection> createState() => _StorySectionState();
}

class _StorySectionState extends State<StorySection> {
  bool pictureLoading = false;
  File? pickedFile;

  Future<void> onPickFile() async {
    if (pickedFile == null) {
      setState(() {
        pictureLoading = true;
      });
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        pickedFile = files.isNotEmpty ? files[0] : null;
      } else {
        // User canceled the picker
      }

      setState(() {
        pictureLoading = false;
      });
    } else {
      setState(() {
        pickedFile = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 30),
        InkWell(
          onTap: () async {
            await onPickFile();
          },
          child: pictureLoading
              ? CircularProgressIndicator(
                  color: theme.colorScheme.onPrimary,
                )
              : pickedFile != null
                  ? Image.file(
                      pickedFile!,
                      height: 200,
                    )
                  : Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: globalBorderRadius * 10,
                        color:
                            theme.colorScheme.secondary.withValues(alpha: 0.4),
                      ),
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
