import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/models/province.dart';
import '/controllers/city_controller.dart';
import '/res/controllers_key.dart';
import '/global_configs.dart';
import '/models/city.dart';

class AddressDropdownWidget extends StatefulWidget {
  final Function(City city)? cityOnTap;
  final Function(Province city)? provinceOnTap;
  final double itemsDistanceHeight;
  final double dropDownHeight;
  final double fontSize;
  final Color dropDownColor;
  final Color selectedColor;
  final bool checkSave;
  final City? selectedCity;

  const AddressDropdownWidget({
    super.key,
    required this.cityOnTap,
    required this.itemsDistanceHeight,
    required this.dropDownHeight,
    required this.fontSize,
    required this.dropDownColor,
    required this.selectedColor,
    this.checkSave = false,
    this.provinceOnTap,
    this.selectedCity,
  });

  @override
  State<AddressDropdownWidget> createState() => _AddressDropdownWidgetState();
}

class _AddressDropdownWidgetState extends State<AddressDropdownWidget> {
  CityController cityController =
      Get.find(tag: ControllersKey.cityControllerKey);

  List<int> provinces = [];
  List<int> cities = [];
  int? selectedProvinceIndex;
  int? selectedCityIndex;

  @override
  void initState() {
    super.initState();

    if (widget.checkSave) {
      initSelectedValues(
        cityController.selectedProvince,
        cityController.selectedCity,
      );
    } else if (widget.selectedCity != null) {
      initSelectedCity(
        widget.selectedCity,
      );
    }

    provinces = cityController.provinces.asMap().keys.toList();
  }

  void initSelectedValues(Province? selectedProvince, City? selectedCity) {
    for (int i = 0; i < cityController.provinces.length; i++) {
      if (cityController.provinces[i] == selectedProvince) {
        selectedProvinceIndex = i;
        cities = cityController.provinces[i].cities.asMap().keys.toList();

        for (int j = 0; j < cityController.provinces[i].cities.length; j++) {
          if (cityController.provinces[i].cities[j] == selectedCity) {
            selectedCityIndex = j;
            return;
          }
        }

        return;
      }
    }
  }

  void initSelectedCity(City? selectedCity) {
    for (int i = 0; i < cityController.provinces.length; i++) {
      for (int j = 0; j < cityController.provinces[i].cities.length; j++) {
        if (cityController.provinces[i].cities[j].id == selectedCity?.id) {
          selectedProvinceIndex = i;

          cities = cityController.provinces[i].cities.asMap().keys.toList();

          selectedCityIndex = j;
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      children: [
        Container(
          height: widget.dropDownHeight,
          padding: globalPadding,
          margin: globalPadding,
          decoration: BoxDecoration(
            color: widget.selectedColor,
            borderRadius: globalBorderRadius * 4,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Text(
                "انتخاب استان",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: widget.fontSize,
                  color: theme.colorScheme.onSecondary.withValues(alpha: 0.9),
                ),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.black87),
              ),
              items: provinces.map((int index) {
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text(
                    cityController.provinces[index].name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: widget.fontSize,
                      color:
                          theme.colorScheme.onSecondary.withValues(alpha: 0.9),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                );
              }).toList(),
              value: selectedProvinceIndex,
              onChanged: (value) {
                setState(() {
                  selectedProvinceIndex = value;
                  selectedCityIndex = null;
                  cities = cityController.provinces[value!].cities
                      .asMap()
                      .keys
                      .toList();
                  if (widget.provinceOnTap != null) {
                    widget.provinceOnTap!(cityController.provinces[value]);
                  }
                });
              },
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                decoration: BoxDecoration(
                  color: widget.dropDownColor,
                  borderRadius: globalBorderRadius * 4,
                ),
              ),
            ),
          ),
        ),
        if (selectedProvinceIndex != null) ...[
          SizedBox(height: widget.itemsDistanceHeight),
          Container(
            height: widget.dropDownHeight,
            padding: globalPadding,
            margin: globalPadding,
            decoration: BoxDecoration(
              color: widget.selectedColor,
              borderRadius: globalBorderRadius * 4,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<int>(
                isExpanded: true,
                hint: Text(
                  "انتخاب شهر",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: widget.fontSize,
                    color: theme.colorScheme.onSecondary.withValues(alpha: 0.9),
                  ),
                ),
                items: cities.map((var item) {
                  return DropdownMenuItem<int>(
                    value: item,
                    child: Text(
                      cityController.provinces[selectedProvinceIndex ?? 0]
                          .cities[item].name,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: widget.fontSize,
                        color: theme.colorScheme.onSecondary
                            .withValues(alpha: 0.9),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  );
                }).toList(),
                value: selectedCityIndex,
                onChanged: (value) {
                  setState(() {
                    selectedCityIndex = value;

                    City city = cityController
                        .provinces[selectedProvinceIndex ?? 0]
                        .cities[selectedCityIndex ?? 0];

                    if (widget.cityOnTap != null) {
                      widget.cityOnTap!(city);
                    }
                  });
                },
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  decoration: BoxDecoration(
                    color: widget.dropDownColor,
                    borderRadius: globalBorderRadius * 4,
                  ),
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }
}
