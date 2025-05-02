import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:kanaf/res/enums/project_type.dart';
import 'package:kanaf/screens/profile/offers_screen.dart';
import 'package:path_provider/path_provider.dart';

import '/res/enums/media_type.dart';
import '/models/employer_project.dart';
import '/controllers/size_controller.dart';
import '/screens/profile/employer_create_project_screen.dart';
import '/controllers/authentication_controller.dart';
import '/controllers/project_controller.dart';
import '/models/employer_user.dart';
import '/res/controllers_key.dart';
import '/widgets/custom_shimmer.dart';
import '/widgets/my_divider.dart';
import '/global_configs.dart';
import '/res/app_colors.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/custom_cached_image.dart';
import '/widgets/custom_error_widget.dart';
import '/widgets/profile/activate_employer_profile_section.dart';

class EmployerProfileScreen extends StatefulWidget {
  const EmployerProfileScreen({super.key});

  @override
  State<EmployerProfileScreen> createState() => _EmployerProfileScreenState();
}

class _EmployerProfileScreenState extends State<EmployerProfileScreen> {
  bool isLoading = false;
  bool isFailed = false;

  List<Uint8List?> videosFirstFrame = [];

  AuthenticationController authController = Get.find(
    tag: ControllersKey.authControllerKey,
  );

  ProjectController projectController = Get.find(
    tag: ControllersKey.projectControllerKey,
  );

  EmployerUser? employerProfile;
  List<EmployerProject?> projects = [];

  @override
  void initState() {
    super.initState();

    fetchEmployerProfileAndProjects();
  }

