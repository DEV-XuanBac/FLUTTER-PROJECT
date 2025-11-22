import 'package:cloud_firestore/cloud_firestore.dart';

class FoodModel {
  String? id;
  String? name;
  String? image;
  double? price;
  String? categoryId;
  String? description;
  String? item;
  String? kcal;
  bool? isAvailable;
  String? searchKey;

  FoodModel({
    this.id,
    this.name,
    this.image,
    this.price,
    this.categoryId,
    this.description,
    this.item,
    this.kcal,
    this.isAvailable = true,
    this.searchKey,
  });

  // Tao contructor tu Document Snapshot
  factory FoodModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return FoodModel(
      id: doc.id,
      name: data["name"],
      image: data["image"],
      price: (data["price"] as num?)?.toDouble(),
      categoryId: data['categoryId'],
      description: data['description'],
      item: data['item'],
      kcal: data['kcal'],
      isAvailable: data['isAvailable'] ?? true,
      searchKey: data['searchKey'],
    );
  }

  // Tao contructor tu Map
  factory FoodModel.fromMap(Map<String, dynamic> map, String? id) {
    return FoodModel(
      id: id,
      name: map['name'],
      image: map["image"],
      price: (map["price"] as num?)?.toDouble(),
      categoryId: map["categoryId"],
      description: map["description"],
      item: map["item"],
      kcal: map["kcal"],
      isAvailable: map["isAvailable"] ?? true,
      searchKey: map["searchKey"],
    );
  }

  // convert FoodModel to Map de luu FireStore
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "image": image,
      "price": price,
      "categoryId": categoryId,
      "description": description,
      "item": item,
      "kcal": kcal,
      "isAvailable": isAvailable ?? true,
      "searchKey": searchKey,
    };
  }
}
