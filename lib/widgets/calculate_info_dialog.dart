import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '/controllers/calculate_controller.dart';
import '/global_configs.dart';
import '/models/calculate_material.dart';
import '/res/controllers_key.dart';
import '/screens/calculate_result_screen.dart';
import '/widgets/my_divider.dart';
import '/res/app_colors.dart';
import 'button_item.dart';

class CalculateInfoDialog extends StatefulWidget {
  final CalculateMaterial material;

  const CalculateInfoDialog({
    super.key,
    required this.material,
  });

  @override
  State<CalculateInfoDialog> createState() => _CalculateInfoDialogState();
}

class _CalculateInfoDialogState extends State<CalculateInfoDialog> {
  TextEditingController numberTextController = TextEditingController();

  TextEditingController? variable1TextController;
  TextEditingController? variable2TextController;

  CalculateController calculateController = Get.find(
    tag: ControllersKey.calculateControllerKey,
  );

  bool isGettingResult = false;

  @override
  void initState() {
    super.initState();
    setBackendVariables();
  }

  void setBackendVariables() {
    if (widget.material.variableLabel1 != null) {
      variable1TextController = TextEditingController();
    }
    if (widget.material.variableLabel2 != null) {
      variable2TextController = TextEditingController();
    }
  }

  Future<void> getResult() async {
    if (numberTextController.text.isEmpty) {
      //show error
      return;
    }

    setState(() {
      isGettingResult = true;
    });

    await calculateController
        .getResult(
      mainCategoryId: widget.material.id,
      quantity: numberTextController.text,
      variable1Value: variable1TextController?.text ?? '',
      variable2Value: variable2TextController?.text ?? '',
      variable1Label: widget.material.variableName1,
      variable2Label: widget.material.variableName2,
    )
        .then((value) {
      if (value.$1 != null && value.$2 != null) {
        Get.off(
          CalculateResultScreen(
            material: value.$2!,
            result: value.$1!,
          ),
        );
      } else {
        //show error
      }
    });

    setState(() {
      isGettingResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.colorScheme.primary,
      child: ListView(
        shrinkWrap: true,
        padding: globalPadding * 5,
        children: [
          const SizedBox(height: 34),
          Center(
            child: Text(
              widget.material.name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.surface.withValues(alpha: 0.7),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const MyDivider(
            color: Color(0xff333333),
            height: 1,
            thickness: 1,
          ),
          const SizedBox(height: 23),
          Container(
            margin: globalPadding * 5,
            padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
            decoration: BoxDecoration(
              color: AppColors.textFieldColor,
              borderRadius: globalBorderRadius * 4,
            ),
            child: TextField(
              controller: numberTextController,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.surface,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: "متراژ (متر)",
                hintStyle: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.surface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          if (variable1TextController != null) ...[
            const SizedBox(height: 10),
            Container(
              margin: globalPadding * 5,
              padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
              decoration: BoxDecoration(
                color: AppColors.textFieldColor,
                borderRadius: globalBorderRadius * 4,
              ),
              child: TextField(
                controller: variable1TextController,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.surface,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: "${widget.material.variableLabel1} (اختیاری)",
                  hintStyle: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.surface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ],
          if (variable2TextController != null) ...[
            const SizedBox(height: 10),
            Container(
              margin: globalPadding * 5,
              padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
              decoration: BoxDecoration(
                color: AppColors.textFieldColor,
                borderRadius: globalBorderRadius * 4,
              ),
              child: TextField(
                controller: variable2TextController,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.surface,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: widget.material.variableLabel2,
                  hintStyle: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.surface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            widget.material.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.surface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 20),
          const MyDivider(
            color: Color(0xff333333),
            height: 1,
            thickness: 1,
          ),
          const SizedBox(height: 14),
          Padding(
            padding: globalPadding * 15,
            child: isGettingResult
                ? SizedBox(
                    height: 50,
                    child: SpinKitThreeBounce(
                      color: theme.colorScheme.tertiary,
                      size: 20,
                    ),
                  )
                : ButtonItem(
                    onTap: () async => await getResult(),
                    isButtonDisable: isGettingResult,
                    title: "محاسبه",
                    color: theme.colorScheme.tertiary,
                    textStyle: theme.textTheme.bodyLarge,
                  ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