  Future<void> fetchEmployerProfileAndProjects() async {
    setState(() {
      isLoading = true;
      isFailed = false;
    });
    await authController.getEmployerProfile().then((value) async {
      if (value == null) {
        isFailed = true;
      } else {
        employerProfile = value;

        await projectController.getEmployerProjects().then((value) async {
          if (value == null) {
            isFailed = true;
          } else {
            projects = value;
            for (var post in projects) {
              if (post?.items.isNotEmpty ?? false) {
                if (post!.items[0].itemType == MediaType.video) {
                  videosFirstFrame.add(
                    await getFirstFrame(post.items[0].file),
                  );
                } else {
                  videosFirstFrame.add(null);
                }
              } else {
                videosFirstFrame.add(null);
              }
            }
          }
        });
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
      appBar: CustomAppbar(
        onTap: () => Navigator.pop(context),
        iconAsset: "assets/icons/arrow_back_19.png",
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLoading)
            CustomShimmer(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface,
                      borderRadius: globalBorderRadius * 2,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface,
                          borderRadius: globalBorderRadius * 4,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface,
                          borderRadius: globalBorderRadius * 4,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          else if (isFailed)
            Center(
              child: CustomErrorWidget(
                onTap: () async {
                  await fetchEmployerProfileAndProjects();
                },
              ),
            )
          else ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: globalAllPadding,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.avatarBorderColor,
                      width: 5,
                    ),
                  ),
                  child: ClipOval(
                    child: CustomCachedImage(
                      url: authController.user?.avatar ?? '',
                      width: 88,
                      height: 88,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'پروژه های من',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w300,
                    color: theme.colorScheme.tertiary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 9),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () {
                    // showDialog(
                    //   context: context,
                    //   builder: (context) {
                    //     return ActivateEmployerProfileSection(
                    //       employerUser: employerProfile,
                    //     );
                    //   },
                    // ).then((value) async {
                    //   await fetchEmployerProfileAndProjects();
                    // });
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const OffersScreen(type: ProjectType.received);
                        },
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiary,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    fixedSize: const Size.fromWidth(150),
                  ),
                  child: Text(
                    "پیشنهادهای ورودی",
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: () {
                    Get.to(
                      const EmployerCreateProjectScreen(
                        project: null,
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiary,
                    fixedSize: const Size.fromWidth(150),
                  ),
                  child: Text(
                    "پروژه جدید",
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: globalPadding * 10,
              child: const MyDivider(
                color: Color(0xff333333),
                height: 1,
                thickness: 1,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: SizeController.width(context),
              padding: globalPadding * 11,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 11,
                children: isLoading
                    ? List.generate(3, (index) {
                        return CustomShimmer(
                          child: Container(
                            width: 135,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: globalBorderRadius * 5,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        );
                      })
                    : List.generate(
                        projects.length,
                        (index) {
                          return SizedBox(
                            height: 125,
                            width: 140,
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 5,
                                  bottom: 5,
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(
                                        EmployerCreateProjectScreen(
                                          project: projects[index],
                                        ),
                                      )?.then((value) {
                                        if (value != null && value) {
                                          fetchEmployerProfileAndProjects();
                                        }
                                      });
                                    },
                                    child: Container(
                                        width: 135,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          borderRadius: globalBorderRadius * 5,
                                          color:
                                              (projects[index]?.items.isEmpty ??
                                                      true)
                                                  ? theme.colorScheme.primary
                                                  : null,
                                        ),
                                        child: (projects[index]
                                                    ?.items
                                                    .isEmpty ??
                                                true)
                                            ? Container()
                                            : videosFirstFrame[index] == null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        globalBorderRadius * 5,
                                                    child: CustomCachedImage(
                                                      url: projects[index]
                                                              ?.items[0]
                                                              .file ??
                                                          '',
                                                      width: 265,
                                                      height: 180,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        globalBorderRadius * 5,
                                                    child: Image.memory(
                                                      videosFirstFrame[index] ??
                                                          Uint8List(0),
                                                      width: 265,
                                                      height: 180,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Image.asset(
                                    "assets/images/edit-pen.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
    // const SizedBox(height: 25),
    // Column(
    //   children: [
    //     if (authenticationController.user?.masterProfileId != null ||
    //         authenticationController.user?.employerProfileId !=
    //             null) ...[
    //       ButtonItem(
    //         onTap: () {
    //           Get.to(const WorksReportScreen());
    //         },
    //         title: "گزارش کارها",
    //         color: theme.colorScheme.tertiary,
    //       ),
    //       const SizedBox(height: 11),
    //       ButtonItem(
    //         onTap: () {
    //           showMasterOrEmployerUser((bool isMaster) {
    //             Get.back();
    //             Get.to(
    //               DetailsScreen(
    //                 isMaster: isMaster,
    //                 id: authenticationController
    //                         .user?.masterProfileId ??
    //                     authenticationController
    //                         .user?.employerProfileId ??
    //                     0,
    //                 isComeFromProfile: true,
    //               ),
    //             );
    //           });
    //         },
    //         title: "ویرایش صفحه",
    //         color:
    //             theme.colorScheme.secondary.withValues(alpha: 0.53),
    //       ),
    //       const SizedBox(height: 11),
    //       ButtonItem(
    //         onTap: () {
    //           showMasterOrEmployerUser((bool isMaster) {
    //             Get.back();
    //             Navigator.of(context).push(
    //               MaterialPageRoute(
    //                 builder: (context) {
    //                   return CreatePostStoryScreen(
    //                     isStory: false,
    //                     isMaster: isMaster,
    //                   );
    //                 },
    //               ),
    //             );
    //           });
    //         },
    //         title: "پست جدید",
    //         color:
    //             theme.colorScheme.secondary.withValues(alpha: 0.53),
    //       ),
    //       const SizedBox(height: 11),
    //       ButtonItem(
    //         onTap: () {
    //           showMasterOrEmployerUser((bool isMaster) {
    //             Get.back();
    //             Navigator.of(context).push(
    //               MaterialPageRoute(
    //                 builder: (context) {
    //                   return CreatePostStoryScreen(
    //                     isStory: true,
    //                     isMaster: isMaster,
    //                   );
    //                 },
    //               ),
    //             );
    //           });
    //         },
    //         title: "استوری جدید",
    //         color:
    //             theme.colorScheme.secondary.withValues(alpha: 0.53),
    //       ),
    //       const SizedBox(height: 11),
    //     ],
    //     if (authenticationController.user?.masterProfileId ==
    //         null) ...[
    // InkWell(
    //   onTap: () {
    //     if (masterRequestTypes ==
    //             MasterRequestTypes.inProgress ||
    //         masterRequestTypes ==
    //             MasterRequestTypes.inActive) {
    //       showDialog(
    //         context: context,
    //         builder: (context) {
    //           return Dialog(
    //             backgroundColor: theme.colorScheme.primary,
    //             child: ActivateProfileStatus(
    //               type: masterRequestTypes!,
    //               text: reasonText ?? '',
    //               onTap: () {
    //                 showActivateMasterDialog();
    //               },
    //             ),
    //           );
    //         },
    //       );
    //     } else {
    //       showActivateMasterDialog();
    //     }
    //   },
    //   child: Stack(
    //     children: [
    //       SizedBox(
    //         width: 200,
    //         height: 86,
    //         child: SvgPicture.asset(
    //           'assets/images/calculate_button_svg.svg',
    //           width: 200,
    //           height: 86,
    //           fit: BoxFit.cover,
    //           colorFilter: ColorFilter.mode(
    //             theme.colorScheme.tertiary,
    //             BlendMode.srcIn,
    //           ),
    //         ),
    //       ),
    //       Positioned(
    //         left: 0,
    //         right: 0,
    //         top: 0,
    //         bottom: 20,
    //         child: Center(
    //           child: Text(
    //             "فعال سازی صفحه استادکار${masterRequestTypes == MasterRequestTypes.inProgress ? "(در انتظار تایید)" : masterRequestTypes == MasterRequestTypes.inActive ? '(عدم تایید)' : ''}",
    //             style:
    //                 theme.textTheme.headlineSmall?.copyWith(
    //               fontWeight: FontWeight.w300,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // ),
    //     ButtonItem(
    //       onTap: () {
    //         if (masterRequestTypes ==
    //                 MasterRequestTypes.inProgress ||
    //             masterRequestTypes == MasterRequestTypes.inActive) {
    //           showDialog(
    //             context: context,
    //             builder: (context) {
    //               return Dialog(
    //                 backgroundColor: theme.colorScheme.primary,
    //                 child: ActivateProfileStatus(
    //                   type: masterRequestTypes!,
    //                   text: reasonText ?? '',
    //                   onTap: () {
    //                     showActivateMasterDialog();
    //                   },
    //                 ),
    //               );
    //             },
    //           );
    //         } else {
    //           showActivateMasterDialog();
    //         }
    //       },
    //       title:
    //           "فعال سازی صفحه استادکار${masterRequestTypes == MasterRequestTypes.inProgress ? "(در انتظار تایید)" : masterRequestTypes == MasterRequestTypes.inActive ? '(عدم تایید)' : ''}",
    //       color:
    //           theme.colorScheme.secondary.withValues(alpha: 0.53),
    //     ),
    //     const SizedBox(height: 11),
    //   ],
    //   if (authenticationController.user?.employerProfileId ==
    //       null) ...[
    //     ButtonItem(
    //       onTap: () {
    //         showDialog(
    //           context: context,
    //           builder: (context) {
    //             return const ActivateEmployerProfileSection();
    //           },
    //         ).then((value) async {
    //           await fetchUserValues(true);
    //         });
    //       },
    //       title: "فعال سازی صفحه کارفرما",
    //       color:
    //           theme.colorScheme.secondary.withValues(alpha: 0.53),
    //     ),
    //     const SizedBox(height: 20),
    //   ],
  }
}
