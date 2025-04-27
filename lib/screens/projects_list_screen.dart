import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '/models/employer_project.dart';
import '/widgets/custom_error_widget.dart';
import '/widgets/custom_shimmer.dart';
import '/controllers/project_controller.dart';
import '/res/controllers_key.dart';
import '/widgets/profile/projects_item.dart';
import '/controllers/size_controller.dart';
import '/global_configs.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/my_divider.dart';

class ProjectsListScreen extends StatefulWidget {
  const ProjectsListScreen({super.key});

  @override
  State<ProjectsListScreen> createState() => _ProjectsListScreenState();
}

class _ProjectsListScreenState extends State<ProjectsListScreen> {
  bool isLoading = true;

  ProjectController profileController = Get.find(
    tag: ControllersKey.projectControllerKey,
  );

  final PagingController<int, EmployerProject> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) async {
      await _fetchProjects(pageKey);
    });
  }

  Future<void> _fetchProjects(int pageKey) async {
    final newItems = await profileController.getHomeProjects(pageKey);
    if (newItems == null) {
      _pagingController.error = profileController.apiMessage;
    } else {
      final lastPage = newItems.length < 10;
      if (lastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
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
        onTap: () {
          Navigator.pop(context);
        },
        iconAsset: "assets/icons/arrow_back_19.png",
      ),
      body: SizedBox(
        width: SizeController.width(context),
        height: SizeController.height(context),
        child: RefreshIndicator(
          onRefresh: () async {
            _pagingController.refresh();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Text(
                "پروژه ها",
                style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.tertiary,
                    fontWeight: FontWeight.w300),
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
              const SizedBox(height: 20),
              Expanded(
                child: PagedListView.separated(
                  pagingController: _pagingController,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 13);
                  },
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (BuildContext context, EmployerProject item,
                        int index) {
                      return ProjectsItem(
                        project: item,
                      );
                    },
                    noMoreItemsIndicatorBuilder: (context) {
                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("موردی یافت نشد"),
                          SizedBox(height: 36),
                        ],
                      );
                    },
                    noItemsFoundIndicatorBuilder: (context) {
                      return const Center(
                        child: Text("موردی یافت نشد"),
                      );
                    },
                    firstPageErrorIndicatorBuilder: (context) {
                      return CustomErrorWidget(onTap: () {
                        _pagingController.refresh();
                      });
                    },
                    firstPageProgressIndicatorBuilder: (context) {
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
                    },
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
