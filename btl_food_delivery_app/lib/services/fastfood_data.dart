import 'package:btl_food_delivery_app/model/fastfood_model.dart';

List<FastfoodModel> getFastFood() {
  List<FastfoodModel> fastFood = [];
  FastfoodModel fastfoodModel = FastfoodModel();

  fastfoodModel.name = "Bánh mì";
  fastfoodModel.image = "assets/product/banhmi.png";
  fastfoodModel.price = "1.25";
  fastFood.add(fastfoodModel);
  fastfoodModel = FastfoodModel();

  fastfoodModel.name = "Xôi xéo";
  fastfoodModel.image = "assets/product/xoixeo.png";
  fastfoodModel.price = "0.99";
  fastFood.add(fastfoodModel);
  fastfoodModel = FastfoodModel();

  fastfoodModel.name = "Cháo gà";
  fastfoodModel.image = "assets/product/chaoga.png";
  fastfoodModel.price = "1.09";
  fastFood.add(fastfoodModel);
  fastfoodModel = FastfoodModel();

  return fastFood;
}
