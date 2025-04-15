import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:mime/mime.dart';

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

  bool createProjectLoading = false;

  bool negotiatedPrice = false;

  @override
  void initState() {
    super.initState();
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
      //FIXME : show error
      return;
    }

    setState(() {
      createProjectLoading = true;
    });

    await projectController
        .createProjectForEmployer(
      caption: captionTextController.text,
      area: areaTextController.text,
      isPriceAgreed: negotiatedPrice,
      duration: offeredTimeTextController.text,
      price: priceTextController.text,
      cityId: selectedCity?.id ?? -1,
      posts: items,
    )
        .then((value) {
      if (!value) {
      } else {
        Get.back();
        Get.showSnackbar(const GetSnackBar(
          title: "ایجاد",
          message: "پروژه با موفقیت ایجاد شد",
          duration: Duration(seconds: 2),
        ));
      }
    });

    setState(() {
      createProjectLoading = false;
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
                          return Stack(
                            children: [
                              isItemsLoading[index]
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    )
                                  : items[index].$1 != null
                                      ? ClipRRect(
                                          borderRadius: globalBorderRadius * 10,
                                          child:
                                              items[index].$2 == MediaType.image
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
              (createProjectLoading)
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
