import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kanaf/widgets/home/choose_calculation_type_dialog.dart';

import '/controllers/city_controller.dart';
import '/res/enums/calculate_type.dart';
import '/screens/calculate_details_screen.dart';
import '/screens/projects_list_screen.dart';
import '/res/controllers_key.dart';
import '/screens/tutorials_screen.dart';
import '/widgets/custom_cached_image.dart';
import '/widgets/custom_error_widget.dart';
import '/widgets/step_widget.dart';
import '/models/billboard.dart';
import '/res/app_colors.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/my_divider.dart';
import '/controllers/size_controller.dart';
import '/models/home_comment.dart';
import '/screens/master_services_screen.dart';
import '/widgets/home/home_works_item.dart';
import '/controllers/home_controller.dart';
import '/widgets/custom_shimmer.dart';
import '/global_configs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isBillboardsLoading = true;
  bool isCommentsLoading = true;

  int? imagesCurrentIndex;
  int? commentsCurrentIndex;

  HomeController homeController = Get.find(
    tag: ControllersKey.homeControllerKey,
  );

  CityController cityController = Get.find(
    tag: ControllersKey.cityControllerKey,
  );

  List<BillBoard>? billboards;
  bool billboardsError = false;

  List<HomeComment>? comments;
  bool commentsError = false;

  String? tip;
  bool tipLoading = false;
  bool tipFailed = false;

  List<String> homeWorkTitles = [
    "استادکار",
    "محاسبه",
    "نظارت",
    "آموزش",
    "محاسبه",
    "نظارت",
    "آموزش",
  ];

  List<SvgPicture> homeWorkIcons = [
    SvgPicture.asset(
      'assets/icons/user.svg',
      width: 32,
      height: 36,
    ),
    SvgPicture.asset(
      'assets/icons/pen.svg',
      width: 31,
      height: 30,
    ),
    SvgPicture.asset(
      'assets/icons/supervision.svg',
      width: 40,
      height: 32,
    ),
    SvgPicture.asset(
      "assets/icons/learn.svg",
      width: 33,
      height: 39,
    ),
    SvgPicture.asset(
      'assets/icons/pen.svg',
      width: 31,
      height: 30,
    ),
    SvgPicture.asset(
      'assets/icons/supervision.svg',
      width: 40,
      height: 32,
    ),
    SvgPicture.asset(
      "assets/icons/learn.svg",
      width: 33,
      height: 39,
    ),
  ];

  @override
  void initState() {
    super.initState();
    fetchImages();
    fetchComments();
    fetchTips();
    fetchCities();
  }

  Future<void> fetchImages() async {
    setState(() {
      isBillboardsLoading = true;
      billboardsError = false;
    });

    billboards = await homeController.fetchImages();
    if (billboards == null) {
      billboardsError = true;
    }

    setState(() {
      if (billboards != null) {
        imagesCurrentIndex = (billboards!.length / 2).floor();
        isBillboardsLoading = false;
      }
    });
  }

  Future<void> fetchComments() async {
    setState(() {
      isCommentsLoading = true;
      commentsError = false;
    });

    List<HomeComment>? response = await homeController.fetchComments();
    if (response == null) {
      commentsError = true;
    } else {
      comments = response;
    }

    setState(() {
      if (comments != null) {
        commentsCurrentIndex = (comments!.length / 2).floor();
        isCommentsLoading = false;
      }
    });
  }

  Future<void> fetchTips() async {
    setState(() {
      tipLoading = true;
      tipFailed = false;
    });

    tip = await homeController.getTips();

    if (tip == null) {
      tipFailed = true;
    }

    setState(() {
      tipLoading = false;
    });
  }

  Future<void> fetchCities() async {
    cityController.fetchCities().then((value) {
      if (value) {
        cityController.getSavedProvince();
        cityController.getSavedCity();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var width = SizeController.width(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppbar(
        onTap: () {},
        icon: Icons.menu,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SizedBox(height: 34),
          if (isBillboardsLoading)
            CustomShimmer(
              child: Container(
                margin: globalPadding * 6,
                width: width,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: globalBorderRadius * 5,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            )
          else if (billboardsError)
            CustomErrorWidget(
              onTap: () async {
                await fetchImages();
              },
            )
          else if (billboards?.isNotEmpty ?? false) ...[
            Stack(
              children: [
                CarouselSlider(
                  items: List.generate(
                    billboards?.length ?? 0,
                    (int index) {
                      return Padding(
                        padding: globalPadding * 5,
                        child: ClipRRect(
                          borderRadius: globalBorderRadius * 4,
                          child: CachedNetworkImage(
                            imageUrl: billboards?[index].url ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(),
                            errorWidget: (context, url, error) => Row(
                              children: [
                                Text(
                                  "تلاش مجدد",
                                  style: theme.textTheme.bodyLarge,
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await fetchImages();
                                  },
                                  icon: const Icon(Icons.refresh),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  options: CarouselOptions(
                    height: 200,
                    viewportFraction: 1,
                    initialPage: imagesCurrentIndex ?? 0,
                    autoPlay: true,
                    enableInfiniteScroll: true,
                    onPageChanged: (index, changeReason) {
                      setState(() {
                        imagesCurrentIndex = index;
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        StepWidget(
                          width: 37,
                          height: 8,
                          selectedIndex: imagesCurrentIndex ?? 0,
                          length: billboards?.length ?? 0,
                        ),
                        const SizedBox(height: 16)
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 18),
            Padding(
              padding: globalPadding * 11,
              child: MyDivider(
                color: AppColors.dividerColor,
                height: 1,
                thickness: 1,
              ),
            ),
            const SizedBox(height: 18),
          ],
          Center(
            child: SizedBox(
              height: 100,
              child: ListView.separated(
                padding: globalPadding * 2,
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return HomeWorksItem(
                    text: homeWorkTitles[index],
                    imageIcon: homeWorkIcons[index],
                    onTap: () {
                      if (index == 1) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const ChooseCalculationTypeDialog();
                          },
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              if (index == 0) {
                                return const MasterServicesScreen();
                              } else if (index == 3) {
                                return const TipsScreen();
                              }
                              return const MasterServicesScreen();
                            },
                          ),
                        );
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
              ),
            ),
          ),
          Center(
            child: SizedBox(
              height: 100,
              child: ListView.separated(
                padding: globalPadding * 2,
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return HomeWorksItem(
                    text: homeWorkTitles[index + 4],
                    imageIcon: homeWorkIcons[index + 4],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return const ProjectsListScreen();
                          },
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (isCommentsLoading)
            CustomShimmer(
              child: Container(
                margin: globalPadding * 6,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: globalBorderRadius * 5,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            )
          else if (commentsError)
            CustomErrorWidget(
              onTap: () async {
                await fetchComments();
              },
            )
          else if (comments?.isNotEmpty ?? false) ...[
            Center(
              child: Text(
                "نظرات کاربران",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w300,
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: globalPadding * 11,
              child: MyDivider(
                color: AppColors.dividerColor,
                height: 1,
                thickness: 1,
              ),
            ),
            const SizedBox(height: 16),
            CarouselSlider(
              items: List.generate(
                comments?.length ?? 0,
                (int index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: commentsCurrentIndex == index ? 210 : 140,
                    padding: globalPadding * 5,
                    decoration: BoxDecoration(
                      borderRadius: globalBorderRadius * 5,
                      color: commentsCurrentIndex == index
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                    ),
                    child: commentsCurrentIndex == index
                        ? Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 16),
                                  ClipOval(
                                    child: comments?[index].imageUrl == null
                                        ? Image.asset(
                                            "assets/images/user_ava.png",
                                            width: 45,
                                            height: 45,
                                          )
                                        : CustomCachedImage(
                                            url:
                                                comments?[index].imageUrl ?? '',
                                            width: 45,
                                            height: 45,
                                          ),
                                  ),
                                  const SizedBox(height: 5),
                                  Flexible(
                                    flex: 3,
                                    child: SizedBox(
                                      width: 60,
                                      child: Text(
                                        comments?[index].name ?? '',
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: commentsCurrentIndex == index
                                              ? theme.colorScheme.onPrimary
                                              : theme.colorScheme.onSecondary,
                                        ),
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  height: 100,
                                  child: Text(
                                    comments?[index].text ?? '',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              ClipOval(
                                child: comments?[index].imageUrl == null
                                    ? Image.asset(
                                        "assets/images/user_ava.png",
                                        width: 45,
                                        height: 45,
                                      )
                                    : CustomCachedImage(
                                        url: comments?[index].imageUrl ?? '',
                                        width: 50,
                                        height: 50,
                                      ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      comments?[index].name ?? '',
                                      style:
                                          theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: commentsCurrentIndex == index
                                            ? theme.colorScheme.onPrimary
                                            : theme.colorScheme.onSecondary,
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                  );
                },
              ),
              options: CarouselOptions(
                height: 130,
                initialPage: commentsCurrentIndex ?? 0,
                // enlargeCenterPage: true,
                viewportFraction: 0.5,
                enableInfiniteScroll: false,
                // disableCenter: true,
                onPageChanged: (int index, CarouselPageChangedReason reason) {
                  setState(() {
                    commentsCurrentIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
          Padding(
            padding: globalPadding * 11,
            child: MyDivider(
              color: AppColors.dividerColor,
              height: 1,
              thickness: 1,
            ),
          ),
          const SizedBox(height: 13),
          Padding(
            padding: globalPadding * 18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 105,
                  height: 90,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: globalBorderRadius * 3,
                  ),
                  child: Center(
                    child: Text(
                      "تالار گفتگو",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Container(
                  width: 105,
                  height: 90,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: globalBorderRadius * 3,
                  ),
                  child: Center(
                    child: Text(
                      "چت",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: globalPadding * 11,
            child: MyDivider(
              color: AppColors.dividerColor,
              height: 1,
              thickness: 1,
            ),
          ),
          const SizedBox(height: 13),
          if (tipLoading)
            CustomShimmer(
              child: Container(
                margin: globalPadding * 12,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: globalBorderRadius * 3,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            )
          else if (tipFailed)
            CustomErrorWidget(
              onTap: () async {
                await fetchTips();
              },
            )
          else
            Container(
              margin: globalPadding * 7,
              padding: globalPadding * 2,
              decoration: BoxDecoration(
                borderRadius: globalBorderRadius * 4,
                color: Colors.grey[300],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    tip ?? '',
                    style: theme.textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          const SizedBox(height: 13),
          Container(
            margin: globalPadding * 7,
            height: 135,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: globalBorderRadius * 4,
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
            child: Column(
              children: [
                const SizedBox(height: 20),
                SvgPicture.asset(
                  "assets/icons/chat.svg",
                  width: 55,
                  height: 55,
                ),
                const SizedBox(height: 8),
                Text(
                  "برای چت با پشتیبانی کنافکار کلیک کنید",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
          const SizedBox(height: 120)
        ],
      ),
    );
  }
}
