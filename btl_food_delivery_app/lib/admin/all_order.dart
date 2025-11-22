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

      orderStream = await DatabaseMethods().getAllAdminOrders();
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

  Color buttonColor(String status, BuildContext context) {
    switch (status.toLowerCase()) {
      case "pending":
        return AppColors.of(context).primaryColor9;
      case "delivered":
        return AppColors.of(context).neutralColor8;
      default:
        return AppColors.of(context).neutralColor1;
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

        // Phân loại đơn hàng
        final pendingOrders = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return (data["status"] ?? "Pending") == "Pending";
        }).toList();

        final doneOrders = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return (data["status"] ?? "Pending") == "Delivered";
        }).toList();

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            if (pendingOrders.isNotEmpty) ...[
              headerSection("Đơn hàng chờ xử lý (${pendingOrders.length})"),
              ...pendingOrders.map((ds) => orderItem(ds)),
            ],

            if (doneOrders.isNotEmpty) ...[
              headerSection("Đơn hàng đã giao (${doneOrders.length})"),
              ...doneOrders.map((ds) => orderItem(ds)),
            ],
          ],
        );
      },
    );
  }

  Widget orderItem(DocumentSnapshot ds) {
    Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
    final status = data["status"] ?? "Pending";
    final isDone = (status == "Delivered");
    final userId = data["id"] ?? "";

    return Container(
      margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
      child: Material(
        elevation: 3.0,
        borderRadius: BorderRadius.circular(14.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.of(context).neutralColor1,
            borderRadius: BorderRadius.circular(14.w),
            border: Border.all(
              color: isDone
                  ? Colors.green
                  : AppColors.of(context).primaryColor9,
              width: 1.5.w,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trạng thái + số lượng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        statusText(status),
                        style: AppTextStyles.of(
                          context,
                        ).bold24.copyWith(color: statusColor(status, context)),
                      ),
                    ],
                  ),
                  Text(
                    "${data["quantity"] ?? "0"}",
                    style: AppTextStyles.of(context).bold24.copyWith(
                      color: AppColors.of(context).neutralColor11,
                    ),
                  ),
                ],
              ),
              Divider(color: AppColors.of(context).neutralColor8),

              // Thông tin địa chỉ
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 20.w,
                    color: AppColors.of(context).primaryColor10,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      data["address"] ?? "Chưa có địa chỉ",
                      style: AppTextStyles.of(context).regular24.copyWith(
                        color: AppColors.of(context).neutralColor12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Thông tin sản phẩm và khách hàng
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hình ảnh sản phẩm
                  Container(
                    margin: EdgeInsets.only(top: 10.w),
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.w),
                      color: AppColors.of(context).neutralColor6,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.w),
                      child:
                          data["foodImage"] != null &&
                              data["foodImage"].toString().isNotEmpty
                          ? Image.network(
                              data["foodImage"],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.fastfood,
                                  size: 24.w,
                                  color: AppColors.of(context).neutralColor10,
                                );
                              },
                            )
                          : Icon(
                              Icons.fastfood,
                              size: 24.w,
                              color: AppColors.of(context).neutralColor10,
                            ),
                    ),
                  ),

                  SizedBox(width: 15.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên sản phẩm
                        Text(
                          data["foodName"] ?? "Chưa rõ",
                          style: AppTextStyles.of(context).bold24.copyWith(
                            color: AppColors.of(context).neutralColor12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Giá
                        Text(
                          "\$${data["total"] ?? "0"}",
                          style: AppTextStyles.of(context).bold24.copyWith(
                            color: AppColors.of(context).primaryColor9,
                          ),
                        ),
                        // Thông tin khách hàng
                        customerInfor(
                          Icons.person,
                          data["username"] ?? "Không có tên người nhận",
                        ),
                        customerInfor(Icons.email, data["phone"] ?? "Chưa rõ"),
                      ],
                    ),
                  ),
                ],
              ),
              // Nút hành động
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!isDone)
                    ElevatedButton(
                      onPressed: () => updateOrderStatus(ds.id, userId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor(status, context),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                      ),
                      child: Text(
                        "Xác nhận đã giao",
                        style: AppTextStyles.of(context).bold20.copyWith(
                          color: AppColors.of(context).neutralColor1,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: buttonColor(status, context),
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 20.w,
                            color: AppColors.of(context).neutralColor1,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "Đã giao hàng",
                            style: AppTextStyles.of(context).bold20.copyWith(
                              color: AppColors.of(context).neutralColor1,
                            ),
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
  }

  Widget headerSection(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Text(
        title,
        style: AppTextStyles.of(
          context,
        ).bold24.copyWith(color: AppColors.of(context).primaryColor10),
      ),
    );
  }

  Widget customerInfor(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20.w, color: AppColors.of(context).primaryColor9),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.of(
              context,
            ).regular24.copyWith(color: AppColors.of(context).neutralColor11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
                SizedBox(width: 50.w),
                Expanded(
                  child: Text(
                    "Tất cả đơn hàng",
                    style: AppTextStyles.of(context).bold32.copyWith(
                      color: AppColors.of(context).neutralColor12,
                    ),
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
                  topLeft: Radius.circular(16.w),
                  topRight: Radius.circular(16.w),
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
