import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '/controllers/authentication_controller.dart';
import '/controllers/city_controller.dart';
import '/res/controllers_key.dart';
import '/global_configs.dart';
import '/res/app_colors.dart';
import '../button_item.dart';
import '../my_divider.dart';

class ActivateMasterProfileSection extends StatefulWidget {
  const ActivateMasterProfileSection({super.key});

  @override
  State<ActivateMasterProfileSection> createState() =>
      _ActivateMasterProfileSectionState();
}

class _ActivateMasterProfileSectionState
    extends State<ActivateMasterProfileSection> {
  TextEditingController cityTextController = TextEditingController();

  AuthenticationController authController = Get.find(
    tag: ControllersKey.authControllerKey,
  );

  CityController cityController = CityController();

  bool isLoading = false;

  bool isNationalCardImageLoading = false;
  bool isJobImageLoading = false;

  File? nationalCardImage;
  File? jobImage;

  bool isMaster = false;
  bool isPainter = false;
  bool isLightLine = false;
  bool isElectronic = false;

  Future<void> pickFile(bool isNationalCode) async {
    setState(() {
      if (isNationalCode) {
        isNationalCardImageLoading = true;
      } else {
        isJobImageLoading = true;
      }
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      if (isNationalCode) {
        nationalCardImage = files.isNotEmpty ? files[0] : null;
      } else {
        jobImage = files.isNotEmpty ? files[0] : null;
      }
    } else {
      // User canceled the picker
    }

    setState(() {
      if (isNationalCode) {
        isNationalCardImageLoading = false;
      } else {
        isJobImageLoading = false;
      }
    });
  }

  Future<void> activateMaster() async {
    if (nationalCardImage == null) {
    } else if (jobImage == null) {
    } else if (cityTextController.text.isEmpty) {
      //FIXME : show error
      return;
    }

    setState(() {
      isLoading = true;
    });

    await authController
        .activateMasterProfile(
      nationalCardImage: nationalCardImage!,
      jobImage: jobImage!,
      cityId: 1,
      isMaster: isMaster,
      isLightLine: isLightLine,
      isPainter: isPainter,
      isElectronic: isElectronic,
    )
        .then((value) {
      if (value) {
        //FIXME : show success
        Get.back(result: true);
      } else {
        //FIXME : show error
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.colorScheme.primary,
      child: Container(
        padding: globalPadding * 6,
        decoration: BoxDecoration(
          borderRadius: globalBorderRadius * 6,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 25),
            Center(
              child: Text(
                'فرم فعال سازی',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 20,
                  color: theme.colorScheme.surface.withValues(alpha: 0.38),
                ),
              ),
            ),
            const SizedBox(height: 14),
            MyDivider(
              color: AppColors.textFieldColor,
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 20),
            if (isNationalCardImageLoading)
              const CircularProgressIndicator()
            else
              InkWell(
                onTap: () async {
                  if (nationalCardImage == null) {
                    await pickFile(true);
                  } else {
                    setState(() {
                      nationalCardImage = null;
                    });
                  }
                },
                child: Container(
                  height: 50,
                  margin: globalPadding * 5,
                  padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
                  decoration: BoxDecoration(
                    color: AppColors.textFieldColor,
                    borderRadius: globalBorderRadius * 3,
                  ),
                  child: Center(
                    child: Text(
                      nationalCardImage == null
                          ? 'عکس کارت ملی'
                          : nationalCardImage!.path.split('/').last,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: nationalCardImage == null
                            ? theme.colorScheme.surface.withValues(alpha: 0.5)
                            : AppColors.sideColor,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 7),
            if (isJobImageLoading)
              const CircularProgressIndicator()
            else
              InkWell(
                onTap: () async {
                  if (jobImage == null) {
                    await pickFile(false);
                  } else {
                    setState(() {
                      jobImage = null;
                    });
                  }
                },
                child: Container(
                  height: 50,
                  margin: globalPadding * 5,
                  padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
                  decoration: BoxDecoration(
                    color: AppColors.textFieldColor,
                    borderRadius: globalBorderRadius * 3,
                  ),
                  child: Center(
                    child: Text(
                      jobImage == null
                          ? 'عکس محل کار'
                          : jobImage!.path.split('/').last,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: jobImage == null
                            ? theme.colorScheme.surface.withValues(alpha: 0.5)
                            : AppColors.sideColor,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 7),
            Container(
              height: 50,
              margin: globalPadding * 5,
              padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
              decoration: BoxDecoration(
                color: AppColors.textFieldColor,
                borderRadius: globalBorderRadius * 4,
              ),
              child: TextField(
                controller: cityTextController,
                style: theme.textTheme.labelLarge
                    ?.copyWith(color: theme.colorScheme.surface),
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
            const SizedBox(height: 7),
            Padding(
              padding: globalPadding * 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'استاد کار',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: WidgetStatePropertyAll(
                      theme.colorScheme.primary,
                    ),
                    value: isMaster,
                    onChanged: (bool? value) {
                      setState(() {
                        isMaster = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: globalPadding * 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'نقاش',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: WidgetStatePropertyAll(
                      theme.colorScheme.primary,
                    ),
                    value: isPainter,
                    onChanged: (bool? value) {
                      setState(() {
                        isPainter = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: globalPadding * 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'لاین نوری',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: WidgetStatePropertyAll(
                      theme.colorScheme.primary,
                    ),
                    value: isLightLine,
                    onChanged: (bool? value) {
                      setState(() {
                        isLightLine = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: globalPadding * 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الکترونیک',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: WidgetStatePropertyAll(
                      theme.colorScheme.primary,
                    ),
                    value: isElectronic,
                    onChanged: (bool? value) {
                      setState(() {
                        isElectronic = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            MyDivider(
              color: AppColors.textFieldColor,
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 20),
            isLoading
                ? SpinKitThreeBounce(
                    size: 14,
                    color: theme.colorScheme.onSecondary,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonItem(
                        width: 200,
                        height: 50,
                        onTap: () async {
                          await activateMaster();
                        },
                        title: "ذخیره",
                        color: theme.colorScheme.tertiary,
                      ),
                    ],
                  ),
            const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}
