import 'package:flutter/material.dart';

import '../../core/app_export.dart';
// ignore_for_file: must_be_immutable

class AppbarLeadingImage extends StatelessWidget {
  AppbarLeadingImage({super.key, this.imagePath, this.margin, this.onTap});

  String? imagePath;

  EdgeInsetsGeometry? margin;

  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomImageView(
          imagePath: imagePath!,
          height: 24.adaptSize,
          width: 24.adaptSize,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
