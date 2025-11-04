import 'package:btl_food_delivery_app/l10n/l10n.dart';
import 'package:btl_food_delivery_app/model/category_model.dart';
import 'package:flutter/material.dart';

List<CategoryModel> getCategories(BuildContext context) {
  List<CategoryModel> category = [];
  CategoryModel categoryModel = CategoryModel();

  categoryModel.name = S.of(context).fastFood;
  categoryModel.image = "assets/category/doannhanh.png";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  categoryModel.name = S.of(context).happyFood;
  categoryModel.image = "assets/category/doanvat.png";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  categoryModel.name = S.of(context).familyFood;
  categoryModel.image = "assets/category/doangiadinh.png";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  return category;
}
