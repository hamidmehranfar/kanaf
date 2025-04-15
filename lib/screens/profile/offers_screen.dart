import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kanaf/controllers/size_controller.dart';
import 'package:kanaf/res/app_colors.dart';

import '/widgets/profile/offer_item.dart';
import '/global_configs.dart';
import '/models/offer_project.dart';
import '/res/enums/project_type.dart';
import '/widgets/my_divider.dart';
import '/controllers/project_controller.dart';
import '/res/controllers_key.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/custom_error_widget.dart';
import '/widgets/custom_shimmer.dart';

class OffersScreen extends StatefulWidget {
  final ProjectType type;

  const OffersScreen({super.key, required this.type});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  ProjectController profileController = Get.find(
    tag: ControllersKey.projectControllerKey,
  );

  final PagingController<int, OfferProject> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) async {
      await _fetchProjects(pageKey);
    });
  }

  Future<void> _fetchProjects(int pageKey) async {
    final newItems =
        await profileController.getOffers(pageKey: pageKey, type: widget.type);
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
      backgroundColor: theme.colorScheme.primary,
      appBar: CustomAppbar(
        iconAsset: "assets/icons/arrow_back_19.png",
        onTap: () => Get.back(),
      ),
      body: SizedBox(
        height: SizeController.height(context),
        child: RefreshIndicator(
          onRefresh: () async {
            _pagingController.refresh();
          },
          child: Padding(
            padding: globalPadding * 12,
            child: Column(
              children: [
                Text(
                  "پیشنهاد ها",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: globalPadding,
                  child: MyDivider(
                    color: theme.colorScheme.secondary,
                    height: 1,
                    thickness: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: PagedListView.separated(
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
                      itemBuilder:
                          (BuildContext context, OfferProject item, int index) {
                        return OfferItem(
                          project: item,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
