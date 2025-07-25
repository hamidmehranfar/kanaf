import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '/res/enums/master_request_types.dart';
import '/screens/authentication/login_screen.dart';
import '/screens/profile/employer_profile_screen.dart';
import '/widgets/custom_error_widget.dart';
import '/widgets/custom_shimmer.dart';
import '/widgets/profile/activate_master_profile_section.dart';
import '/widgets/profile/activate_profile_status.dart';
import '/screens/details_screen.dart';
import '/controllers/authentication_controller.dart';
import '/res/controllers_key.dart';
import '/widgets/profile/activate_employer_profile_section.dart';
import '/widgets/custom_cached_image.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/my_divider.dart';
import '/global_configs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthenticationController authenticationController = Get.find(
    tag: ControllersKey.authControllerKey,
  );

  MasterRequestTypes? masterRequestTypes;
  String? reasonText;

  bool isLoading = true;
  bool isFailed = false;

  double masterItemImageWidth = 200;
  double masterItemImageHeight = 78;
  double masterItemTextWidth = 140;
  double masterItemTextHeight = 78;
  double masterItemFontSize = 16;

  Future<void> fetchUserValues(bool needFetchUser) async {
    setState(() {
      isLoading = true;
      isFailed = false;
    });

    bool profileResult = true;

    if (needFetchUser) {
      profileResult = await authenticationController.getUser();
    }

    if (profileResult) {
      if (authenticationController.user?.masterProfileId == null) {
        var response = await authenticationController.getMasterStatus();
        masterRequestTypes = response.$1;
        reasonText = response.$2;
      } else {
        masterRequestTypes = MasterRequestTypes.active;
      }

      if (masterRequestTypes == MasterRequestTypes.inProgress ||
          masterRequestTypes == MasterRequestTypes.inActive) {
        masterItemImageWidth = 230;
        masterItemTextWidth = 180;
        masterItemFontSize = 14;
      } else {
        masterItemImageWidth = 200;
        masterItemTextWidth = 150;
        masterItemFontSize = 16;
      }
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
        return const ActivateMasterProfileSection();
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
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    CustomShimmer(
                      child: Container(
                        width: 250,
                        height: 50,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface,
                          borderRadius: globalBorderRadius,
                        ),
                      ),
                    )
                  else if (isFailed)
                    CustomErrorWidget(onTap: () async {
                      await fetchUserValues(true);
                    })
                  else
                    Text(
                      '${authenticationController.user?.firstName ?? ''} ${authenticationController.user?.lastName ?? ''}',
                      style: theme.textTheme.headlineLarge?.copyWith(
                          color: theme.colorScheme.tertiary,
                          fontWeight: FontWeight.w300),
                    ),
                ],
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
              const SizedBox(height: 22),
              Container(
                margin: globalPadding * 10,
                padding: globalPadding * 5,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: globalBorderRadius * 6,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isLoading)
                          CustomShimmer(
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onSurface,
                                borderRadius: globalBorderRadius * 5,
                              ),
                            ),
                          )
                        else if (isFailed)
                          CustomErrorWidget(onTap: () async {
                            await fetchUserValues(true);
                          })
                        else
                          ClipRRect(
                            borderRadius: globalBorderRadius * 10,
                            child: CustomCachedImage(
                              url: authenticationController.user?.avatar ?? '',
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const MyDivider(
                      color: Color(0xff333333),
                      height: 1,
                      thickness: 1,
                    ),
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: () {
                        if (authenticationController.user?.employerProfileId ==
                            null) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const ActivateEmployerProfileSection(
                                employerUser: null,
                              );
                            },
                          ).then((value) async {
                            await fetchUserValues(true);
                          });
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const EmployerProfileScreen();
                              },
                            ),
                          );
                        }
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 200,
                            height: 78,
                            child: SvgPicture.asset(
                              'assets/images/calculate_button_svg.svg',
                              width: 200,
                              height: 78,
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                theme.colorScheme.tertiary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 5,
                            bottom: 20,
                            child: Center(
                              child: SizedBox(
                                width: 150,
                                height: 78,
                                child: Text(
                                  authenticationController
                                              .user?.employerProfileId ==
                                          null
                                      ? "فعال سازی صفحه کارفرما"
                                      : "ورود به صفحه کارفرما",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: () {
                        if (masterRequestTypes == MasterRequestTypes.active) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return DetailsScreen(
                                  id: authenticationController
                                          .user?.masterProfileId ??
                                      authenticationController
                                          .user?.employerProfileId ??
                                      0,
                                  isComeFromProfile: true,
                                );
                              },
                            ),
                          );
                        } else if (masterRequestTypes ==
                                MasterRequestTypes.inProgress ||
                            masterRequestTypes == MasterRequestTypes.inActive) {
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
                      child: Stack(
                        children: [
                          Positioned(
                            child: SizedBox(
                              width: masterItemImageWidth,
                              height: masterItemImageHeight,
                              child: SvgPicture.asset(
                                'assets/images/calculate_button_svg.svg',
                                width: masterItemImageWidth,
                                height: masterItemImageHeight,
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  theme.colorScheme.secondary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 5,
                            bottom: 20,
                            child: Center(
                              child: SizedBox(
                                width: masterItemTextWidth,
                                height: masterItemTextHeight,
                                child: Text(
                                  masterRequestTypes ==
                                          MasterRequestTypes.active
                                      ? "ورود به صفحه استادکار"
                                      : "فعال سازی صفحه استادکار"
                                          "${masterRequestTypes == MasterRequestTypes.inProgress ? "(در انتظار تایید)" : masterRequestTypes == MasterRequestTypes.inActive ? '(عدم تایید)' : ''}",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontSize: masterItemFontSize,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.tertiary,
                      ),
                      onPressed: () {
                        // Get.to(InstagramFeed());
                        authenticationController.removeSavedToken().then(
                          (_) {
                            Get.off(const LoginScreen());
                          },
                        );
                      },
                      child: Text("خروج"),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
