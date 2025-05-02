import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '/widgets/offer/offer_tab_item.dart';
import '/res/enums/offer_status.dart';
import '/controllers/size_controller.dart';
import '/global_configs.dart';
import '/models/offer_project.dart';
import '/res/enums/project_type.dart';
import '/widgets/my_divider.dart';
import '/controllers/project_controller.dart';
import '/res/controllers_key.dart';
import '/widgets/custom_appbar.dart';

class OffersScreen extends StatefulWidget {
  final ProjectType type;

  const OffersScreen({super.key, required this.type});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen>
    with SingleTickerProviderStateMixin {
  ProjectController projectController = Get.find(
    tag: ControllersKey.projectControllerKey,
  );

  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });

    projectController.initPagingControllers();
  }

  @override
  void dispose() {
    super.dispose();
    projectController.deposePagingControllers();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: CustomAppbar(
        iconAsset: "assets/icons/arrow_back_19.png",
        onTap: () => Navigator.of(context).pop(),
        hasShadow: true,
      ),
      body: SizedBox(
        height: SizeController.height(context),
        child: Padding(
          padding: globalPadding * 12,
          child: Column(
            children: [
              const SizedBox(height: 25),
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
              const SizedBox(height: 12),
              TabBar(
                labelColor: theme.colorScheme.surface,
                unselectedLabelColor:
                    theme.colorScheme.surface.withValues(alpha: 0.5),
                unselectedLabelStyle: theme.textTheme.labelMedium,
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: List.generate(
                  OfferStatus.values.length,
                  (index) {
                    return Tab(
                      child: Text(
                        convertOfferStatusToString(
                          OfferStatus.values[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: List.generate(
                    OfferStatus.values.length,
                    (index) {
                      return OfferTabItem(
                        key: ValueKey(OfferStatus.values[index]),
                        type: widget.type,
                        offerStatusIndex: index,
                      );
                    },
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
