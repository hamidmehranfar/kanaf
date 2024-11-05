import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kanaf/res/app_colors.dart';
import '/../widgets/custom_appbar.dart';
import '/../widgets/my_divider.dart';
import '../controllers/size_controller.dart';
import '../models/comment.dart';
import '../screens/master_services_screen.dart';
import '../widgets/home/home_works_item.dart';
import '../controllers/home_controller.dart';
import '../widgets/custom_shimmer.dart';
import '../global_configs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool? isLoading;
  int? imagesCurrentIndex;
  int? commentsCurrentIndex;

  HomeController homeController = HomeController();
  CarouselSliderController carouselSliderController = CarouselSliderController();

  List<String> images = [];
  List<Comment> comments = [];

  List<String> homeWorkTitles = [
    "استادکار",
    "محاسبه",
    "نظارت",
    "آموزش",
  ];

  List<Image> homeWorkIcons = [
    Image.asset("assets/icons/user_icon.png",
      width: 41,height: 46,),
    Image.asset("assets/icons/pen_icon.png",
      width: 40,height: 38,),
    Image.asset("assets/icons/supervision_icon.png",
      width: 51,height: 41,),
    Image.asset("assets/icons/learn_icon.png",
      width: 42,height: 50,),
  ];

  @override
  void initState() {
    super.initState();
    initImagesAndComments();
  }

  Future<void> initImagesAndComments() async {
    setState(() {
      isLoading = true;
    });

    images = await homeController.fetchImages();
    comments = await homeController.fetchComments();

    setState(() {
      imagesCurrentIndex = (images.length/2).floor();
      commentsCurrentIndex = (comments.length/2).floor();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var width = SizeController.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const CustomAppbar(),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            const SizedBox(height: 34,),
            isLoading! ? CustomShimmer(
              child: Container(
                margin: globalPadding * 6,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: globalBorderRadius*5,
                  color: Colors.black,
                ),
                width: width,
                )
              ) :
            Stack(
              children: [
                CarouselSlider(
                  items: List.generate(images.length, (int index){
                    return Container(
                      margin: globalPadding * 10,
                      width: width,
                      height: 200,
                      // decoration: BoxDecoration(
                      //   color: theme.colorScheme.primary,
                      //   borderRadius: globalBorderRadius * 4
                      // ),
                      child: Image.asset("assets/images/image.png",fit: BoxFit.fill,),
                    );
                  }),
                  options: CarouselOptions(
                    height: 200,
                    viewportFraction: 1,
                    initialPage: imagesCurrentIndex ?? 0,
                    autoPlay: true,
                    enableInfiniteScroll: true,
                    onPageChanged: (index,changeReason){
                      setState(() {
                        imagesCurrentIndex = index;
                      });
                    }
                  )
                ),
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
                          children: List.generate(images.length, (int index){
                            return Container(
                              width: 10,
                              height: 10,
                              margin: globalPadding,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index==imagesCurrentIndex ? theme.colorScheme.secondary
                                      : theme.colorScheme.onSecondary
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16,)
                      ],
                    ),
                  )
                )
              ],
            ),
            const SizedBox(height: 18,),
            Padding(
              padding: globalPadding * 11,
              child: MyDivider(color: AppColors.dividerColor,
                  height: 1, thickness: 1),
            ),
            const SizedBox(height: 18,),
            SizedBox(
              width: width,
              height: 160,
              child: ListView.separated(
                padding: globalPadding * 5,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index){
                  return HomeWorksItem(
                    text: homeWorkTitles[index],
                    imageIcon: homeWorkIcons[index],
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return const MasterServicesScreen();
                      }));
                    },
                  );
                },
                separatorBuilder: (context, index){
                  return const SizedBox(width: 32,);
                },
              )
            ),
            const SizedBox(height: 10,),
            Center(
              child: Text("نظرات کاربران", style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w300,
                color: theme.colorScheme.tertiary
              ),),
            ),
            const SizedBox(height: 4,),
            Padding(
              padding: globalPadding * 11,
              child: MyDivider(color: AppColors.dividerColor,
                  height: 1, thickness: 1),
            ),
            const SizedBox(height: 16,),
            isLoading! ? CustomShimmer(
              child: Container(
                height: 210,
                margin: globalPadding * 6,
                decoration: BoxDecoration(
                  borderRadius: globalBorderRadius*5,
                  color: Colors.black,
                ),
              )
            ) :
            CarouselSlider(
              items: List.generate(comments.length, (int index){
                return Container(
                  width: 210,
                  padding: globalPadding * 2,
                  decoration: BoxDecoration(
                    borderRadius: globalBorderRadius * 5,
                    color: theme.colorScheme.primary,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16,),
                      Center(
                        child: Image.asset("assets/images/user_ava.png",width: 60,height: 60,),
                      ),
                      const SizedBox(height: 12,),
                      Expanded(
                        child: Center(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(comments[index].name, style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onPrimary,
                            ),textDirection: TextDirection.rtl,),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              options: CarouselOptions(
                height: 120,
                initialPage: commentsCurrentIndex ?? 0,
                enlargeCenterPage: true,
                viewportFraction: 0.6,
                enableInfiniteScroll: false
              )
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: globalPadding * 11,
              child: MyDivider(color: AppColors.dividerColor,
                  height: 1, thickness: 1),
            ),
            const SizedBox(height: 13,),
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
                      borderRadius: globalBorderRadius * 3
                    ),
                  ),
                  Container(
                    width: 105,
                    height: 90,
                    decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: globalBorderRadius * 3
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
