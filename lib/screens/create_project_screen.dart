import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:mime/mime.dart';

import '../widgets/error_snack_bar.dart';
import '/res/enums/media_type.dart';
import '/controllers/city_controller.dart';
import '/models/city.dart';
import '/widgets/address_dropdown_widget.dart';
import '/controllers/project_controller.dart';
import '/res/controllers_key.dart';
import '/controllers/size_controller.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/button_item.dart';
import '/global_configs.dart';
import '/res/app_colors.dart';
import '/widgets/my_divider.dart';

class CreateProjectScreen extends StatefulWidget {
  final int profileId;

  const CreateProjectScreen({super.key, required this.profileId});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  List<bool> isItemsLoading = List.generate(4, (index) => false);
  List<(File?, MediaType?)> items = List.generate(4, (index) => (null, null));
  List<Uint8List?> videosFrame = List.generate(4, (index) => null);

  bool isProjectCreateLoading = false;

  TextEditingController areaTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();

  ProjectController projectController =
      Get.find(tag: ControllersKey.projectControllerKey);

  CityController cityController = Get.find(
    tag: ControllersKey.cityControllerKey,
  );
  City? selectedCity;

  Future<void> onPickFile(int index) async {
    if (isProjectCreateLoading) return;
    if (items[index].$1 == null) {
      setState(() {
        isItemsLoading[index] = true;
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
            videosFrame[index] = null;
          } else if (mimeType?.startsWith('video/') ?? false) {
            type = MediaType.video;
            videosFrame[index] = await getFirstFrame(filePath);
          }
        }

        if (type != null) {
          items[index] = (selectedFile, type);
        }
      } else {
        // User canceled the picker
      }

      setState(() {
        isItemsLoading[index] = false;
      });
    } else {
      setState(() {
        items[index] = (null, null);
      });
    }
  }

  Future<Uint8List?> getFirstFrame(String filePath) async {
    return await VideoThumbnail.thumbnailData(
      video: filePath,
      imageFormat: ImageFormat.PNG,
      maxWidth: 128,
      quality: 75,
    );
  }

  Future<void> createProject() async {
    for (var loading in isItemsLoading) {
      if (loading) return;
    }

    bool hasError = false;
    String message = "";
    if (areaTextController.text.isEmpty) {
      hasError = true;
      message = "لطفا متراژ را وارد کنید";
    } else if (selectedCity == null) {
      hasError = true;
      message = "لطفا شهر را وارد کنید";
    } else if (addressTextController.text.isEmpty) {
      hasError = true;
      message = "لطفا آدرس را وارد کنید";
    } else if (descriptionTextController.text.isEmpty) {
      hasError = true;
      message = "لطفا توضیحات را وارد کنید";
    }

    if (hasError) {
      showSnackbarMessage(
        context: context,
        message: message,
      );
      return;
    }

    setState(() {
      isProjectCreateLoading = true;
    });

    await projectController
        .createProjectWithMaster(
      description: descriptionTextController.text,
      area: areaTextController.text,
      address: addressTextController.text,
      cityId: selectedCity?.id ?? -1,
      posts: items,
      profileId: widget.profileId,
    )
        .then((value) {
      if (!value) {
        showSnackbarMessage(
          context: context,
          message: projectController.apiMessage,
        );
      } else {
        Get.back();
      }
    });

    setState(() {
      isProjectCreateLoading = false;
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
      body: SafeArea(
        bottom: true,
        child: SizedBox(
          height: SizeController.height(context),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  margin: globalPadding * 6,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: globalBorderRadius * 6,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
                      Column(
                        verticalDirection: VerticalDirection.up,
                        children: [
                          Container(
                            margin: globalPadding * 5,
                            height: 220,
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
                                    isItemsLoading[index]
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                            ),
                                          )
                                        : items[index].$1 != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    globalBorderRadius * 10,
                                                child: items[index].$2 ==
                                                        MediaType.image
                                                    ? Image.file(
                                                        items[index].$1!,
                                                        width: 150,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.memory(
                                                        videosFrame[index] ??
                                                            Uint8List(0),
                                                        width: 150,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                      ),
                                              )
                                            : InkWell(
                                                onTap: () async {
                                                  await onPickFile(index);
                                                },
                                                child: Container(
                                                  width: 150,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        globalBorderRadius * 10,
                                                    color: theme
                                                        .colorScheme.secondary
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
                                              (items[index].$1 == null)
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
                          // InkWell(
                          //   onTap: () async {
                          //     await onPickFile();
                          //   },
                          //   child: Container(
                          //     width: 100,
                          //     padding: const EdgeInsets.only(
                          //         top: 3, bottom: 5, left: 8, right: 8),
                          //     decoration: BoxDecoration(
                          //       color: theme.colorScheme.tertiary
                          //           .withValues(alpha: 0.75),
                          //       borderRadius: globalBorderRadius * 3,
                          //       border: Border(
                          //         top: BorderSide(
                          //           color: theme.colorScheme.onSurface
                          //               .withValues(alpha: 0.5),
                          //         ),
                          //       ),
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: theme.colorScheme.onPrimary,
                          //           offset: const Offset(-5, -5),
                          //           blurRadius: 50,
                          //           spreadRadius: 5,
                          //         )
                          //       ],
                          //     ),
                          //     child: Center(
                          //       child: Text(
                          //         "اپلود عکس",
                          //         style: theme.textTheme.bodyLarge,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      Padding(
                        padding: globalPadding * 8,
                        child: MyDivider(
                          color: theme.colorScheme.onSurface,
                          height: 1,
                          thickness: 1,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        margin: globalPadding * 10,
                        padding:
                            const EdgeInsets.only(bottom: 5, right: 9, left: 9),
                        decoration: BoxDecoration(
                          color: AppColors.textFieldColor,
                          borderRadius: globalBorderRadius * 4,
                        ),
                        child: TextField(
                          controller: addressTextController,
                          style: theme.textTheme.labelLarge
                              ?.copyWith(color: theme.colorScheme.surface),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "آدرس",
                            hintStyle: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.surface
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Padding(
                        padding: globalPadding * 10,
                        child: AddressDropdownWidget(
                          cityOnTap: (City city) {
                            selectedCity = city;
                          },
                          itemsDistanceHeight: 7,
                          fontSize: 16,
                          dropDownHeight: 52,
                          dropDownColor: AppColors.sideColor,
                          selectedColor:
                              AppColors.sideColor.withValues(alpha: 0.55),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        margin: globalPadding * 10,
                        padding:
                            const EdgeInsets.only(bottom: 5, right: 9, left: 9),
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
                            hintText: "متراژ",
                            hintStyle: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.surface
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        margin: globalPadding * 10,
                        padding:
                            const EdgeInsets.only(bottom: 5, right: 9, left: 9),
                        decoration: BoxDecoration(
                          color: AppColors.textFieldColor,
                          borderRadius: globalBorderRadius * 4,
                        ),
                        child: TextField(
                          controller: descriptionTextController,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.surface,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "توضیحات",
                            hintStyle: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.surface
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 23),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: globalPadding * 11,
                  child: MyDivider(
                    color: theme.colorScheme.onSecondary,
                    height: 1,
                    thickness: 1,
                  ),
                ),
                const SizedBox(height: 12),
                (isProjectCreateLoading)
                    ? SpinKitThreeBounce(
                        size: 14,
                        color: theme.colorScheme.onSecondary,
                      )
                    : ButtonItem(
                        onTap: () async => await createProject(),
                        isButtonDisable: isProjectCreateLoading,
                        title: "ایجاد",
                        color: theme.colorScheme.tertiary,
                        textStyle: theme.textTheme.bodyLarge,
                      ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
