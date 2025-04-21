import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

import '/models/employer_project.dart';
import '/res/app_colors.dart';
import '/screens/project_details_screen.dart';
import '/widgets/custom_cached_image.dart';
import '/widgets/custom_shimmer.dart';
import '/widgets/shadow_button.dart';
import '/res/enums/media_type.dart';
import '/global_configs.dart';
import '../my_divider.dart';

class ProjectsItem extends StatefulWidget {
  final EmployerProject project;

  const ProjectsItem({super.key, required this.project});

  @override
  State<ProjectsItem> createState() => _ProjectsItemState();
}

class _ProjectsItemState extends State<ProjectsItem> {
  String? postUrl;
  Uint8List? postImage;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initPostImage();
  }

  Future<void> initPostImage() async {
    setState(() {
      isLoading = true;
    });
    if (widget.project.items.isNotEmpty) {
      if (widget.project.items[0].itemType == MediaType.video) {
        postImage = await getFirstFrame(widget.project.items[0].file);
      } else {
        postUrl = widget.project.items[0].file;
      }
    }

    setState(() {
      isLoading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: () {
        Get.to(
          ProjectDetailsScreen(project: widget.project),
        );
      },
      child: Container(
        margin: globalPadding * 5.5,
        padding: globalPadding * 7,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: globalBorderRadius * 6,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            isLoading
                ? CustomShimmer(
                    child: Container(
                      width: 265,
                      height: 180,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface,
                        borderRadius: globalBorderRadius * 5,
                      ),
                    ),
                  )
                : postUrl != null
                    ? ClipRRect(
                        borderRadius: globalBorderRadius * 5,
                        child: CustomCachedImage(
                          url: postUrl!,
                          width: 265,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      )
                    : postImage != null
                        ? ClipRRect(
                            borderRadius: globalBorderRadius * 5,
                            child: Image.memory(
                              postImage!,
                              width: 265,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(),
            const SizedBox(height: 7),
            Padding(
              padding: globalPadding * 7,
              child: MyDivider(
                color: AppColors.paleBlack,
                height: 1,
                thickness: 1,
              ),
            ),
            const SizedBox(height: 9),
            Padding(
              padding: globalPadding * 7,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.project.caption,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.surface,
                        fontSize: 8,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      ShadowButton(
                        onTap: () {},
                        width: 70,
                        text: "جزئیات",
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: globalPadding,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/price_arrow.svg",
                              width: 8,
                              height: 8,
                            ),
                            Text(
                              widget.project.price.toString(),
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.surface,
                                fontSize: 10,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
