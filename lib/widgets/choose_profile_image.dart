import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/global_configs.dart';
import '/res/app_colors.dart';

class ChooseProfileImage extends StatefulWidget {
  const ChooseProfileImage({super.key});

  @override
  State<ChooseProfileImage> createState() => _ChooseProfileImageState();
}

class _ChooseProfileImageState extends State<ChooseProfileImage> {
  bool isAvatarLoading = false;
  File? avatarImage;

  Future<void> pickFile() async {
    setState(() {
      isAvatarLoading = true;
    });
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      avatarImage = files.isNotEmpty ? files[0] : null;
    } else {
      // User canceled the picker
    }

    setState(() {
      isAvatarLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ListView(
      shrinkWrap: true,
      padding: globalPadding * 4,
      children: [
        const SizedBox(height: 24),
        Text(
          "عکس پیش فرض",
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 10,
          spacing: 20,
          children: List.generate(
            3,
            (index) {
              return InkWell(
                onTap: () {
                  Get.back(result: index + 1);
                },
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: globalBorderRadius * 9,
                    child: Image.asset(
                      "assets/images/default_avatar_${index + 1}.jpeg",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "انتخاب عکس",
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () async {
            if (!isAvatarLoading) {
              await pickFile();
              Get.back(result: avatarImage?.path);
            }
          },
          child: Container(
            height: 50,
            margin: globalPadding * 5,
            padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
            decoration: BoxDecoration(
              color: AppColors.avatarBorderColor,
              borderRadius: globalBorderRadius * 3,
            ),
            child: Center(
              child: isAvatarLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      avatarImage == null
                          ? 'عکس پروفایل'
                          : avatarImage!.path.split('/').last,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: avatarImage == null
                            ? theme.colorScheme.surface.withValues(alpha: 0.9)
                            : AppColors.sideColor,
                      ),
                      overflow: TextOverflow.fade,
                    ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
