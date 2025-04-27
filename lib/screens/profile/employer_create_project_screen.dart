import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:kanaf/res/enums/message_type.dart';
import 'package:kanaf/widgets/custom_shimmer.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../widgets/error_snack_bar.dart';
import '/widgets/custom_cached_image.dart';
import '/models/employer_project.dart';
import '/controllers/size_controller.dart';
import '/widgets/custom_check_box.dart';
import '/controllers/city_controller.dart';
import '/models/city.dart';
import '/widgets/address_dropdown_widget.dart';
import '/widgets/button_item.dart';
import '/controllers/project_controller.dart';
import '/res/controllers_key.dart';
import '/global_configs.dart';
import '/res/app_colors.dart';
import '/res/enums/media_type.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/my_divider.dart';

class EmployerCreateProjectScreen extends StatefulWidget {
  final EmployerProject? project;

  const EmployerCreateProjectScreen({
    super.key,
    required this.project,
  });

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

  CityController cityController = Get.find(
    tag: ControllersKey.cityControllerKey,
  );
  City? selectedCity;

  ProjectController projectController = Get.find(
    tag: ControllersKey.projectControllerKey,
  );

  List<bool> isItemsLoading = List.generate(4, (index) => false);
  List<(File?, MediaType?)> items = List.generate(4, (index) => (null, null));
  List<Uint8List?> videosFrame = List.generate(4, (index) => null);

  List<(String?, MediaType?)> projectItems =
      List.generate(4, (index) => (null, null));

  bool createProjectLoading = false;
  bool editProjectLoading = false;
  bool deleteProjectLoading = false;

  bool initValuesLoading = false;

  bool negotiatedPrice = false;

  @override
  void initState() {
    super.initState();

    if (widget.project != null) {
      initValues();
    }
  }

  Future<void> initValues() async {
    setState(() {
      initValuesLoading = true;
    });

    captionTextController.text = widget.project!.caption;
    priceTextController.text = widget.project!.price == null
        ? ''
        : widget.project!.price.toString().toPersianDigit();
    offeredTimeTextController.text =
        widget.project!.duration.toString().toPersianDigit();
    areaTextController.text = widget.project!.area.toString().toPersianDigit();
    selectedCity = widget.project!.city;

    negotiatedPrice = widget.project!.isPriceAgreed;

    for (int i = 0; i < widget.project!.items.length; i++) {
      MediaType? type = widget.project!.items[i].itemType;
      String? url = widget.project!.items[i].file;
      if (type == MediaType.video) {
        videosFrame[i] = await getFirstFrame(url);
      }
      projectItems[i] =
          (widget.project!.items[i].file, widget.project!.items[i].itemType);
    }
    setState(() {
      initValuesLoading = false;
    });
  }

  Future<void> onPickFile(int index) async {
    if (createProjectLoading) return;
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

  Future<Uint8List?> getFirstFrame(String videoUrl) async {
    try {
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/temp_video.mp4';

      // Download video using Dio
      Dio dio = Dio();
      await dio.download(videoUrl, filePath);

      // Generate thumbnail from the downloaded file
      final thumbnail = await VideoThumbnail.thumbnailData(
        video: filePath,
        imageFormat: ImageFormat.PNG,
        maxWidth: 128,
        quality: 75,
      );

      return thumbnail;
    } catch (e) {
      return null;
    }
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
    } else if (captionTextController.text.isEmpty) {
      hasError = true;
      message = "لطفا کپشن را وارد کنید";
    } else if (priceTextController.text.isEmpty) {
      hasError = true;
      message = "لطفا قیمت را وارد کنید";
    } else if (offeredTimeTextController.text.isEmpty) {
      hasError = true;
      message = "لطفا مدت زمان پیشنهادی را وارد کنید";
    }

    if (hasError) {
      showSnackbarMessage(
        context: context,
        message: message,
      );
      return;
    }

    setState(() {
      createProjectLoading = true;
    });

    await projectController
        .createProjectForEmployer(
      caption: captionTextController.text,
      area: areaTextController.text.toEnglishDigit(),
      isPriceAgreed: negotiatedPrice,
      duration: offeredTimeTextController.text.toEnglishDigit(),
      price: priceTextController.text.toEnglishDigit(),
      cityId: selectedCity?.id ?? -1,
      posts: items,
    )
        .then((value) {
      if (!value) {
      } else {
        showSnackbarMessage(
          context: context,
          message: projectController.apiMessage,
        );
        Get.back();
      }
    });

    setState(() {
      createProjectLoading = false;
    });
  }

