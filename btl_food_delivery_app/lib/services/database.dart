import 'package:btl_food_delivery_app/core/constants/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  // thêm người dùng mới
  Future addUserDetails(Map<String, dynamic> userInforMap, String id) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.usersCollection)
        .doc(id)
        .set(userInforMap);
  }

  // thêm đơn hàng cho người dùng cụ thể
  Future addUserOrderDetails(
    Map<String, dynamic> userOrderMap,
    String id,
    String orderId,
  ) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.usersCollection)
        .doc(id)
        .collection(FirestoreConstants.ordersSubCollection)
        .doc(orderId)
        .set(userOrderMap);
  }

  // Thêm đơn hàng vào bảng người quản trị
  Future addAdminOrderDetails(
    Map<String, dynamic> userOrderMap,
    String orderId,
  ) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.ordersCollection)
        .doc(orderId)
        .set(userOrderMap);
  }

  // Lấy thông tin đơn hàng người dùng
  Future<Stream<QuerySnapshot>> getUserOrders(String id) async {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.usersCollection)
        .doc(id)
        .collection(FirestoreConstants.ordersSubCollection)
        .orderBy("createdAt", descending: true) // Sắp xếp giảm dần từ mới -> cũ
        .snapshots();
  }

  // Lấy thông tin ví người dùng theo email
  Future<QuerySnapshot> getUserWalletByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.usersCollection)
        .where(FirestoreConstants.emailField, isEqualTo: email)
        .get();
  }

  // cập nhật số dư ví người dùng
  Future updateUserWallet(String amount, String id) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.usersCollection)
        .doc(id)
        .update({FirestoreConstants.walletField: amount});
  }

  // cập nhật ảnh đại diện người dùng
  Future updateUserProfileImg(String userId, String imageUrl) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.usersCollection)
        .doc(userId)
        .update({
          "imageUrl": imageUrl,
          "updatedAt": FieldValue.serverTimestamp(),
        });
  }

  // Cập nhật tên người dùng
  Future updateUserName(String userId, String name) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.usersCollection)
        .doc(userId)
        .update({"username": name, "updatedAt": FieldValue.serverTimestamp()});
  }

  // Cập nhật số điện thoại người dùng
  Future updateUserPhone(String userId, String phone) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.usersCollection)
        .doc(userId)
        .update({"phone": phone, "updatedAt": FieldValue.serverTimestamp()});
  }

  // Cập nhật địa chỉ người dùng
  Future updateUserAddress(String userId, String address) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.usersCollection)
        .doc(userId)
        .update({
          "address": address,
          "updatedAt": FieldValue.serverTimestamp(),
        });
  }

  // Lấy người dùng theo Id
  Future<DocumentSnapshot> getUserById(String id) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.usersCollection)
        .doc(id)
        .get();
  }

  // Lấy đơn hàng chờ xử lí admin
  Future<Stream<QuerySnapshot>> getAllAdminOrders() async {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.ordersCollection)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  // cập nhật trạng thái đơn hàng Admin
  Future updateAdminOrder(String id) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.ordersCollection)
        .doc(id)
        .update({
          FirestoreConstants.statusField: FirestoreConstants.statusDelivered,
        });
  }

  // Cập nhật trạng thái đơn hàng User
  Future updateUserOrder(String userId, String orderId) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.usersCollection)
        .doc(userId)
        .collection(FirestoreConstants.ordersSubCollection)
        .doc(orderId)
        .update({
          FirestoreConstants.statusField: FirestoreConstants.statusDelivered,
        });
  }

  // lấy thông tin toàn bộ người dùng Admin
  Future<Stream<QuerySnapshot>> getAllUsers() async {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.usersCollection)
        .snapshots();
  }

  // Xóa tài khoản người dùng
  Future deleteUser(String id) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.usersCollection)
        .doc(id)
        .delete();
  }

  // Thêm giao dịch phía người dùng
  Future addUserTransaction(Map<String, dynamic> userOderMap, String id) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.usersCollection)
        .doc(id)
        .collection(FirestoreConstants.transactionsSubCollection)
        .add(userOderMap);
  }

  // Lấy thống tin giao dịch người dùng
  Future<Stream<QuerySnapshot>> getUserTransactions(String id) async {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.usersCollection)
        .doc(id)
        .collection(FirestoreConstants.transactionsSubCollection)
        .orderBy("date", descending: true)
        .snapshots();
  }

  // FOODS //
  // Thêm sản phẩm mới
  Future addNewFood(Map<String, dynamic> foodMap, String foodId) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.foodsCollection)
        .doc(foodId)
        .set(foodMap);
  }

  // Cập nhật sản phẩm
  Future updateFood(Map<String, dynamic> foodMap, String foodId) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.foodsCollection)
        .doc(foodId)
        .update(foodMap);
  }

  // Xóa sản phẩm
  Future deleteFood(String foodId) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.foodsCollection)
        .doc(foodId)
        .delete();
  }

  // Lấy danh sách sản phẩm
  Future<Stream<QuerySnapshot>> getListFood() async {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.foodsCollection)
        .snapshots();
  }

  // lấy sản phẩm theo id
  Future<DocumentSnapshot> getFoodById(String foodId) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.foodsCollection)
        .doc(foodId)
        .get();
  }

  // Lấy sản phẩm theo danh mục
  Future<Stream<QuerySnapshot>> getFoodByCategory(String categoryId) async {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.foodsCollection)
        .where(FirestoreConstants.categoryIdField, isEqualTo: categoryId)
        .snapshots();
  }

  // tìm kiếm sản phẩm
  Future<QuerySnapshot> searchFood(String name) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.foodsCollection)
        .where(FirestoreConstants.nameField, isGreaterThanOrEqualTo: name)
        .where(FirestoreConstants.nameField, isLessThan: "${name}z")
        .get();
  }

  // CATEGORY
  Future addCategory(
    Map<String, dynamic> categoryMap,
    String categoryId,
  ) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.categoriesCollection)
        .doc(categoryId)
        .set(categoryMap);
  }

  Future<Stream<QuerySnapshot>> getAllCategories() async {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.categoriesCollection)
        .orderBy(FirestoreConstants.orderByCategoryName)
        .snapshots();
  }

  Future<DocumentSnapshot> getCategoryById(String categoryId) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.categoriesCollection)
        .doc(categoryId)
        .get();
  }

  Future updateCategory(
    Map<String, dynamic> categoryMap,
    String categoryId,
  ) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.categoriesCollection)
        .doc(categoryId)
        .update(categoryMap);
  }

  Future deleteCategory(String categoryId) async {
    return await FirebaseFirestore.instance
        .collection(FirestoreConstants.categoriesCollection)
        .doc(categoryId)
        .delete();
  }

  // Kiểm tra danh mục có trống không
  Future<bool> isCategoryEmpty(String categoryId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(FirestoreConstants.foodsCollection)
        .where(FirestoreConstants.categoryIdField, isEqualTo: categoryId)
        .limit(1)
        .get();
    return querySnapshot.docs.isEmpty;
  }

  // Lấy số lượng sản phẩm theo danh mục
  Future<int> getProductCountInCategory(String categoryId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(FirestoreConstants.foodsCollection)
        .where(FirestoreConstants.categoryIdField, isEqualTo: categoryId)
        .get();
    return querySnapshot.docs.length;
  }
}
