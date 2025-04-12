import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/controllers/city_controller.dart';
import 'package:kanaf/res/controllers_key.dart';

import '../global_configs.dart';
import '../models/city.dart';

class AddressDropdownWidget extends StatefulWidget {
  final Function(City city)? cityOnTap;
  final double itemsDistanceHeight;
  final double dropDownHeight;
  final double fontSize;
  final Color dropDownColor;
  final Color selectedColor;

  const AddressDropdownWidget({
    super.key,
    required this.cityOnTap,
    required this.itemsDistanceHeight,
    required this.dropDownHeight,
    required this.fontSize,
    required this.dropDownColor,
    required this.selectedColor,
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
    provinces = cityController.provinces.asMap().keys.toList();
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
                  cities = cityController
                      .provinces[provinces[selectedProvinceIndex!]].cities
                      .asMap()
                      .keys
                      .toList();
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
