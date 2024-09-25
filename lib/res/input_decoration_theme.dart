import 'package:flutter/material.dart';
import 'package:kanaf/global_configs.dart';
import 'package:kanaf/res/color_scheme.dart';

InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
  enabledBorder: OutlineInputBorder(
    borderRadius: globalBorderRadius,
    borderSide: BorderSide.none
  ),
  fillColor: lightColorScheme.primary.withOpacity(0.05),
  focusedBorder: OutlineInputBorder(
    borderRadius: globalBorderRadius,
    borderSide: BorderSide(
      width: 0.2,
      color: lightColorScheme.primary
    )
  )
);

InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
        borderRadius: globalBorderRadius,
        borderSide: BorderSide.none
    ),
    fillColor: darkColorScheme.primary.withOpacity(0.05),
    focusedBorder: OutlineInputBorder(
        borderRadius: globalBorderRadius,
        borderSide: BorderSide(
            width: 0.2,
            color: darkColorScheme.primary
        )
    )
);