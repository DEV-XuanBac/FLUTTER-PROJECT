import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String? categoryId;
  String? categoryImage;
  String? categoryName;

  CategoryModel({this.categoryId, this.categoryImage, this.categoryName});

  // Tao contructor tu Document Snapshot
  factory CategoryModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return CategoryModel(
      categoryId: doc.id,
      categoryImage: data["categoryImage"],
      categoryName: data["categoryName"],
    );
  }

  // Tao contructor tu Map
  factory CategoryModel.fromMap(Map<String, dynamic> map, String? id) {
    return CategoryModel(
      categoryName: map['categoryName'],
      categoryImage: map["categoryImage"],
    );
  }

  // convert FoodModel to Map de luu FireStore
  Map<String, dynamic> toMap() {
    return {"categoryName": categoryName, "categoryImage": categoryImage};
  }
}
