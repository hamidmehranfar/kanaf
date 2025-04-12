import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';

import '/controllers/project_controller.dart';
import '/res/controllers_key.dart';
import '/global_configs.dart';
import '/res/app_colors.dart';
import '/res/enums/media_type.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/my_divider.dart';

class EmployerCreateProjectScreen extends StatefulWidget {
  const EmployerCreateProjectScreen({super.key});

  @override
  State<EmployerCreateProjectScreen> createState() =>
      _EmployerCreateProjectScreenState();
}

class _EmployerCreateProjectScreenState
    extends State<EmployerCreateProjectScreen> {
  TextEditingController captionTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController offeredTimeTextController = TextEditingController();
  TextEditingController areaTextController = TextEditingController();
  TextEditingController cityTextController = TextEditingController();

  ProjectController projectController = Get.find(
    tag: ControllersKey.projectControllerKey,
  );

  bool createProjectLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> onPickFile(int index) async {
    if (createProjectLoading) return;
    if (projectController.images[index].$1 == null) {
      setState(() {
        projectController.picturesLoading[index] = true;
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

        projectController.images[index] = (selectedFile, type);
      } else {
        // User canceled the picker
      }

      setState(() {
        projectController.picturesLoading[index] = false;
      });
    } else {
      setState(() {
        projectController.images[index] = (null, null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(
        onTap: () => Get.back(),
        iconAsset: "assets/icons/arrow_back_19.png",
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 25),
          Text(
            "ایجاد پروژه",
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w300,
              color: theme.colorScheme.tertiary,
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
          const SizedBox(height: 13),
          Container(
            margin: globalPadding * 5.5,
            padding: globalPadding * 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: globalBorderRadius * 6,
            ),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Container(
                  margin: globalPadding * 10,
                  padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
                  decoration: BoxDecoration(
                    color: AppColors.textFieldColor,
                    borderRadius: globalBorderRadius * 4,
                  ),
                  child: TextField(
                    controller: captionTextController,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.surface,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "کپشن",
                      hintStyle: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.surface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: globalPadding * 10,
                  padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
                  decoration: BoxDecoration(
                    color: AppColors.textFieldColor,
                    borderRadius: globalBorderRadius * 4,
                  ),
                  child: TextField(
                    controller: priceTextController,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.surface,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "قیمت",
                      hintStyle: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.surface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: globalPadding * 10,
                  padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
                  decoration: BoxDecoration(
                    color: AppColors.textFieldColor,
                    borderRadius: globalBorderRadius * 4,
                  ),
                  child: TextField(
                    controller: offeredTimeTextController,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.surface,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "مدت زمان پیشنهادی",
                      hintStyle: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.surface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: globalPadding * 10,
                  padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
                  decoration: BoxDecoration(
                    color: AppColors.textFieldColor,
                    borderRadius: globalBorderRadius * 4,
                  ),
                  child: TextField(
                    controller: areaTextController,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.surface,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "متراژ حدودی",
                      hintStyle: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.surface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: globalPadding * 10,
                  padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
                  decoration: BoxDecoration(
                    color: AppColors.textFieldColor,
                    borderRadius: globalBorderRadius * 4,
                  ),
                  child: TextField(
                    controller: areaTextController,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.surface,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "شهر",
                      hintStyle: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.surface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 1,
                      mainAxisExtent: 110,
                    ),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          projectController.picturesLoading[index]
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                )
                              : projectController.images[index].$1 != null
                                  ? projectController.images[index].$2 ==
                                          MediaType.image
                                      ? ClipRRect(
                                          borderRadius: globalBorderRadius * 10,
                                          child: Image.file(
                                            projectController.images[index].$1!,
                                            width: 150,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Text(
                                          projectController
                                                  .images[index].$1?.path
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
                                    (projectController.images[index].$1 == null)
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
