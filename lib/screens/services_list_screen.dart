import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kanaf/screens/master_services_screen.dart';
import 'package:kanaf/screens/search_screen.dart';
import 'package:kanaf/widgets/custom_appbar.dart';
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
  final PagingController<int, Poster> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey){
      pagingControllerListener(pageKey);
    });
  }
  
  Future<void> pagingControllerListener(pageKey)async{
    _pagingController.appendLastPage(
      List.generate(20, (int index){
        return Poster(
            title: "استاد کار",
            num: 17,
            imageUrl: "",
            rating: 6.5
        );
      })
    );
  }

  @override
  Widget build(BuildContext context){
    var theme = Theme.of(context);

    // SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    //   statusBarColor: Colors.white,
    // );

    return Scaffold(
      appBar: CustomAppbar(
        onTap: (){
          Navigator.of(context).pop();
        },
      ),
      body: SizedBox(
        width: SizeController.width,
        height: SizeController.height,
        child: RefreshIndicator(
          onRefresh: () async{
            _pagingController.refresh();
          },
          child: Column(
            children: [
              const SizedBox(height: 14,),
              Center(
                child: Text("استادکارها", style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.tertiary,
                    fontWeight: FontWeight.w300
                ),),
              ),
              const SizedBox(height: 5,),
              Padding(
                padding: globalPadding * 11,
                child: MyDivider(
                  color: theme.colorScheme.onSecondary,
                  height: 1,
                  thickness: 1,
                ),
              ),
              const SizedBox(height: 20,),
              Expanded(
                child: PagedListView.separated(
                  shrinkWrap: true,
                  padding: allPadding * 5,
                  pagingController: _pagingController,
                  separatorBuilder: (context, index){
                    return const SizedBox(height: 10,);
                  },
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (BuildContext context, Poster item, int index){
                      return PosterItem(poster : item);
                    }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