  Future<void> editProject() async {
    bool hasError = false;
    String message = "";
    if (areaTextController.text.isEmpty) {
      hasError = true;
      message = "لطفا متراژ را وارد کنید";
    } else if (selectedCity == null) {
      hasError = true;
      message = "لطفا شهر را وارد کنید";
    } else if (captionTextController.text.isEmpty) {
      hasError = true;
      message = "لطفا کپشن را وارد کنید";
    } else if (priceTextController.text.isEmpty) {
      hasError = true;
      message = "لطفا قیمت را وارد کنید";
    } else if (offeredTimeTextController.text.isEmpty) {
      hasError = true;
      message = "لطفا مدت زمان پیشنهادی را وارد کنید";
    }

    if (hasError) {
      showSnackbarMessage(
        context: context,
        message: message,
      );
      return;
    }

    Map data = {};

    if (areaTextController.text.toEnglishDigit() !=
        widget.project!.area.toString()) {
      data["area"] = areaTextController.text.toEnglishDigit();
    }
    if (selectedCity?.id != widget.project!.city?.id) {
      data["city"] = selectedCity?.id;
    }
    if (captionTextController.text != widget.project!.caption) {
      data["caption"] = captionTextController.text;
    }
    if (negotiatedPrice != widget.project!.isPriceAgreed) {
      data["is_price_agreed"] = negotiatedPrice;
    }
    if (priceTextController.text.toEnglishDigit() !=
        widget.project!.price.toString()) {
      data["price"] = priceTextController.text.toEnglishDigit();
    } else if (offeredTimeTextController.text.toEnglishDigit() !=
        widget.project!.duration.toString()) {
      data["duration"] = offeredTimeTextController.text.toEnglishDigit();
    }

    if (data.isEmpty) {
      Get.back(result: false);
    }

    setState(() {
      editProjectLoading = true;
    });

    await projectController
        .editEmployerProject(
      data: data,
      projectId: widget.project?.id ?? -1,
    )
        .then(
      (value) {
        if (value) {
          showSnackbarMessage(
            context: context,
            message: "پروژه با موفقیت تغییر شد",
            type: MessageType.success,
          );
          Get.back(result: true);
        } else {
          showSnackbarMessage(
            context: context,
            message: projectController.apiMessage,
          );
        }
      },
    );

    setState(() {
      editProjectLoading = false;
    });
  }

