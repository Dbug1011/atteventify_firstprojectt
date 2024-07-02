import 'package:atteventify/core/app_export.dart';
import 'package:flutter/material.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray100,
      );
  static BoxDecoration get fillWhiteA => BoxDecoration(
        color: appTheme.whiteA700,
      );
  // Outline decorations
  static BoxDecoration get outlineGray => BoxDecoration(
        border: Border(
          top: BorderSide(
            color: appTheme.gray200,
            width: 1.h,
          ),
        ),
      );
}

class BorderRadiusStyle {
  // Rounded borders
  static BorderRadius get roundedBorder12 => BorderRadius.circular(
        12.h,
      );
}
