import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/models/city.dart';
import 'package:kanaf/widgets/address_dropdown_widget.dart';

import '/controllers/city_controller.dart';
import '/controllers/master_controller.dart';
import '/models/master.dart';
import '/res/controllers_key.dart';
import '/widgets/custom_error_widget.dart';
import '/widgets/custom_shimmer.dart';
import '/global_configs.dart';
import '/screens/services_list_screen.dart';
import '/widgets/custom_appbar.dart';
import '/controllers/size_controller.dart';
import '/res/enums/master_services.dart';
import '/widgets/master_services_items.dart';
import '/widgets/my_divider.dart';

class MasterServicesScreen extends StatefulWidget {
  const MasterServicesScreen({super.key});

  @override
  State<MasterServicesScreen> createState() => _MasterServicesScreenState();
}

class _MasterServicesScreenState extends State<MasterServicesScreen> {
  bool filterClick = false;

  bool isLoading = true;
  bool isFailed = false;

  bool isListEmpty = false;

  MasterController masterController =
      Get.find(tag: ControllersKey.masterControllerKey);

  CityController cityController = Get.find(
    tag: ControllersKey.cityControllerKey,
  );

  @override
  void initState() {
    super.initState();
    _fetchProfiles();

    // when city has saved
    if (cityController.selectedCity != null) {
      filterClick = true;
    }
  }

  Future<void> _fetchProfiles() async {
    setState(() {
      isLoading = true;
      isFailed = false;
    });

    List<Master>? response = await masterController.getMastersList(
      pageKey: 1,
      cityId: cityController.selectedCity?.id,
    );
    if (response == null) {
      isFailed = true;
      Get.showSnackbar(const GetSnackBar(
        title: "خطا",
        message: "خطایی رخ داده است",
        duration: Duration(seconds: 2),
      ));
    } else if (response.isEmpty) {
      isListEmpty = true;
    } else {
      isListEmpty = false;
    }

    setState(() {
      isLoading = false;
    });
  }

