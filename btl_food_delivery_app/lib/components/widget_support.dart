import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle HeadlineTextFieldStyle(BuildContext context) {
    return AppTextStyles.of(
      context,
    ).bold32.copyWith(color: AppColors.of(context).neutralColor12);
  }

  static TextStyle SimpleTextFieldStyle(BuildContext context) {
    return AppTextStyles.of(
      context,
    ).regular32.copyWith(color: AppColors.of(context).neutralColor11);
  }

  static TextStyle whiteTextFieldStyle(BuildContext context) {
    return AppTextStyles.of(
      context,
    ).regular24.copyWith(color: AppColors.of(context).neutralColor1);
  }

  static TextStyle blackTextFieldStyle(BuildContext context) {
    return AppTextStyles.of(
      context,
    ).regular24.copyWith(color: AppColors.of(context).neutralColor12);
  }
}
