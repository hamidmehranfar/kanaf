import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '/res/enums/offer_status.dart';
import '/res/app_colors.dart';
import '/res/enums/project_type.dart';
import '/controllers/project_controller.dart';
import '/global_configs.dart';
import '/models/offer_project.dart';
import '/res/controllers_key.dart';
import '../custom_error_widget.dart';
import '../custom_shimmer.dart';
import '../my_divider.dart';
import 'offer_item.dart';

class OfferTabItem extends StatefulWidget {
  final ProjectType type;
  final int offerStatusIndex;

  const OfferTabItem({
    super.key,
    required this.type,
    required this.offerStatusIndex,
  });

  @override
  State<OfferTabItem> createState() => _OfferTabItemState();
}

class _OfferTabItemState extends State<OfferTabItem>
    with AutomaticKeepAliveClientMixin {
  ProjectController projectController = Get.find(
    tag: ControllersKey.projectControllerKey,
  );

  late PagingController<int, OfferProject> _pagingController;

  @override
  void initState() {
    super.initState();

    _pagingController =
        projectController.offerTabPagingController[widget.offerStatusIndex];

    _pagingController.addPageRequestListener((pageKey) async {
      await _fetchProjects(pageKey);
    });
  }

  Future<void> _fetchProjects(int pageKey) async {
    final newItems = await projectController.getOffers(
      pageKey: pageKey,
      type: widget.type,
      status: widget.offerStatusIndex,
    );
    if (newItems == null) {
      _pagingController.error = projectController.apiMessage;
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
    super.build(context);

    var theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        _pagingController.refresh();
      },
      child: PagedListView.separated(
        padding: const EdgeInsets.only(bottom: 80),
        pagingController: _pagingController,
        separatorBuilder: (context, index) {
          return Column(
            children: [
              const SizedBox(height: 13),
              MyDivider(
                color: AppColors.paleBlack,
                height: 1,
                thickness: 1,
              ),
              const SizedBox(height: 18),
            ],
          );
        },
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (BuildContext context, OfferProject item, int index) {
            return OfferItem(
              offer: item,
              type: widget.type,
              onTap: () async {
                _pagingController.refresh();
              },
            );
          },
          firstPageErrorIndicatorBuilder: (context) {
            return CustomErrorWidget(onTap: () {
              _pagingController.refresh();
            });
          },
          noMoreItemsIndicatorBuilder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "موردی یافت نشد",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 36),
              ],
            );
          },
          noItemsFoundIndicatorBuilder: (context) {
            return Center(
              child: Text(
                "موردی یافت نشد",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            );
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
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
