import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '/controllers/post_controller.dart';
import '/models/post.dart';
import '/res/controllers_key.dart';
import '/widgets/custom_cached_image.dart';
import '/models/post_item.dart';
import '/global_configs.dart';
import '/res/app_colors.dart';
import '../small_button.dart';

class PostSection extends StatefulWidget {
  final Post? post;
  const PostSection({super.key, this.post});

  @override
  State<PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<PostSection> {
  PostController postController = Get.find(
    tag: ControllersKey.postControllerKey,
  );

  TextEditingController captionTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.post != null){
      initEditValues();
    }
  }

  void initEditValues(){
    List<PostItem> items = widget.post!.items;
    for(int i=0;i<items.length;i++){
      postController.networkImages.add(items[i].file);
      postController.picturesLoading[i] = true;
    }

    captionTextController.text = widget.post!.caption;
  }

  Future<void> onPickFile(int index) async {
    if (postController.images[index] == null &&
        postController.networkImages.length <= index) {
      setState(() {
        postController.picturesLoading[index] = true;
      });
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        postController.images[index] = files.isNotEmpty ? files[0] : null;
      } else {
        // User canceled the picker
      }

      setState(() {
        postController.picturesLoading[index] = false;
      });
    } else if(postController.networkImages.length > index) {
      setState(() {
        postController.networkImages.removeAt(index);
      });
    }
    else{
      setState(() {
        postController.images[index] = null;
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
                  postController.picturesLoading[index]
                      ? Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.onPrimary,
                          ),
                        )
                      : postController.images[index] != null
                          ? Image.file(
                              postController.images[index]!,
                              width: 150,
                              height: 100,
                            )
                          : postController.networkImages.length > index ?
                            CustomCachedImage(
                              url: postController.networkImages[index],
                              width: 150, height: 100,) :
                            InkWell(
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
                            (postController.images[index] == null || postController.networkImages.length <= index) ?
                              Icons.add : Icons.close,
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
        if(postController.createPostLoading)
          SpinKitThreeBounce(
            size: 14,
            color: theme.colorScheme.onSecondary,
          )
        else
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
          onTap: () async {
          },
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
                    controller: captionTextController,
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
