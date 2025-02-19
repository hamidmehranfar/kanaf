import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../global_configs.dart';
import '../../res/app_colors.dart';
import '../../widgets/button_item.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/my_divider.dart';

class ActivateMasterProfileScreen extends StatefulWidget {
  const ActivateMasterProfileScreen({super.key});

  @override
  State<ActivateMasterProfileScreen> createState() => _ActivateMasterProfileScreenState();
}

class _ActivateMasterProfileScreenState extends State<ActivateMasterProfileScreen> {
  TextEditingController titleTextController = TextEditingController();
  TextEditingController cityTextController = TextEditingController();
  TextEditingController bioTextController = TextEditingController();
  TextEditingController birthDateTextController = TextEditingController();

  bool isLoading = false;

  List<String> payTypesItems = ['نوع پرداخت وجه','test 1', 'test 2'];
  List<String> gradeItems = ['مدرک تحصیلی', 'test 1', 'test 2'];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppbar(
        onTap: (){
          Navigator.of(context).pop();
        },
        iconAsset: "assets/icons/arrow_back_19.png",
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 25),
          Center(
            child: Text('فرم فعال سازی',
              style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w300,
                  color: theme.colorScheme.tertiary
              ),),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: globalPadding * 11,
            child: MyDivider(
              color: theme.colorScheme.onSecondary,
              height: 1,thickness: 1,
            ),
          ),
          const SizedBox(height: 17,),
          Container(
              margin: globalPadding * 6,
              padding: globalPadding * 7.5,
              decoration: BoxDecoration(
                borderRadius: globalBorderRadius * 6,
                color: theme.colorScheme.primary,
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 14,),
                  Container(
                    margin: globalPadding * 10,
                    padding: const EdgeInsets.only(bottom: 5, right: 9,left: 9),
                    decoration: BoxDecoration(
                      color: AppColors.textFieldColor,
                      borderRadius: globalBorderRadius * 4,
                    ),
                    child: TextField(
                      controller: titleTextController,
                      style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.surface
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "عنوان پروفایل",
                          hintStyle: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.surface.withValues(alpha: 0.5)
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    margin: globalPadding * 10,
                    padding: const EdgeInsets.only(bottom: 5, right: 9,left: 9),
                    decoration: BoxDecoration(
                      color: AppColors.textFieldColor,
                      borderRadius: globalBorderRadius * 4,
                    ),
                    child: TextField(
                      controller: cityTextController,
                      style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.surface
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "شهر",
                          hintStyle: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.surface.withValues(alpha: 0.5)
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    margin: globalPadding * 10,
                    padding: const EdgeInsets.only(bottom: 5, right: 9,left: 9),
                    decoration: BoxDecoration(
                      color: AppColors.textFieldColor,
                      borderRadius: globalBorderRadius * 4,
                    ),
                    child: TextField(
                      controller: bioTextController,
                      style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.surface
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "بیو",
                          hintStyle: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.surface.withValues(alpha: 0.5)
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    margin: globalPadding * 10,
                    padding: const EdgeInsets.only(bottom: 5, right: 9,left: 9),
                    decoration: BoxDecoration(
                      color: AppColors.textFieldColor,
                      borderRadius: globalBorderRadius * 4,
                    ),
                    child: TextField(
                      controller: birthDateTextController,
                      style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.surface
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "تاریخ تولد",
                          hintStyle: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.surface.withValues(alpha: 0.5)
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    height: 52,
                    margin: globalPadding * 10,
                    padding: globalPadding * 3,
                    decoration: BoxDecoration(
                      color: AppColors.sideColor.withValues(alpha: 0.55),
                      borderRadius: globalBorderRadius * 4,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: payTypesItems[0],
                        hint: Text("نوع پرداخت وجه",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSecondary.withValues(
                                alpha: 0.9
                            ),
                          ),),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                        onChanged: (String? newValue) {
                          setState(() {
                            // selectedValue = newValue;
                          });
                        },
                        items: payTypesItems
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSecondary.withValues(
                                    alpha: 0.9
                                ),
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    height: 52,
                    margin: globalPadding * 10,
                    padding: globalPadding * 3,
                    decoration: BoxDecoration(
                      color: AppColors.sideColor.withValues(alpha: 0.55),
                      borderRadius: globalBorderRadius * 4,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: gradeItems[0],
                        hint: Text("مدرک تحصیلی",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSecondary.withValues(
                                alpha: 0.9
                            ),
                          ),),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                        onChanged: (String? newValue) {
                          setState(() {
                            // selectedValue = newValue;
                          });
                        },
                        items: gradeItems
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSecondary.withValues(
                                    alpha: 0.9
                                ),
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24,),
                ],
              )
          ),
          const SizedBox(height: 9),
          Padding(
            padding: globalPadding * 11,
            child: MyDivider(
              color: theme.colorScheme.onSecondary,
              height: 1,thickness: 1,
            ),
          ),
          const SizedBox(height: 12),
          isLoading ? SpinKitThreeBounce(
            size: 14,
            color: theme.colorScheme.onSecondary,
          ) :
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonItem(
                width: 200,
                height: 50,
                onTap: () async {

                },
                title: "ذخیره",
                color: theme.colorScheme.tertiary,
              ),
            ],
          ),
          const SizedBox(height: 200,)
        ],
      ),
    );
  }
}
