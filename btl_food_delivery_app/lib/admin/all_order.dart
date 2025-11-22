import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllOrder extends StatefulWidget {
  const AllOrder({super.key});

  @override
  State<AllOrder> createState() => _AllOrderState();
}

class _AllOrderState extends State<AllOrder> {
  Stream<QuerySnapshot>? orderStream;
  bool isLoading = true;
  String error = "";

  getInTheLoad() async {
    try {
      setState(() {
        isLoading = true;
        error = "";
      });

      orderStream = await DatabaseMethods().getAdminOrders();
      setState(() {});
    } catch (e) {
      setState(() {
        error = "Lỗi tải đơn hàng $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getInTheLoad();
    super.initState();
  }

  Future<void> updateOrderStatus(String orderId, String userId) async {
    try {
      setState(() {
        isLoading = true;
      });

      print("update: $orderId user: $userId");

      await DatabaseMethods().updateAdminOrder(orderId);
      await DatabaseMethods().updateUserOrder(userId, orderId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã cập nhật trạng thái đơn hàng',
            style: AppTextStyles.of(
              context,
            ).regular20.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh danh sách
      getInTheLoad();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lỗi cập nhật đơn hàng: $e',
            style: AppTextStyles.of(
              context,
            ).regular20.copyWith(color: Colors.white),
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

  Color statusColor(String status, BuildContext context) {
    switch (status.toLowerCase()) {
      case "pending":
        return AppColors.of(context).primaryColor10;
      case "delivered":
        return Colors.green;
      default:
        return AppColors.of(context).neutralColor10;
    }
  }

  String statusText(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return "Đang chờ";
      case "delivered":
        return "Đã giao";
      default:
        return status;
    }
  }

  Widget allOrder() {
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
              onPressed: getInTheLoad,
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
      stream: orderStream,
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
              "Xảy ra lỗi: ${snapshot.error}",
              style: AppTextStyles.of(
                context,
              ).regular24.copyWith(color: AppColors.of(context).neutralColor11),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80.w,
                  color: AppColors.of(context).neutralColor10,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Không có đơn hàng nào',
                  style: AppTextStyles.of(context).bold24.copyWith(
                    color: AppColors.of(context).neutralColor11,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];
            Map<String, dynamic> data = ds.data() as Map<String, dynamic>;

            final status = data["status"] ?? "Pending";
            final shouldShowButton = (status == "Pending");
            final userId = data["id"] ?? "";

            print("Order ${index + 1}:");
            print("  - ID: ${ds.id}");
            print("  - Status: $status");
            print("  - User ID: $userId");
            print("  - Should show button: $shouldShowButton");

            return Container(
              margin: EdgeInsets.only(top: 20.h, left: 10.w, right: 10.w),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(14.w),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).neutralColor1,
                    borderRadius: BorderRadius.circular(14.w),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 24.w,
                            color: AppColors.of(context).primaryColor10,
                          ),
                          SizedBox(width: 5.w),
                          Expanded(
                            child: Text(
                              data["address"] ?? "Chưa rõ",
                              style: AppTextStyles.of(context).bold24.copyWith(
                                color: AppColors.of(context).neutralColor12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: AppColors.of(context).neutralColor9),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.w),
                              image: DecorationImage(
                                image: NetworkImage(data["foodImage"] ?? ""),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data["foodName"] ?? "Chưa rõ",
                                  style: AppTextStyles.of(context).bold24
                                      .copyWith(
                                        color: AppColors.of(
                                          context,
                                        ).neutralColor12,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.production_quantity_limits,
                                          size: 16.w,
                                          color: AppColors.of(
                                            context,
                                          ).primaryColor10,
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          data["quantity"] ?? "0",
                                          style: AppTextStyles.of(context)
                                              .regular20
                                              .copyWith(
                                                color: AppColors.of(
                                                  context,
                                                ).neutralColor10,
                                              ),
                                        ),
                                        SizedBox(width: 20.w),
                                        Icon(
                                          Icons.monetization_on,
                                          size: 16.w,
                                          color: AppColors.of(
                                            context,
                                          ).primaryColor10,
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          "\$ ${data["total"] ?? "0"}",
                                          style: AppTextStyles.of(context)
                                              .regular20
                                              .copyWith(
                                                color: AppColors.of(
                                                  context,
                                                ).primaryColor9,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 18.w,
                                      color: AppColors.of(
                                        context,
                                      ).primaryColor9,
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      data["username"] ??
                                          "Không có tên người nhận",
                                      style: AppTextStyles.of(context).regular24
                                          .copyWith(
                                            color: AppColors.of(
                                              context,
                                            ).neutralColor12,
                                          ),
                                    ),
                                  ],
                                ),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.email,
                                      size: 18.w,
                                      color: AppColors.of(
                                        context,
                                      ).primaryColor9,
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      data["email"] ?? "Không có email",
                                      style: AppTextStyles.of(context).regular24
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${statusText(data["status"])}!",
                                      style: AppTextStyles.of(context).bold24
                                          .copyWith(
                                            color: statusColor(
                                              data["status"],
                                              context,
                                            ),
                                          ),
                                    ),

                                    if (shouldShowButton)
                                      GestureDetector(
                                        onTap: () =>
                                            updateOrderStatus(ds.id, userId),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20.w,
                                            vertical: 4.w,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.of(
                                              context,
                                            ).primaryColor9,
                                            borderRadius: BorderRadius.circular(
                                              10.w,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Đã giao",
                                              style: AppTextStyles.of(context)
                                                  .bold24
                                                  .copyWith(
                                                    color: AppColors.of(
                                                      context,
                                                    ).neutralColor1,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
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
                      size: 24.w,
                    ),
                  ),
                ),
                SizedBox(width: 54.w),
                Expanded(
                  child: Text(
                    "Tất cả đơn hàng",
                    style: AppTextStyles.of(context).bold32.copyWith(
                      color: AppColors.of(context).neutralColor12,
                    ),
                  ),
                ),
                if (isLoading)
                  SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.w,
                      color: AppColors.of(context).primaryColor10,
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
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: allOrder(),
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
