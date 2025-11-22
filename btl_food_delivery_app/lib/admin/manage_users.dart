import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  Stream<QuerySnapshot>? userStream;
  bool isLoading = true;
  String error = "";

  getOnTheLoad() async {
    try {
      setState(() {
        isLoading = true;
        error = "";
      });
      userStream = await DatabaseMethods().getAllUsers();
      setState(() {});
    } catch (e) {
      setState(() {
        error = "Lỗi tải danh sách người dùng: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOnTheLoad();
  }

  bool checkUser(Map<String, dynamic> userData) {
    try {
      String wallet = userData["wallet"]?.toString() ?? "0";
      double balance = double.tryParse(wallet) ?? 0;
      return balance <= 0;
    } catch (e) {
      return false;
    }
  }

  double getUserWallet(Map<String, dynamic> userData) {
    try {
      String wallet = userData["wallet"]?.toString() ?? "0";
      return double.tryParse(wallet) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<void> deleteUser(
    String userId,
    String userName,
    Map<String, dynamic> userData,
  ) async {
    if (!checkUser(userData)) {
      double balance = getUserWallet(userData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không thể xóa người dùng "$userName". Số dư tài khoản: \$$balance',
            style: AppTextStyles.of(
              context,
            ).regular20.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      bool confirmDel = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Xác nhận xóa",
            style: AppTextStyles.of(
              context,
            ).regular24.copyWith(color: AppColors.of(context).neutralColor12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Xóa người dùng '$userName'?",
                style: AppTextStyles.of(context).regular24.copyWith(
                  color: AppColors.of(context).neutralColor11,
                ),
              ),
              Text(
                "Số dư tài khoản: \$${getUserWallet(userData)}",
                style: AppTextStyles.of(context).regular20.copyWith(
                  color: AppColors.of(context).neutralColor12,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "Hủy",
                style: AppTextStyles.of(context).regular20.copyWith(
                  color: AppColors.of(context).neutralColor10,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.of(context).primaryColor9,
              ),
              child: Text(
                "Xóa",
                style: AppTextStyles.of(context).regular20.copyWith(
                  color: AppColors.of(context).neutralColor1,
                ),
              ),
            ),
          ],
        ),
      );

      if (confirmDel != true) return;

      await DatabaseMethods().deleteUser(userId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Đã xóa người dùng '$userName'",
            style: AppTextStyles.of(
              context,
            ).regular24.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh danh sách
      getOnTheLoad();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lỗi khi xóa người dùng: $e',
            style: AppTextStyles.of(
              context,
            ).regular24.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget allUsers() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.of(context).primaryColor10,
        ),
      );
    }

    if (error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 50.w, color: Colors.red),
            SizedBox(height: 10.h),
            Text(
              error,
              style: AppTextStyles.of(
                context,
              ).regular24.copyWith(color: AppColors.of(context).neutralColor10),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: getOnTheLoad,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.of(context).primaryColor9,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.w),
                ),
                elevation: 2,
              ),
              child: Text(
                'Thử lại',
                style: AppTextStyles.of(context).regular24.copyWith(
                  color: AppColors.of(context).neutralColor1,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: userStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.of(context).primaryColor10,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Lỗi: ${snapshot.error}",
              style: AppTextStyles.of(
                context,
              ).regular20.copyWith(color: AppColors.of(context).neutralColor11),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 60.w,
                  color: AppColors.of(context).neutralColor10,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Không có người dùng nào',
                  style: AppTextStyles.of(context).regular24.copyWith(
                    color: AppColors.of(context).neutralColor10,
                  ),
                ),
              ],
            ),
          );
        }

        var docs = snapshot.data!.docs;
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = docs[index];
            Map<String, dynamic> data = ds.data() as Map<String, dynamic>;

            double userBalance = getUserWallet(data);
            bool chekDel = checkUser(data);

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.w),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(20.w),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).neutralColor1,
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.w,
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.of(context).primaryColor10,
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.w),
                          child: data["imageUrl"] != null
                              ? Image.network(
                                  data["imageUrl"] ?? "",
                                  height: 70.h,
                                  width: 70.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/profilez.png",
                                      width: 70.w,
                                      height: 70.h,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  "assets/profilez.png",
                                  width: 70.w,
                                  height: 70.h,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 20.w,
                                  color: AppColors.of(context).primaryColor9,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  data['username'] ?? "Chưa rõ",
                                  style: AppTextStyles.of(context).bold24
                                      .copyWith(
                                        color: AppColors.of(
                                          context,
                                        ).neutralColor12,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  size: 20.w,
                                  color: AppColors.of(context).primaryColor9,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  data['email'] ?? "Chưa rõ",
                                  style: AppTextStyles.of(context).regular20
                                      .copyWith(
                                        color: AppColors.of(
                                          context,
                                        ).neutralColor11,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: userBalance > 0
                                          ? Colors.green
                                          : AppColors.of(
                                              context,
                                            ).neutralColor10,
                                      width: 1.w,
                                    ),
                                    borderRadius: BorderRadius.circular(8.w),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.account_balance_wallet_outlined,
                                        size: 16.w,
                                        color: userBalance > 0
                                            ? Colors.green
                                            : AppColors.of(
                                                context,
                                              ).neutralColor10,
                                      ),
                                      SizedBox(width: 4.w),
                                      Padding(
                                        padding: EdgeInsetsGeometry.only(
                                          top: 3.w,
                                        ),
                                        child: Text(
                                          "\$${userBalance.toStringAsFixed(2)}",
                                          style: AppTextStyles.of(context)
                                              .bold20
                                              .copyWith(
                                                color: userBalance > 0
                                                    ? Colors.green
                                                    : AppColors.of(
                                                        context,
                                                      ).neutralColor12,
                                              ),
                                        ),
                                      ),
                                      if (userBalance > 0)
                                        Padding(
                                          padding: EdgeInsets.only(left: 5.w),
                                          child: Icon(
                                            Icons.lock_outline,
                                            size: 16.w,
                                            color: Colors.orange,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),

                            GestureDetector(
                              onTap: chekDel
                                  ? () => deleteUser(
                                      data["id"] ?? ds.id,
                                      data["username"] ?? "Người dùng",
                                      data,
                                    )
                                  : null,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: chekDel
                                      ? Colors.red
                                      : AppColors.of(context).neutralColor9,
                                  borderRadius: BorderRadius.circular(10.w),
                                ),
                                child: Center(
                                  child: Text(
                                    "Remove",
                                    style: AppTextStyles.of(
                                      context,
                                    ).bold20.copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // AppBar
          Padding(
            padding: EdgeInsets.only(
              top: 45.h,
              left: 12.w,
              right: 12.w,
              bottom: 10.h,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.of(context).primaryColor9,
                      borderRadius: BorderRadius.circular(50.w),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.of(context).neutralColor1,
                    ),
                  ),
                ),
                SizedBox(width: 44.w),
                Text(
                  "Quản lý người dùng",
                  style: AppTextStyles.of(context).bold32.copyWith(
                    color: AppColors.of(context).neutralColor12,
                  ),
                ),
              ],
            ),
          ),

          // Display list
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.of(context).neutralColor7,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.w),
                  topRight: Radius.circular(20.w),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.4,
                    child: allUsers(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
