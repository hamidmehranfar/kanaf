import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:kanaf/controllers/project_controller.dart';
import 'package:kanaf/res/controllers_key.dart';

import '/controllers/size_controller.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/button_item.dart';
import '/global_configs.dart';
import '/res/app_colors.dart';
import '/widgets/my_divider.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  bool isImageLoading = false;
  bool isProjectCreateLoading = false;
  File? image;

  TextEditingController cityTextController = TextEditingController();
  TextEditingController areaTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  
  ProjectController projectController = Get.find(tag: ControllersKey.projectControllerKey);

  Future<void> onPickFile() async {
    setState(() {
      isImageLoading = true;
    });
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      image = files.isNotEmpty ? files[0] : null;
    } else {
      // User canceled the picker
    }

    setState(() {
      isImageLoading = false;
    });
  }
  
  Future<void> createProject() async {
    bool hasError = false;
    String message = "";
    if(areaTextController.text.isEmpty){
      hasError = true;
      message = "لطفا متراژ را وارد کنید";
    }
    else if(cityTextController.text.isEmpty){
      hasError = true;
      message = "لطفا شهر را وارد کنید";
    }
    else if(addressTextController.text.isEmpty){
      hasError = true;
      message = "لطفا آدرس را وارد کنید";
    }
    else if(descriptionTextController.text.isEmpty){
      hasError = true;
      message = "لطفا توضیحات را وارد کنید";
    }
    print(hasError);
    if(hasError){
      //FIXME : show error
      return;
    }

    setState(() {
      isProjectCreateLoading = true;
    });

    //FIXME : here must define fields
    await projectController.createProject(
      description: descriptionTextController.text,
      area: areaTextController.text,
      address: addressTextController.text,
      city: cityTextController.text,
    ).then((value){
      if(!value){

      }
      else{
        Get.back();
        Get.showSnackbar(const GetSnackBar(
          title: "ایجاد",
          message: "پروژه با موفقیت ایجاد شد",
          duration: Duration(seconds: 2),
        ));
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
        onTap: (){
          Navigator.of(context).pop();
        },
        iconAsset: "assets/icons/arrow_back_19.png",
      ),
      body: SizedBox(
        height: SizeController.height(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              Text("ایجاد پروژه", style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w300,
                color: theme.colorScheme.tertiary
              ),),
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
                        InkWell(
                          onTap: () async {
                            await onPickFile();
                          },
                          child: Container(
                              width: 100,
                              padding: const EdgeInsets.only(
                                  top: 3,
                                  bottom: 5,
                                  left: 8,
                                  right: 8
                              ),
                              decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiary.withOpacity(0.75),
                                  borderRadius: globalBorderRadius * 3,
                                  border: Border(
                                    top: BorderSide(
                                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: theme.colorScheme.onPrimary,
                                        offset: const Offset(-5, -5),
                                        blurRadius: 50,
                                        spreadRadius: 5
                                    )
                                  ]
                              ),
                              child: Center(
                                child: Text("اپلود عکس", style: theme.textTheme.bodyLarge,),
                              )
                          ),
                        ),
                        if(image != null)...[
                          const SizedBox(height: 18),
                          Padding(
                            padding: globalPadding * 7,
                            child: ClipRRect(
                              borderRadius: globalBorderRadius * 5,
                              child: Image.file(image!,width: 260,height: 180,),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 13,),
                    Padding(
                      padding: globalPadding * 8,
                      child: MyDivider(
                        color: theme.colorScheme.onSurface,
                        height: 1,
                        thickness: 1,
                      ),
                    ),
                    const SizedBox(height: 14,),
                    Container(
                      margin: globalPadding * 10,
                      padding: const EdgeInsets.only(bottom: 5, right: 9,left: 9),
                      decoration: BoxDecoration(
                        color: AppColors.textFieldColor,
                        borderRadius: globalBorderRadius * 4,
                      ),
                      child: TextField(
                        controller: addressTextController,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.surface
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "آدرس",
                          hintStyle: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.surface.withOpacity(0.5)
                          )
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      margin: globalPadding * 10,
                      padding: const EdgeInsets.only(bottom: 5, right: 9,left: 9),
                      decoration: BoxDecoration(
                        color: AppColors.textFieldColor,
                        borderRadius: globalBorderRadius * 4,
                      ),
                      child: TextField(
                        controller: cityTextController,
                        style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.surface
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "شهر",
                            hintStyle: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.surface.withOpacity(0.5)
                            )
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      margin: globalPadding * 10,
                      padding: const EdgeInsets.only(bottom: 5, right: 9,left: 9),
                      decoration: BoxDecoration(
                        color: AppColors.textFieldColor,
                        borderRadius: globalBorderRadius * 4,
                      ),
                      child: TextField(
                        controller: areaTextController,
                        style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.surface
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "متراژ",
                            hintStyle: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.surface.withOpacity(0.5)
                            )
                        ),
                      ),
                    ),
                    const SizedBox(height: 7,),
                    Container(
                      margin: globalPadding * 10,
                      padding: const EdgeInsets.only(bottom: 5, right: 9,left: 9),
                      decoration: BoxDecoration(
                        color: AppColors.textFieldColor,
                        borderRadius: globalBorderRadius * 4,
                      ),
                      child: TextField(
                        controller: descriptionTextController,
                        style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.surface
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "توضیحات",
                            hintStyle: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.surface.withOpacity(0.5)
                            )
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
                  height: 1,thickness: 1,
                ),
              ),
              const SizedBox(height: 12),
              (isProjectCreateLoading || isImageLoading) ?
              SpinKitThreeBounce(
                size: 14,
                color: theme.colorScheme.onSecondary,
              ) :
              ButtonItem(
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
    );
  }
}
