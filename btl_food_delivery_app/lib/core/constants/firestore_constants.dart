class FirestoreConstants {
  // Collections
  static const String usersCollection = "users";
  static const String ordersCollection = "orders";
  static const String foodsCollection = "foods";
  static const String categoriesCollection = "categories";
  
  // Sub-collections
  static const String ordersSubCollection = "orders";
  static const String transactionsSubCollection = "transactions";
  
  // Field names
  static const String emailField = "email";
  static const String walletField = "wallet";
  static const String statusField = "status";
  static const String categoryIdField = "categoryId";
  static const String nameField = "name";
  static const String categoryNameField = "categoryName";
  
  // Status values
  static const String statusPending = "Pending";
  static const String statusDelivered = "Delivered";
  
  // Order by fields
  static const String orderByCategoryName = "categoryName";
}