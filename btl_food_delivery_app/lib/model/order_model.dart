import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? orderId;
  String? userId;
  String? username;
  String? email;
  String? phone;
  String? quantity;
  String? total;
  String? foodName;
  String? foodImage;
  String? status;
  String? address;
  DateTime? createdAt;

  OrderModel({
    this.orderId,
    this.userId,
    this.username,
    this.email,
    this.phone, // Thêm số điện thoại
    this.quantity,
    this.total,
    this.foodName,
    this.foodImage,
    this.status = "Pending",
    this.address,
    this.createdAt,
  });

  // Convert from Map to OrderModel
  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      orderId: id,
      userId: map['id'],
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      quantity: map['quantity'],
      total: map['total'],
      foodName: map['foodName'],
      foodImage: map['foodImage'],
      status: map['status'] ?? "Pending",
      address: map['address'],
      createdAt: map['createdAt']?.toDate(),
    );
  }

  // Convert from OrderModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': userId,
      'username': username,
      'email': email,
      'phone': phone,
      'quantity': quantity,
      'total': total,
      'foodName': foodName,
      'foodImage': foodImage,
      'status': status ?? "Pending",
      'address': address,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
