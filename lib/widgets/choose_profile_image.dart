import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/widgets/button_item.dart';
import 'package:kanaf/widgets/shadow_button.dart';

import '/global_configs.dart';
import '/res/app_colors.dart';
import 'my_divider.dart';

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
        const SizedBox(height: 14),
        Center(
          child: Text(
            'انتخاب آواتار',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w300,
              color: theme.colorScheme.tertiary,
            ),
          ),
        ),
        const SizedBox(height: 14),
        MyDivider(
          color: AppColors.textFieldColor,
          height: 1,
          thickness: 1,
        ),
        const SizedBox(height: 26),
        Center(
          child: Wrap(
            alignment: WrapAlignment.start,
            runSpacing: 8,
            spacing: 13,
            children: List.generate(
              3,
              (index) {
                return InkWell(
                  onTap: () {
                    Get.back(result: index + 1);
                  },
                  child: SizedBox(
                    width: 105,
                    height: 70,
                    child: ClipRRect(
                      borderRadius: globalBorderRadius * 10,
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
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isAvatarLoading)
              const CircularProgressIndicator()
            else ...[
              InkWell(
                onTap: () async {
                  if (!isAvatarLoading) {
                    await pickFile();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 140,
                      padding: const EdgeInsets.only(
                          top: 4, bottom: 4, left: 8, right: 8),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.tertiary.withValues(alpha: 0.75),
                        borderRadius: globalBorderRadius * 3,
                        border: Border(
                          top: BorderSide(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.onPrimary,
                            offset: const Offset(-15, -20),
                            spreadRadius: -3,
                            blurRadius: 60,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "آپلود عکس",
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (avatarImage != null) ...[
                const SizedBox(width: 10),
                ClipOval(
                  child: Image.file(
                    File(avatarImage!.path),
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                )
              ]
            ]
          ],
        ),
        const SizedBox(height: 20),
        MyDivider(
          color: AppColors.textFieldColor,
          height: 1,
          thickness: 1,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: globalPadding * 14,
          child: ButtonItem(
            onTap: () {
              Get.back(result: avatarImage?.path);
            },
            title: "ذخیره",
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
