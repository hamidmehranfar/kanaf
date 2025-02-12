import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '/controllers/master_controller.dart';
import '/models/master.dart';
import '/res/controllers_key.dart';
import '/widgets/custom_appbar.dart';
import '/controllers/size_controller.dart';
import '/global_configs.dart';
import '/res/enums/master_services.dart';
import '/widgets/my_divider.dart';
import '/widgets/poster_item.dart';

class ServicesListScreen extends StatefulWidget {
  final MasterServices service;
  const ServicesListScreen({super.key, required this.service});

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  final PagingController<int, Master> _pagingController = PagingController(firstPageKey: 1);

  MasterController masterController = Get.find(
    tag: ControllersKey.masterControllerKey,
  );

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) async {
      await _fetchData(pageKey);
    });
  }
  
  Future<void> _fetchData(int pageKey) async {
    List<Master>? newItems = await masterController.getMastersList(
        pageKey: pageKey,type: widget.service);

    if(newItems!=null){
      bool isLastPage = newItems.length < 10;
      if(isLastPage){
        _pagingController.appendLastPage(newItems);
      }
      else{
        _pagingController.appendPage(newItems, pageKey + 1);
      }
    }
    else{
      _pagingController.error = masterController.apiMessage;
    }
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
        iconAsset: "assets/icons/arrow_back_19.png",
      ),
      body: SizedBox(
        width: SizeController.width(context),
        height: SizeController.height(context),
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
                    itemBuilder: (BuildContext context, Master item, int index){
                      return PosterItem(master : item);
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
