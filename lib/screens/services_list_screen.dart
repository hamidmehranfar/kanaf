import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kanaf/screens/search_screen.dart';
import '../controllers/size_controller.dart';
import '../global_configs.dart';
import '../models/enums/master_services.dart';
import '../widgets/my_divider.dart';

import '../models/poster.dart';
import '../widgets/poster_item.dart';

class ServicesListScreen extends StatefulWidget {
  final MasterServices service;
  const ServicesListScreen({super.key, required this.service});

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  final PagingController<int, Poster> pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((pageKey){
      pagingControllerListener(pageKey);
    });
  }
  
  Future<void> pagingControllerListener(pageKey)async{
    pagingController.appendLastPage(
      [
        Poster(
          title: "سمپاشی تخصصی موریانه سوسک ساس سم پاشی موش",
          address: "پله شده در ملک شهر",
          imageUrl: ""
        ),
        Poster(title: "دستگاه شنود مخفی",
            address: "لحظاتی پیش در مبارکه",
            price: "4500000",
            imageUrl: ""),
        Poster(
            title: "کتاب مبانی کلی ارتباط جمعی",
            address: "لحظاتی پیش در باغ غدیر",
            price: "200000",
            imageUrl: ""
        ),
        Poster(
            title: "سمپاشی تخصصی موریانه سوسک ساس سم پاشی موش",
            address: "پله شده در ملک شهر",
            imageUrl: ""
        ),
        Poster(title: "دستگاه شنود مخفی",
            address: "لحظاتی پیش در مبارکه",
            price: "4500000",
            imageUrl: ""),
        Poster(
            title: "کتاب مبانی کلی ارتباط جمعی",
            address: "لحظاتی پیش در باغ غدیر",
            price: "200000",
            imageUrl: ""
        ),
        Poster(
            title: "سمپاشی تخصصی موریانه سوسک ساس سم پاشی موش",
            address: "پله شده در ملک شهر",
            imageUrl: ""
        ),
        Poster(title: "دستگاه شنود مخفی",
            address: "لحظاتی پیش در مبارکه",
            price: "4500000",
            imageUrl: ""),
        Poster(
            title: "کتاب مبانی کلی ارتباط جمعی",
            address: "لحظاتی پیش در باغ غدیر",
            price: "200000",
            imageUrl: ""
        ),
      ]
    );
  }

  @override
  Widget build(BuildContext context){
    var theme = Theme.of(context);

    // SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    //   statusBarColor: Colors.white,
    // );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: theme.colorScheme.secondary.withOpacity(0.2),
        // systemOverlayStyle: systemUiOverlayStyle,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            const SizedBox(height: 8,),
            Row(
              children: [
                InkWell(
                  onTap: (){
                    Get.back();
                  },
                  child: const Icon(Iconsax.arrow_right_1),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: globalBorderRadius,
                      border: Border.all(
                        color: theme.colorScheme.secondary,
                        width: 1,
                      )
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              Get.to(const SearchScreen());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: globalPadding * 4,
                                  child: Text("جستجو در همه ی اگهی ها", style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.inverseSurface),),
                                ),
                                const Icon(Icons.search),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8,),
                        InkWell(
                          child: Row(
                            children: [
                              Container(width: 1,color: theme.colorScheme.inverseSurface,),
                              const SizedBox(width: 5,),
                              Text("اصفهان", style: theme.textTheme.bodyMedium,),
                              const Icon(Icons.location_on_outlined),
                              const SizedBox(width: 4,)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8,)
          ],
        ),
        bottom: MyDivider(
          height: 1,
          thickness: 1,
          color: theme.colorScheme.inverseSurface.withOpacity(0.2),
        ),
      ),
      body: SizedBox(
        width: SizeController.width,
        height: SizeController.height,
        child: PagedListView.separated(
          shrinkWrap: true,
          padding: allPadding * 4,
          pagingController: pagingController,
          separatorBuilder: (context, index){
            return const SizedBox(height: 8,);
          },
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (BuildContext context, Poster item, int index){
              return PosterItem(poster : item);
            }
          ),
        ),
      ),
    );
  }
}
