import 'package:btl_food_delivery_app/model/category_model.dart';

List<CategoryModel> getCategories() {
  List<CategoryModel> category = [];
  CategoryModel categoryModel = CategoryModel();

  categoryModel.name = "Fast Food";
  categoryModel.image = "assets/category/doannhanh.png";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  categoryModel.name = "Happy Food";
  categoryModel.image = "assets/category/doanvat.png";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  categoryModel.name = "Family Food";
  categoryModel.image = "assets/category/doangiadinh.png";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  return category;
}
