import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kanaf/widgets/custom_error_widget.dart';
import 'package:kanaf/widgets/custom_shimmer.dart';

import '/controllers/project_controller.dart';
import '/models/project.dart';
import '/res/controllers_key.dart';
import '/widgets/profile/projects_item.dart';
import '/controllers/size_controller.dart';
import '/global_configs.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/my_divider.dart';
import '/widgets/button_item.dart';

class WorksReportScreen extends StatefulWidget {
  const WorksReportScreen({super.key});

  @override
  State<WorksReportScreen> createState() => _WorksReportScreenState();
}

class _WorksReportScreenState extends State<WorksReportScreen> {
  bool isLoading = true;

  ProjectController profileController = Get.find(
    tag: ControllersKey.projectControllerKey,
  );

  PagingController<int, Project> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) async {
      await _fetchProjects(pageKey);
    });
  }

  Future<void> _fetchProjects(int pageKey) async {
    final newItems = await profileController.getProjects(pageKey);
    if(newItems == null){
      _pagingController.error = profileController.apiMessage;
    }
    else{
      final lastPage = newItems.length < 10;
      if(lastPage){
        _pagingController.appendLastPage(newItems);
      }
      else{
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(
        onTap: (){
          Get.back();
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 25,),
              Text("گزارش ها", style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.w300
              ),),
              const SizedBox(height: 14,),
              Padding(
                padding: globalPadding * 11,
                child: MyDivider(
                  color: theme.colorScheme.onSecondary,
                  height: 1,thickness: 1,
                ),
              ),
              const SizedBox(height: 14,),
              ButtonItem(
                width: 250,
                onTap: (){

                },
                title: "ثبت گزارش کار جدید",
                color: theme.colorScheme.tertiary,
              ),
              const SizedBox(height: 15,),
              Expanded(
                child: PagedListView(pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (BuildContext context,Project item,int index){
                      return ProjectsItem(project: item,);
                    },
                    firstPageErrorIndicatorBuilder: (context){
                      return CustomErrorWidget(onTap: (){
                        _pagingController.refresh();
                      });
                    },
                    firstPageProgressIndicatorBuilder: (context){
                      return CustomShimmer(
                        child: Column(
                          children: [
                            Container(
                              margin: globalPadding * 6,
                              height: 400,
                              decoration: BoxDecoration(
                              borderRadius: globalBorderRadius * 3,
                              color: theme.colorScheme.onSurface,
                            ),
                                                  ),
                          ],
                        ),
                      );
                    }
                  )
                )
              ),
              const SizedBox(height: 24,),
              Padding(
                padding: globalPadding * 11,
                child: MyDivider(
                  color: theme.colorScheme.onSecondary,
                  height: 1,thickness: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
