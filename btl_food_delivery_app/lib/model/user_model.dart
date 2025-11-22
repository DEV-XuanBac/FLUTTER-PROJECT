class UserModel {
  String? userId;
  String? username;
  String? email;
  String? phone;
  String? wallet;
  String? imageUrl;
  String? address;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.userId,
    this.username,
    this.email,
    this.phone,
    this.wallet = "0",
    this.imageUrl,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  // Convert from Map to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      userId: id,
      username: map["username"],
      email: map["email"],
      phone: map["phone"],
      wallet: map["wallet"] ?? "0",
      imageUrl: map["imageUrl"],
      address: map["address"],
      createdAt: map["createdAt"]?.toDate(),
      updatedAt: map["updatedAt"]?.toDate(),
    );
  }

  // convert form UserModel to Map
  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "email": email,
      "phone": phone,
      "wallet": wallet ?? "0",
      "imageUrl": imageUrl,
      "address": address,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  Map<String, dynamic> toSignUpMap() {
    return {
      "username": username,
      "email": email,
      "wallet": wallet ?? "0",
      "phone": "",
      "imageUrl": "",
      "address": "",
      "createdAt": DateTime.now(),
      "updatedAt": DateTime.now()
    };
  }
}
