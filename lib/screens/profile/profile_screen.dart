import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/res/enums/master_request_types.dart';
import 'package:kanaf/widgets/custom_error_widget.dart';
import 'package:kanaf/widgets/custom_shimmer.dart';
import 'package:kanaf/widgets/profile/activate_master_profile_section.dart';
import 'package:kanaf/widgets/profile/activate_profile_status.dart';

import '/screens/details_screen.dart';
import '/controllers/authentication_controller.dart';
import '/res/controllers_key.dart';
import '/widgets/profile/activate_employer_profile_section.dart';
import '/widgets/custom_cached_image.dart';
import '/screens/profile/create_post_story_screen.dart';
import '/screens/profile/works_report_screen.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/my_divider.dart';
import '/widgets/button_item.dart';
import '/global_configs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  TabController? tabController;

  AuthenticationController authenticationController = Get.find(
    tag: ControllersKey.authControllerKey,
  );

  MasterRequestTypes? masterRequestTypes;
  String? reasonText;

  bool isLoading = true;
  bool isFailed = false;

  Future<void> fetchUserValues(bool needFetchUser) async {
    setState(() {
      isLoading = true;
      isFailed = false;
    });

    bool profileResult = true;

    if (needFetchUser) {
      profileResult = await authenticationController
          .getUser(authenticationController.user?.token ?? '');
    }

    if (profileResult) {
      var response = await authenticationController.getMasterStatus();
      masterRequestTypes = response.$1;
      reasonText = response.$2;
    } else {
      isFailed = true;
    }

    setState(() {
      isLoading = false;
    });
  }

  void showActivateMasterDialog() {
    showDialog(
      //FIXME : fix color here
      // barrierColor: Colors.transparent.withValues(alpha: 0.9),
      context: context,
      builder: (context) {
        return ActivateMasterProfileSection();
      },
    ).then((value) async {
      if (value) {
        await fetchUserValues(true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 1,
      vsync: this,
    );

    fetchUserValues(false);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppbar(
        onTap: () {},
        icon: Icons.menu,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await fetchUserValues(true);
          },
          child: ListView(
            shrinkWrap: true,
            children: [
              if (isLoading) ...[
                CustomShimmer(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: globalBorderRadius * 2,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: globalBorderRadius * 2,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: globalBorderRadius * 2,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: globalBorderRadius * 2,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: globalBorderRadius * 2,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else if (isFailed)
                Center(
                  child: CustomErrorWidget(onTap: () async {
                    await fetchUserValues(true);
                  }),
                )
              else ...[
                const SizedBox(height: 25),
                Center(
                  child: Text(
                    '${authenticationController.user?.firstName ?? ''} ${authenticationController.user?.lastName ?? ''}',
                    style: theme.textTheme.headlineLarge?.copyWith(
                        color: theme.colorScheme.tertiary,
                        fontWeight: FontWeight.w300),
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
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: globalBorderRadius * 10,
                  child: CustomCachedImage(
                    url: authenticationController.user?.avatar ?? '',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 7),
                Padding(
                  padding: globalPadding * 11,
                  child: MyDivider(
                    color: theme.colorScheme.onSecondary,
                    height: 1,
                    thickness: 1,
                  ),
                ),
                // const SizedBox(height: 6),
                // Padding(
                //   padding: globalPadding * 12,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           Text(
                //             "0".toPersianDigit(),
                //             style: theme.textTheme.titleMedium
                //                 ?.copyWith(fontWeight: FontWeight.w400),
                //           ),
                //           Text(
                //             "پست",
                //             style: theme.textTheme.titleMedium
                //                 ?.copyWith(fontWeight: FontWeight.w400),
                //           ),
                //         ],
                //       ),
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           Text(
                //             "0".toPersianDigit(),
                //             style: theme.textTheme.titleMedium
                //                 ?.copyWith(fontWeight: FontWeight.w400),
                //           ),
                //           Text(
                //             "امتیاز",
                //             style: theme.textTheme.titleMedium
                //                 ?.copyWith(fontWeight: FontWeight.w400),
                //           ),
                //         ],
                //       ),
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           Text(
                //             "0".toPersianDigit(),
                //             style: theme.textTheme.titleMedium
                //                 ?.copyWith(fontWeight: FontWeight.w400),
                //           ),
                //           Text(
                //             "کد معرف",
                //             style: theme.textTheme.titleMedium
                //                 ?.copyWith(fontWeight: FontWeight.w400),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 6),
                // Padding(
                //   padding: globalPadding * 11,
                //   child: MyDivider(
                //     color: theme.colorScheme.onSecondary,
                //     height: 1,
                //     thickness: 1,
                //   ),
                // ),
                const SizedBox(height: 25),
                Column(
                  children: [
                    if (authenticationController.user?.masterProfileId !=
                            null ||
                        authenticationController.user?.employerProfileId !=
                            null) ...[
                      ButtonItem(
                        onTap: () {
                          Get.to(const WorksReportScreen());
                        },
                        title: "گزارش کارها",
                        color: theme.colorScheme.tertiary,
                      ),
                      const SizedBox(height: 11),
                      ButtonItem(
                        onTap: () {
                          Get.to(
                            DetailsScreen(
                              id: authenticationController
                                      .user?.masterProfileId ??
                                  authenticationController
                                      .user?.employerProfileId ??
                                  0,
                              isComeFromProfile: true,
                            ),
                          );
                        },
                        title: "ویرایش صفحه",
                        color:
                            theme.colorScheme.secondary.withValues(alpha: 0.53),
                      ),
                      const SizedBox(height: 11),
                      ButtonItem(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const CreatePostStoryScreen(
                                  isStory: false,
                                );
                              },
                            ),
                          );
                        },
                        title: "پست جدید",
                        color:
                            theme.colorScheme.secondary.withValues(alpha: 0.53),
                      ),
                      const SizedBox(height: 11),
                      ButtonItem(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const CreatePostStoryScreen(
                                  isStory: true,
                                );
                              },
                            ),
                          );
                        },
                        title: "استوری جدید",
                        color:
                            theme.colorScheme.secondary.withValues(alpha: 0.53),
                      ),
                      const SizedBox(height: 11),
                    ],
                    if (authenticationController.user?.masterProfileId ==
                        null) ...[
                      ButtonItem(
                        onTap: () {
                          if (masterRequestTypes ==
                                  MasterRequestTypes.inProgress ||
                              masterRequestTypes ==
                                  MasterRequestTypes.inActive) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: theme.colorScheme.primary,
                                  child: ActivateProfileStatus(
                                    type: masterRequestTypes!,
                                    text: reasonText ?? '',
                                    onTap: () {
                                      showActivateMasterDialog();
                                    },
                                  ),
                                );
                              },
                            );
                          } else {
                            showActivateMasterDialog();
                          }
                        },
                        title:
                            "فعال سازی صفحه استادکار${masterRequestTypes == MasterRequestTypes.inProgress ? "(در انتظار تایید)" : masterRequestTypes == MasterRequestTypes.inActive ? '(عدم تایید)' : ''}",
                        color:
                            theme.colorScheme.secondary.withValues(alpha: 0.53),
                      ),
                      const SizedBox(height: 11),
                    ],
                    if (authenticationController.user?.employerProfileId ==
                        null) ...[
                      ButtonItem(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const ActivateEmployerProfileSection();
                            },
                          ).then((value) async {
                            await fetchUserValues(true);
                          });
                        },
                        title: "فعال سازی صفحه کارفرما",
                        color:
                            theme.colorScheme.secondary.withValues(alpha: 0.53),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
                const SizedBox(height: 100),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
