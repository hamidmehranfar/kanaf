import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kanaf/controllers/size_controller.dart';
import 'package:kanaf/models/comment.dart';
import 'package:kanaf/widgets/home_works_item.dart';
import '/controllers/home_controller.dart';
import '/widgets/custom_shimmer.dart';
import '/global_configs.dart';

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
    "ارسال کار",
    "محاسبه متریال",
    "نظارت بر ثبت پروژه",
    "آموزش و ترفند",
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
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: globalPadding * 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //FIXME : here must decide where to put these widgets
                  // Text("کناف", style: theme.textTheme.titleLarge,),
                  // Image.asset("assets/images/logo_test.jpg", width: 60,height: 60,)
                  Row(
                    children: [
                      Image.asset("assets/images/logo_test.jpg", width: 60,height: 60,),
                      const SizedBox(width: 20,),
                      Text("کناف", style: theme.textTheme.titleLarge,),
                    ],
                  ),

                  Stack(
                    children: [
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: Image.asset("assets/images/user.png", fit: BoxFit.cover,),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: SizedBox(
                          width: 24,
                          child: CircleAvatar(
                            backgroundColor: theme.colorScheme.primary,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero
                              ),
                              onPressed: (){

                              },
                              icon: Icon(Iconsax.add_circle, size: 24,color: theme.colorScheme.onPrimary),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16,),
            isLoading! ? CustomShimmer(
              child: Container(
                margin: globalPadding * 6,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: globalBorderRadius*2,
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
                      height: 200,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: globalBorderRadius * 2
                      ),
                    );
                  }),
                  options: CarouselOptions(
                    viewportFraction: 1,
                    initialPage: imagesCurrentIndex ?? 0,
                    autoPlay: true,
                    //FIXME : ask this part
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
                                  color: index==imagesCurrentIndex ? theme.colorScheme.inverseSurface
                                      : theme.colorScheme.shadow
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
            const SizedBox(height: 24,),
            Padding(
              padding: globalPadding * 3,
              child: Text("خدمات", style: theme.textTheme.titleLarge,),
            ),
            const SizedBox(height: 8,),
            Padding(
              padding: globalPadding * 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(homeWorkTitles.length, (int index){
                  return HomeWorksItem(text: homeWorkTitles[index]);
                }),
              ),
            ),
            const SizedBox(height: 24,),
            Padding(
              padding: globalPadding * 3,
              child: Text("نظرات", style: theme.textTheme.titleLarge,),
            ),
            const SizedBox(height: 8,),
            CarouselSlider(
              items: List.generate(comments.length, (int index){
                return Container(
                  width: 150,
                  padding: globalPadding * 2,
                  decoration: BoxDecoration(
                    borderRadius: globalBorderRadius * 2,
                    color: theme.colorScheme.onSurface.withOpacity(0.1)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comments[index].name, style: theme.textTheme.titleMedium,),
                      const SizedBox(height: 16,),
                      Text(comments[index].comment, style: theme.textTheme.bodyMedium,textDirection: TextDirection.rtl,),
                    ],
                  ),
                );
              }),
              options: CarouselOptions(
                height: 150,
                initialPage: commentsCurrentIndex ?? 0,
                enlargeCenterPage: true,
                viewportFraction: 0.5,
                enableInfiniteScroll: false
              )
            )
          ],
        ),
      ),
    );
  }
}
