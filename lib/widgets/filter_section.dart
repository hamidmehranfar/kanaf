import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/controllers/city_controller.dart';
import '/global_configs.dart';
import '/models/city.dart';
import '/models/province.dart';
import '/res/app_colors.dart';
import '/res/controllers_key.dart';
import '/widgets/address_dropdown_widget.dart';
import '/widgets/button_item.dart';
import '/widgets/my_divider.dart';

class FilterSection extends StatefulWidget {
  final Function(Province? province, City? city) onTap;

  const FilterSection({
    super.key,
    required this.onTap,
  });

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  CityController cityController = Get.find(
    tag: ControllersKey.cityControllerKey,
  );
  Province? selectedProvince;
  City? selectedCity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Dialog(
      backgroundColor: theme.colorScheme.primary,
      child: Container(
        padding: globalPadding * 5,
        decoration: BoxDecoration(
          borderRadius: globalBorderRadius * 6,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 33),
            Text(
              "فیلتر کنید",
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 20,
                color: theme.colorScheme.surface.withValues(alpha: 0.38),
              ),
            ),
            const SizedBox(height: 25),
            MyDivider(
              color: AppColors.paleBlack,
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: globalPadding * 6,
              child: AddressDropdownWidget(
                cityOnTap: (City? city) {
                  selectedCity = city;
                },
                provinceOnTap: (Province? province) {
                  selectedProvince = province;
                },
                itemsDistanceHeight: 9,
                dropDownHeight: 52,
                fontSize: 16,
                dropDownColor: theme.colorScheme.secondary,
                selectedColor: theme.colorScheme.secondary,
                checkSave: true,
              ),
            ),
            const SizedBox(height: 20),
            MyDivider(
              color: AppColors.paleBlack,
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.surface,
                    offset: const Offset(10, 10),
                    blurRadius: 60,
                    spreadRadius: -17,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonItem(
                    width: 200,
                    onTap: () {
                      if (selectedCity != null) {
                        cityController.saveSelectedProvince(selectedProvince!);
                        cityController.saveSelectedCity(selectedCity!);
                        widget.onTap(null, selectedCity);
                      } else if (selectedProvince != null) {
                        cityController.saveSelectedProvince(selectedProvince!);
                        cityController.removeSelectedCity();
                        widget.onTap(selectedProvince, null);
                      }

                      Get.back();
                    },
                    title: "اعمال",
                    color: theme.colorScheme.tertiary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.surface,
                    offset: const Offset(10, 10),
                    blurRadius: 60,
                    spreadRadius: -17,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonItem(
                    width: 200,
                    onTap: () {
                      cityController.removeSelectedProvince();
                      cityController.removeSelectedCity();

                      widget.onTap(null, null);

                      Get.back();
                    },
                    title: "برداشتن فیلتر",
                    color: theme.colorScheme.tertiary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 45),
          ],
        ),
      ),
    );
  }
}
