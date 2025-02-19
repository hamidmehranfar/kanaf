import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kanaf/controllers/home_controller.dart';
import 'package:kanaf/models/tip.dart';
import 'package:kanaf/widgets/tips_item.dart';

import '../controllers/size_controller.dart';
import '../global_configs.dart';
import '../res/controllers_key.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_error_widget.dart';
import '../widgets/custom_shimmer.dart';
import '../widgets/my_divider.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  HomeController homeController = Get.find(
    tag: ControllersKey.homeControllerKey,
  );

  PagingController<int, Tip> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) async {
      await _fetchTips(pageKey);
    });
  }

  Future<void> _fetchTips(int pageKey) async {
    final newItems = await homeController.getTips(pageKey);
    if (newItems == null) {
      _pagingController.error = homeController.apiMessage;
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
          Navigator.of(context).pop();
        },
        iconAsset: "assets/icons/arrow_back_19.png",
      ),
      body: SizedBox(
        width: SizeController.width(context),
        height: SizeController.height(context),
        child: RefreshIndicator(
          onRefresh: () async => _pagingController.refresh(),
          child: Padding(
            padding: globalPadding * 5,
            child: Column(
              children: [
                const SizedBox(height: 14),
                Center(
                  child: Text(
                    "آموزش و ترفندها",
                    style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w300,
                        color: theme.colorScheme.tertiary),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: globalPadding * 11,
                  child: MyDivider(
                    color: theme.colorScheme.onSecondary,
                    height: 1,
                    thickness: 1,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: PagedListView.separated(
                    pagingController: _pagingController,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 16);
                    },
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (BuildContext context, Tip item, int index) {
                        return TipsItem(
                          item: item,
                        );
                      },
                      firstPageErrorIndicatorBuilder: (context) {
                        return CustomErrorWidget(
                          onTap: () {
                            _pagingController.refresh();
                          },
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
