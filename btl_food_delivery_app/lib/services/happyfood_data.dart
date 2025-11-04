import 'package:btl_food_delivery_app/model/happyfood_model.dart';

List<HappyfoodModel> getHappyFood() {
  List<HappyfoodModel> fastFood = [];
  HappyfoodModel happyfoodModel = HappyfoodModel();

  happyfoodModel.name = "Bánh cuốn";
  happyfoodModel.image = "assets/product/banhcuon.png";
  happyfoodModel.price = "2.59";
  fastFood.add(happyfoodModel);
  happyfoodModel = HappyfoodModel();

  happyfoodModel.name = "Bánh tráng";
  happyfoodModel.image = "assets/product/banhtrang.png";
  happyfoodModel.price = "0.99";
  fastFood.add(happyfoodModel);
  happyfoodModel = HappyfoodModel();

  happyfoodModel.name = "Bún đậu";
  happyfoodModel.image = "assets/product/bundau.png";
  happyfoodModel.price = "1.09";
  fastFood.add(happyfoodModel);
  happyfoodModel = HappyfoodModel();

  happyfoodModel.name = "Trả giò";
  happyfoodModel.image = "assets/product/tragio.png";
  happyfoodModel.price = "1.29";
  fastFood.add(happyfoodModel);
  happyfoodModel = HappyfoodModel();

  return fastFood;
}