  void onSeeAllPressed(context, service) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ServicesListScreen(service: service);
    }));
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
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchProfiles();
        },
        child: SizedBox(
          width: SizeController.width(context),
          height: SizeController.height(context),
          child: Stack(
            children: [
              isLoading
                  ? CustomShimmer(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 80,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: globalBorderRadius * 3,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Container(
                                width: 150,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: globalBorderRadius,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(
                                width: 70,
                                height: 40,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 100,
                                height: 170,
                                decoration: BoxDecoration(
                                  borderRadius: globalBorderRadius * 10,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 170,
                                decoration: BoxDecoration(
                                  borderRadius: globalBorderRadius * 10,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 170,
                                decoration: BoxDecoration(
                                  borderRadius: globalBorderRadius * 10,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : isListEmpty
                      ? const Center(
                          child: Text("موردی یافت نشد"),
                        )
                      : isFailed
                          ? CustomErrorWidget(
                              onTap: () async => await _fetchProfiles(),
                            )
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  filterClick = false;
                                });
                              },
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  const SizedBox(height: 12),
                                  if (masterController
                                      .kanafMasters.isNotEmpty) ...[
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () => onSeeAllPressed(context,
                                              MasterServices.kanafWorker),
                                          child: Container(
                                            width: 75,
                                            height: 30,
                                            margin: const EdgeInsets.only(
                                                top: 10, right: 20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  globalBorderRadius * 3,
                                              color: theme.colorScheme.tertiary
                                                  .withValues(alpha: 0.75),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.arrow_back_ios,
                                                  size: 8,
                                                  color: theme
                                                      .colorScheme.onPrimary,
                                                ),
                                                Text(
                                                  "مشاهده همه",
                                                  style: theme
                                                      .textTheme.labelSmall
                                                      ?.copyWith(
                                                    color: theme
                                                        .colorScheme.onPrimary,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "کنافکار ها",
                                                    style: theme
                                                        .textTheme.headlineLarge
                                                        ?.copyWith(
                                                      color: theme
                                                          .colorScheme.tertiary,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 64),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 44,
                                                  right: 7,
                                                ),
                                                child: MyDivider(
                                                  color: theme
                                                      .colorScheme.onSecondary,
                                                  height: 10,
                                                  thickness: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: SizeController.width(context),
                                      height: 150,
                                      child: ListView.separated(
                                        padding: globalPadding * 10,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return MasterServicesItems(
                                            master: masterController
                                                .kanafMasters[index],
                                            service: MasterServices.kanafWorker,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(width: 9);
                                        },
                                        itemCount: masterController
                                            .kanafMasters.length,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                  if (masterController
                                      .lightLines.isNotEmpty) ...[
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () => onSeeAllPressed(context,
                                              MasterServices.kanafWorker),
                                          child: Container(
                                            width: 75,
                                            height: 30,
                                            margin: const EdgeInsets.only(
                                                top: 10, right: 20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  globalBorderRadius * 3,
                                              color: theme.colorScheme.tertiary
                                                  .withValues(alpha: 0.75),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.arrow_back_ios,
                                                  size: 8,
                                                  color: theme
                                                      .colorScheme.onPrimary,
                                                ),
                                                Text(
                                                  "مشاهده همه",
                                                  style: theme
                                                      .textTheme.labelSmall
                                                      ?.copyWith(
                                                    color: theme
                                                        .colorScheme.onPrimary,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "لاین نور",
                                                    style: theme
                                                        .textTheme.headlineLarge
                                                        ?.copyWith(
                                                            color: theme
                                                                .colorScheme
                                                                .tertiary,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                  ),
                                                  const SizedBox(width: 64),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 44, right: 7),
                                                child: MyDivider(
                                                  color: theme
                                                      .colorScheme.onSecondary,
                                                  height: 10,
                                                  thickness: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: SizeController.width(context),
                                      height: 150,
                                      child: ListView.separated(
                                        padding: globalPadding * 10,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return MasterServicesItems(
                                            master: masterController
                                                .lightLines[index],
                                            service:
                                                MasterServices.lightLineWorker,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            width: 9,
                                          );
                                        },
                                        itemCount:
                                            masterController.lightLines.length,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                  if (masterController.painters.isNotEmpty) ...[
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () => onSeeAllPressed(context,
                                              MasterServices.kanafWorker),
                                          child: Container(
                                            width: 75,
                                            height: 30,
                                            margin: const EdgeInsets.only(
                                                top: 10, right: 20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  globalBorderRadius * 3,
                                              color: theme.colorScheme.tertiary
                                                  .withValues(alpha: 0.75),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.arrow_back_ios,
                                                  size: 8,
                                                  color: theme
                                                      .colorScheme.onPrimary,
                                                ),
                                                Text(
                                                  "مشاهده همه",
                                                  style: theme
                                                      .textTheme.labelSmall
                                                      ?.copyWith(
                                                    color: theme
                                                        .colorScheme.onPrimary,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "نقاش ها",
                                                    style: theme
                                                        .textTheme.headlineLarge
                                                        ?.copyWith(
                                                            color: theme
                                                                .colorScheme
                                                                .tertiary,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                  ),
                                                  const SizedBox(width: 64),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 44, right: 7),
                                                child: MyDivider(
                                                  color: theme
                                                      .colorScheme.onSecondary,
                                                  height: 10,
                                                  thickness: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: SizeController.width(context),
                                      height: 150,
                                      child: ListView.separated(
                                        padding: globalPadding * 10,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return MasterServicesItems(
                                            master: masterController
                                                .painters[index],
                                            service:
                                                MasterServices.painterWorker,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            width: 9,
                                          );
                                        },
                                        itemCount:
                                            masterController.painters.length,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  if (masterController
                                      .electronics.isNotEmpty) ...[
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () => onSeeAllPressed(context,
                                              MasterServices.kanafWorker),
                                          child: Container(
                                            width: 75,
                                            height: 30,
                                            margin: const EdgeInsets.only(
                                                top: 10, right: 20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  globalBorderRadius * 3,
                                              color: theme.colorScheme.tertiary
                                                  .withValues(alpha: 0.75),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.arrow_back_ios,
                                                  size: 8,
                                                  color: theme
                                                      .colorScheme.onPrimary,
                                                ),
                                                Text(
                                                  "مشاهده همه",
                                                  style: theme
                                                      .textTheme.labelSmall
                                                      ?.copyWith(
                                                    color: theme
                                                        .colorScheme.onPrimary,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "برق کار ها",
                                                    style: theme
                                                        .textTheme.headlineLarge
                                                        ?.copyWith(
                                                            color: theme
                                                                .colorScheme
                                                                .tertiary,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                  ),
                                                  const SizedBox(width: 64),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 44, right: 7),
                                                child: MyDivider(
                                                  color: theme
                                                      .colorScheme.onSecondary,
                                                  height: 10,
                                                  thickness: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: SizeController.width(context),
                                      height: 150,
                                      child: ListView.separated(
                                        padding: globalPadding * 10,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return MasterServicesItems(
                                            master: masterController
                                                .electronics[index],
                                            service:
                                                MasterServices.painterWorker,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(width: 9);
                                        },
                                        itemCount:
                                            masterController.electronics.length,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 150)
                                ],
                              ),
                            ),
              Positioned(
                left: 0,
                top: 10,
                child: InkWell(
                  onTap: () => setState(() {
                    filterClick = !filterClick;
                  }),
                  child: isFailed
                      ? Container()
                      : Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: globalBorderRadius * 2,
                            color: theme.colorScheme.tertiary,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.settings_outlined,
                                    size: 24,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  Text(
                                    "فیلتر کنید",
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (filterClick) ...[
                                AddressDropdownWidget(
                                  cityOnTap: (City city) async {
                                    cityController.saveSelectedCity(city);
                                    await _fetchProfiles();
                                  },
                                  dropDownHeight: 30,
                                  fontSize: 7,
                                  dropDownColor: theme.colorScheme.secondary,
                                  selectedColor: theme.colorScheme.secondary,
                                  itemsDistanceHeight: 5,
                                  checkSave: true,
                                ),
                                const SizedBox(height: 20),
                              ]
                            ],
                          ),
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
