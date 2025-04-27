import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

import '/widgets/post/posts_grid_section.dart';
import '/res/enums/media_type.dart';
import '/controllers/post_controller.dart';
import '/res/controllers_key.dart';
import '/controllers/size_controller.dart';
import '/res/app_colors.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/my_divider.dart';
import '/global_configs.dart';

class SearchScreen extends StatefulWidget {
  final bool isMainScreen;

  const SearchScreen({super.key, required this.isMainScreen});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextController = TextEditingController();

  bool isLoading = false;
  bool isFailed = false;

  PostController postController = Get.find(
    tag: ControllersKey.postControllerKey,
  );

  List<Uint8List?> videosFirstFrame = [];

  @override
  void initState() {
    super.initState();

    postController.posts.clear();
  }

  Future<void> fetchPosts() async {
    setState(() {
      isLoading = true;
    });

    videosFirstFrame.clear();

    await postController
        .getSearchPosts(searchTextController.text)
        .then((values) async {
      if (values) {
        for (var post in postController.posts) {
          if (post.items.isNotEmpty) {
            if (post.items[0].itemType == MediaType.video) {
              videosFirstFrame.add(await getFirstFrame(post.items[0].file));
            } else {
              videosFirstFrame.add(null);
            }
          }
        }
      } else {
        isFailed = true;
      }
    });

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
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: CustomAppbar(
        onTap: () {
          Navigator.of(context).pop();
        },
        icon: Icons.menu,
        hasShadow: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 17),
          Text(
            "بررسی",
            style: theme.textTheme.headlineLarge?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: globalPadding * 11,
            child: MyDivider(
              color: theme.colorScheme.onSecondary,
              height: 1,
              thickness: 1,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: SizeController.width(context),
            height: 63,
            margin: globalPadding * 6,
            padding:
                const EdgeInsets.only(left: 11, right: 11, top: 8, bottom: 8),
            decoration: BoxDecoration(
              borderRadius: globalBorderRadius * 5,
              color: theme.colorScheme.primary,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.tertiary,
                  offset: const Offset(-3, -3),
                ),
                BoxShadow(
                  color: theme.colorScheme.onSecondary,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: AppColors.textFieldColor,
                borderRadius: globalBorderRadius * 5,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      style: theme.textTheme.labelLarge
                          ?.copyWith(color: theme.colorScheme.surface),
                      controller: searchTextController,
                      autofocus: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: "جستجو",
                        hintStyle: theme.textTheme.labelMedium?.copyWith(
                          color:
                              theme.colorScheme.surface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: IconButton(
                      onPressed: () async {
                        await fetchPosts();
                      },
                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                      ),
                      icon: Icon(
                        Icons.search,
                        size: 25,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8)
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: PostsGridSection(
              key: const ValueKey("search"),
              isLoading: isLoading,
              isFailed: isFailed,
              onTap: fetchPosts,
              isComeFromProfile: false,
              videosFrame: videosFirstFrame,
              padding: globalPadding * 2,
            ),
          ),
        ],
      ),
    );
  }
}
