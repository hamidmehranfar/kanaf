import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:kanaf/models/employer_user.dart';
import 'package:kanaf/res/enums/api_method.dart';

import '/controllers/authentication_controller.dart';
import '/res/controllers_key.dart';
import '/res/enums/degree_type.dart';
import '/res/enums/payment_type.dart';
import '/global_configs.dart';
import '/res/app_colors.dart';
import '/widgets/button_item.dart';
import '/widgets/my_divider.dart';

class ActivateEmployerProfileSection extends StatefulWidget {
  final EmployerUser? employerUser;

  const ActivateEmployerProfileSection({
    super.key,
    required this.employerUser,
  });

  @override
  State<ActivateEmployerProfileSection> createState() =>
      _ActivateEmployerProfileSectionState();
}

class _ActivateEmployerProfileSectionState
    extends State<ActivateEmployerProfileSection> {
  TextEditingController titleTextController = TextEditingController();
  TextEditingController cityTextController = TextEditingController();
  TextEditingController bioTextController = TextEditingController();
  TextEditingController birthDateTextController = TextEditingController();

  bool isLoading = false;

  List<String> payTypesItems = [
    'نوع پرداخت وجه',
    convertPaymentToString(PaymentType.cash),
    convertPaymentToString(PaymentType.installment),
    convertPaymentToString(PaymentType.cashAndInstallment),
  ];
  List<String> gradeItems = [
    'مدرک تحصیلی',
    convertDegreeToString(DegreeType.noDegree),
    convertDegreeToString(DegreeType.diploma),
    convertDegreeToString(DegreeType.postGraduateDiploma),
    convertDegreeToString(DegreeType.bachelors),
    convertDegreeToString(DegreeType.masters),
    convertDegreeToString(DegreeType.phd),
  ];

  AuthenticationController authController = Get.find(
    tag: ControllersKey.authControllerKey,
  );

  String? selectedPayment;
  String? selectedGrade;

  @override
  void initState() {
    super.initState();

    if (widget.employerUser != null) setInitValues();
  }

  void setInitValues() {
    selectedGrade = convertDegreeToString(widget.employerUser!.degreeType);
    selectedPayment = convertPaymentToString(widget.employerUser!.paymentType);

    titleTextController.text = widget.employerUser!.title;
    cityTextController.text = widget.employerUser!.city.name;
    bioTextController.text = widget.employerUser!.bio;
    birthDateTextController.text = widget.employerUser!.birthday;
  }

  Future<void> activateEmployer() async {
    if (titleTextController.text.isEmpty ||
        cityTextController.text.isEmpty ||
        birthDateTextController.text.isEmpty ||
        selectedPayment == null ||
        selectedGrade == null) {
      //FIXME : show error
      return;
    }
    setState(() {
      isLoading = true;
    });

    await authController
        .activateEmployerProfile(
      title: titleTextController.text,
      cityId: 1,
      bio: bioTextController.text,
      birthDate: birthDateTextController.text,
      paymentIndex: convertStringToPayment(selectedPayment ?? '').index,
      degreeIndex: convertStringToDegree(selectedGrade ?? '').index,
      method: widget.employerUser == null ? ApiMethod.post : ApiMethod.patch,
    )
        .then((value) {
      if (value) {
        // show success
        Get.back(result: true);
      } else {
        // show error
        print(authController.apiMessage);
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.colorScheme.primary,
      child: ListView(
        padding: globalPadding * 6,
        shrinkWrap: true,
        children: [
          const SizedBox(height: 25),
          Center(
            child: Text(
              'فرم فعال سازی',
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 20,
                color: theme.colorScheme.surface.withValues(alpha: 0.38),
              ),
            ),
          ),
          const SizedBox(height: 14),
          MyDivider(
            color: AppColors.textFieldColor,
            height: 1,
            thickness: 1,
          ),
          const SizedBox(height: 17),
          ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 14),
              Container(
                margin: globalPadding * 5,
                padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
                decoration: BoxDecoration(
                  color: AppColors.textFieldColor,
                  borderRadius: globalBorderRadius * 4,
                ),
                child: TextField(
                  controller: titleTextController,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.surface,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: "عنوان پروفایل",
                    hintStyle: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.surface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Container(
                margin: globalPadding * 5,
                padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
                decoration: BoxDecoration(
                  color: AppColors.textFieldColor,
                  borderRadius: globalBorderRadius * 4,
                ),
                child: TextField(
                  controller: cityTextController,
                  style: theme.textTheme.labelLarge
                      ?.copyWith(color: theme.colorScheme.surface),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: "شهر",
                    hintStyle: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.surface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Container(
                margin: globalPadding * 5,
                padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
                decoration: BoxDecoration(
                  color: AppColors.textFieldColor,
                  borderRadius: globalBorderRadius * 4,
                ),
                child: TextField(
                  controller: bioTextController,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.surface,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: "بیو",
                    hintStyle: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.surface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Container(
                margin: globalPadding * 5,
                padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
                decoration: BoxDecoration(
                  color: AppColors.textFieldColor,
                  borderRadius: globalBorderRadius * 4,
                ),
                child: TextField(
                  controller: birthDateTextController,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.surface,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: "تاریخ تولد",
                    hintStyle: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.surface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Container(
                height: 52,
                margin: globalPadding * 5,
                padding: globalPadding * 3,
                decoration: BoxDecoration(
                  color: AppColors.sideColor.withValues(alpha: 0.55),
                  borderRadius: globalBorderRadius * 4,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: AppColors.sideColor,
                    borderRadius: globalBorderRadius * 4,
                    value: selectedPayment ?? payTypesItems[0],
                    hint: Text(
                      "نوع پرداخت وجه",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSecondary
                            .withValues(alpha: 0.9),
                      ),
                    ),
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.black87),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPayment = newValue;
                      });
                    },
                    items: payTypesItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSecondary
                                .withValues(alpha: 0.9),
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
                margin: globalPadding * 5,
                padding: globalPadding * 3,
                decoration: BoxDecoration(
                  color: AppColors.sideColor.withValues(alpha: 0.55),
                  borderRadius: globalBorderRadius * 4,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: AppColors.sideColor,
                    borderRadius: globalBorderRadius * 4,
                    value: selectedGrade ?? gradeItems[0],
                    hint: Text(
                      "مدرک تحصیلی",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSecondary
                            .withValues(alpha: 0.9),
                      ),
                    ),
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.black87),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGrade = newValue;
                      });
                    },
                    items: gradeItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSecondary
                                .withValues(alpha: 0.9),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
          const SizedBox(height: 9),
          MyDivider(
            color: AppColors.textFieldColor,
            height: 1,
            thickness: 1,
          ),
          const SizedBox(height: 12),
          isLoading
              ? SpinKitThreeBounce(
                  size: 14,
                  color: theme.colorScheme.onSecondary,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonItem(
                      width: 200,
                      height: 50,
                      onTap: () async {
                        await activateEmployer();
                      },
                      title: "ذخیره",
                      color: theme.colorScheme.tertiary,
                    ),
                  ],
                ),
          const SizedBox(height: 50)
        ],
      ),
    );
  }
}