  Future<void> deleteProject() async {
    setState(() {
      deleteProjectLoading = true;
    });

    await projectController
        .deleteEmployerProject(
      projectId: widget.project?.id ?? -1,
    )
        .then((value) {
      if (value) {
        showSnackbarMessage(
          context: context,
          message: "پروژه با موفقیت حذف شد",
          type: MessageType.success,
        );
        Get.back(result: true);
      } else {
        showSnackbarMessage(
          context: context,
          message: projectController.apiMessage,
        );
      }
    });

    setState(() {
      deleteProjectLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(
        onTap: () => Get.back(),
        iconAsset: "assets/icons/arrow_back_19.png",
      ),
      body: SizedBox(
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
                margin: globalPadding * 5.5,
                padding: globalPadding * 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: globalBorderRadius * 6,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      margin: globalPadding * 10,
                      padding:
                          const EdgeInsets.only(bottom: 5, right: 9, left: 9),
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
                            color: theme.colorScheme.surface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: globalPadding * 10,
                      child: CustomCheckBox(
                        height: 52,
                        text: "قیمت توافقی",
                        color: AppColors.checkBoxColor,
                        onTap: () {
                          setState(() {
                            negotiatedPrice = !negotiatedPrice;
                          });
                        },
                        checkValue: negotiatedPrice,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: globalPadding * 10,
                      padding:
                          const EdgeInsets.only(bottom: 5, right: 9, left: 9),
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
                            color: theme.colorScheme.surface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        onChanged: (value) {
                          captionTextController.text = value.toPersianDigit();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: globalPadding * 10,
                      padding:
                          const EdgeInsets.only(bottom: 5, right: 9, left: 9),
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
                            color: theme.colorScheme.surface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        onChanged: (value) {
                          offeredTimeTextController.text =
                              value.toPersianDigit();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
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
                          hintText: "متراژ حدودی",
                          hintStyle: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.surface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        onChanged: (value) {
                          areaTextController.text = value.toPersianDigit();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: globalPadding * 10,
                      child: AddressDropdownWidget(
                        cityOnTap: (City city) {
                          selectedCity = city;
                        },
                        itemsDistanceHeight: 10,
                        fontSize: 12,
                        dropDownHeight: 52,
                        dropDownColor: AppColors.sideColor,
                        selectedColor:
                            AppColors.sideColor.withValues(alpha: 0.55),
                        selectedCity: widget.project?.city,
                      ),
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
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
                          if (initValuesLoading) {
                            return CustomShimmer(
                              child: Container(
                                width: 150,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: globalBorderRadius * 10,
                                  color: theme.colorScheme.secondary
                                      .withValues(alpha: 0.4),
                                ),
                              ),
                            );
                          } else {
                            Widget? itemWidget;
                            if (isItemsLoading[index]) {
                              itemWidget = Center(
                                child: CircularProgressIndicator(
                                  color: theme.colorScheme.onPrimary,
                                ),
                              );
                            } else if (widget.project != null &&
                                projectItems.length > index &&
                                projectItems[index].$1 != null) {
                              itemWidget = ClipRRect(
                                borderRadius: globalBorderRadius * 10,
                                child: projectItems[index].$2 == MediaType.image
                                    ? CustomCachedImage(
                                        url: projectItems[index].$1!,
                                        width: 150,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.memory(
                                        videosFrame[index] ?? Uint8List(0),
                                        width: 150,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                              );
                            } else if (items[index].$1 != null) {
                              itemWidget = ClipRRect(
                                borderRadius: globalBorderRadius * 10,
                                child: items[index].$2 == MediaType.image
                                    ? Image.file(
                                        items[index].$1!,
                                        width: 150,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.memory(
                                        videosFrame[index] ?? Uint8List(0),
                                        width: 150,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                              );
                            } else {
                              itemWidget = InkWell(
                                onTap: () async {
                                  if (widget.project != null) {
                                    await onPickFile(index);
                                  }
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
                              );
                            }
                            return Stack(
                              children: [
                                itemWidget,
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
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 17),
              Padding(
                padding: globalPadding * 11,
                child: MyDivider(
                  color: theme.colorScheme.onSecondary,
                  height: 1,
                  thickness: 1,
                ),
              ),
              const SizedBox(height: 12),
              if (widget.project != null) ...[
                editProjectLoading
                    ? SpinKitThreeBounce(
                        size: 14,
                        color: theme.colorScheme.onSecondary,
                      )
                    : ButtonItem(
                        width: 200,
                        height: 50,
                        onTap: () async => await editProject(),
                        isButtonDisable: editProjectLoading,
                        title: "ذخیره",
                        color: theme.colorScheme.tertiary,
                        textStyle: theme.textTheme.bodyLarge,
                      ),
                const SizedBox(height: 24),
                deleteProjectLoading
                    ? SpinKitThreeBounce(
                        size: 14,
                        color: theme.colorScheme.onSecondary,
                      )
                    : ButtonItem(
                        width: 200,
                        height: 50,
                        onTap: () async => await deleteProject(),
                        isButtonDisable: deleteProjectLoading,
                        title: "حذف پروژه",
                        color: theme.colorScheme.tertiary,
                        textStyle: theme.textTheme.bodyLarge,
                      ),
              ] else
                createProjectLoading
                    ? SpinKitThreeBounce(
                        size: 14,
                        color: theme.colorScheme.onSecondary,
                      )
                    : ButtonItem(
                        width: 200,
                        height: 50,
                        onTap: () async => await createProject(),
                        isButtonDisable: createProjectLoading,
                        title: "ایجاد",
                        color: theme.colorScheme.tertiary,
                        textStyle: theme.textTheme.bodyLarge,
                      ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
