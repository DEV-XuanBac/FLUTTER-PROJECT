import 'package:btl_food_delivery_app/core/constants/color_constants.dart';
import 'package:btl_food_delivery_app/core/constants/text_style_constants.dart';
import 'package:flutter/material.dart';

class AppColors {
  static ColorThemeExt of(BuildContext context) {
    return Theme.of(context).extension<ColorThemeExt>()!;
  }
}

class AppTextStyles {
  static TextStyleExt of(BuildContext context) {
    return Theme.of(context).extension<TextStyleExt>()!;
  }
}
