import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/controllers/authentication_controller.dart';
import 'package:kanaf/res/controllers_key.dart';
import 'package:kanaf/screens/tips_screen.dart';
import 'package:kanaf/widgets/custom_error_widget.dart';

import '/models/billboard.dart';
import '/res/app_colors.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/my_divider.dart';
import '/controllers/size_controller.dart';
import '/models/comment.dart';
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

  List<BillBoard> billboards = [];
  bool billboardsError = false;

  List<Comment> comments = [];
  bool commentsError = false;

  List<String> homeWorkTitles = [
    "استادکار",
    "محاسبه",
    "نظارت",
    "آموزش",
  ];

  List<Image> homeWorkIcons = [
    Image.asset(
      "assets/icons/user_icon.png",
      width: 32,
      height: 36,
    ),
    Image.asset(
      "assets/icons/pen_icon.png",
      width: 31,
      height: 30,
    ),
    Image.asset(
      "assets/icons/supervision_icon.png",
      width: 40,
      height: 32,
    ),
    Image.asset(
      "assets/icons/learn_icon.png",
      width: 33,
      height: 39,
    ),
  ];

  @override
  void initState() {
    super.initState();
    fetchImages();
    fetchComments();
  }

  Future<void> fetchImages() async {
    setState(() {
      isBillboardsLoading = true;
      billboardsError = false;
    });

    billboards = await homeController.fetchImages();
    if (billboards.isEmpty) billboardsError = true;

    setState(() {
      imagesCurrentIndex = (billboards.length / 2).floor();
      isBillboardsLoading = false;
    });
  }

  Future<void> fetchComments() async {
    setState(() {
      isCommentsLoading = true;
      commentsError = false;
    });

    List<Comment>? response = await homeController.fetchComments();
    if (response == null) {
      commentsError = true;
    } else {
      comments = response;
    }

    setState(() {
      commentsCurrentIndex = (comments.length / 2).floor();
      isCommentsLoading = false;
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
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            const SizedBox(
              height: 34,
            ),
            isBillboardsLoading
                ? CustomShimmer(
                    child: Container(
                    margin: globalPadding * 6,
                    width: width,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: globalBorderRadius * 5,
                      color: theme.colorScheme.onSurface,
                    ),
                  ))
                : billboardsError
                    ? CustomErrorWidget(onTap: () async {
                        await fetchImages();
                      })
                    : Stack(
                        children: [
                          CarouselSlider(
                              items:
                                  List.generate(billboards.length, (int index) {
                                return Container(
                                  margin: globalPadding * 10,
                                  width: SizeController.width(context),
                                  // decoration: BoxDecoration(
                                  //   borderRadius: globalBorderRadius * 4
                                  // ),
                                  child: CachedNetworkImage(
                                    imageUrl: billboards[index].url,
                                    placeholder: (context, url) => Container(),
                                    errorWidget: (context, url, error) => Row(
                                      children: [
                                        Text(
                                          "تلاش مجدد",
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            //FIXME : fix here
                                          },
                                          icon: const Icon(Icons.refresh),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
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
                                  })),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(billboards.length,
                                          (int index) {
                                        return Container(
                                          width: 10,
                                          height: 10,
                                          margin: globalPadding,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: index == imagesCurrentIndex
                                                  ? theme.colorScheme.secondary
                                                  : theme
                                                      .colorScheme.onSecondary),
                                        );
                                      }),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
            const SizedBox(
              height: 18,
            ),
            Padding(
              padding: globalPadding * 11,
              child: MyDivider(
                  color: AppColors.dividerColor, height: 1, thickness: 1),
            ),
            const SizedBox(
              height: 18,
            ),
            Padding(
              padding: globalPadding * 8,
              child: Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: List.generate(4, (index) {
                  return HomeWorksItem(
                    text: homeWorkTitles[index],
                    imageIcon: homeWorkIcons[index],
                    onTap: () {
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
                    },
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "نظرات کاربران",
                style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w300,
                    color: theme.colorScheme.tertiary),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: globalPadding * 11,
              child: MyDivider(
                  color: AppColors.dividerColor, height: 1, thickness: 1),
            ),
            const SizedBox(
              height: 16,
            ),
            isCommentsLoading
                ? CustomShimmer(
                    child: Container(
                    margin: globalPadding * 6,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: globalBorderRadius * 5,
                      color: theme.colorScheme.onSurface,
                    ),
                  ))
                : commentsError
                    ? CustomErrorWidget(onTap: () async {
                        await fetchComments();
                      })
                    : CarouselSlider(
                        items: List.generate(comments.length, (int index) {
                          return Container(
                            width: commentsCurrentIndex == index ? 210 : 100,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 23,
                                          ),
                                          Image.asset(
                                              "assets/images/user_ava.png"),
                                          Expanded(
                                            child: Text(
                                              comments[index].name,
                                              style: theme.textTheme.titleLarge
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: commentsCurrentIndex ==
                                                        index
                                                    ? theme
                                                        .colorScheme.onPrimary
                                                    : theme.colorScheme
                                                        .onSecondary,
                                              ),
                                              textDirection: TextDirection.rtl,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      //FIXME : ask this
                                      // Column(
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     const SizedBox(height: 25,),
                                      //     Row(
                                      //       children: [
                                      //         Text("6.5", style: theme.textTheme.labelMedium?.copyWith(
                                      //           color: theme.colorScheme.tertiary
                                      //         ),),
                                      //         const SizedBox(width: 2,),
                                      //         Icon(Icons.star, color: AppColors.sideColor,size: 10,)
                                      //       ],
                                      //     ),
                                      //     Text("برنامه خوبی است")
                                      //   ],
                                      // )
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        child: Image.asset(
                                          "assets/images/user_ava.png",
                                          width: 60,
                                          height: 60,
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Text(
                                              comments[index].name,
                                              style: theme.textTheme.titleLarge
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: commentsCurrentIndex ==
                                                        index
                                                    ? theme
                                                        .colorScheme.onPrimary
                                                    : theme.colorScheme
                                                        .onSecondary,
                                              ),
                                              textDirection: TextDirection.rtl,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                          );
                        }),
                        options: CarouselOptions(
                            height: 130,
                            initialPage: commentsCurrentIndex ?? 0,
                            // enlargeCenterPage: true,
                            viewportFraction: 0.5,
                            enableInfiniteScroll: false,
                            // disableCenter: true,
                            onPageChanged:
                                (int index, CarouselPageChangedReason reason) {
                              setState(() {
                                commentsCurrentIndex = index;
                              });
                            })),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: globalPadding * 11,
              child: MyDivider(
                  color: AppColors.dividerColor, height: 1, thickness: 1),
            ),
            const SizedBox(
              height: 13,
            ),
            Padding(
              padding: globalPadding * 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 105,
                    height: 90,
                    decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: globalBorderRadius * 3),
                    child: Center(
                      child: Text(
                        "چت",
                        style: theme.textTheme.labelMedium
                            ?.copyWith(color: theme.colorScheme.onPrimary),
                      ),
                    ),
                  ),
                  Container(
                    width: 105,
                    height: 90,
                    decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: globalBorderRadius * 3),
                    child: Center(
                      child: Text(
                        "تالار گفتگو",
                        style: theme.textTheme.labelMedium
                            ?.copyWith(color: theme.colorScheme.onPrimary),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: globalPadding * 11,
              child: MyDivider(
                  color: AppColors.dividerColor, height: 1, thickness: 1),
            ),
            const SizedBox(
              height: 13,
            ),
            CarouselSlider(
                items: List.generate(comments.length, (int index) {
                  return Container(
                    width: SizeController.width(context),
                    margin: globalPadding,
                    decoration: BoxDecoration(
                        borderRadius: globalBorderRadius * 4,
                        border: Border.all(color: theme.colorScheme.primary)),
                    child: const Center(
                      child: Text("تبلیغات"),
                    ),
                  );
                }),
                options: CarouselOptions(
                  height: 120,
                  initialPage: 2,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                )),
            const SizedBox(
              height: 120,
            )
          ],
        ),
      ),
    );
  }
}
