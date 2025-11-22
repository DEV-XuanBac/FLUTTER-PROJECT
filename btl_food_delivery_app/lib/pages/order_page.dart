import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/services/database.dart';
import 'package:btl_food_delivery_app/services/shared_pref.dart';
import 'package:btl_food_delivery_app/components/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Stream? orderStream;
  String? id;
  bool isLoading = true;

  getTheSharedRef() async {
    id = await SharedPref().getUserId();
    if (mounted) setState(() {});
  }

  getOnTheLoad() async {
    await getTheSharedRef();
    orderStream = await DatabaseMethods().getUserOrders(id!);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getOnTheLoad();
  }

  String formatOrderDate(dynamic timestamp) {
    if (timestamp == null) return "2025";

    try {
      if (timestamp is Timestamp) {
        DateTime date = timestamp.toDate();
        return DateFormat('dd/MM/yyyy - HH:mm').format(date);
      } else if (timestamp is String) {
        return timestamp;
      }
      return "2025";
    } catch (e) {
      return "Không rõ thời gian";
    }
  }

  Color statusColor(String status) {
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
    return StreamBuilder(
      stream: orderStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 60.w,
                  color: AppColors.of(context).neutralColor10,
                ),
                SizedBox(height: 12.h),
                Text(
                  "Lỗi cập nhật đơn hàng",
                  style: AppTextStyles.of(context).regular24.copyWith(
                    color: AppColors.of(context).neutralColor10,
                  ),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 60.w,
                  color: AppColors.of(context).neutralColor10,
                ),
                SizedBox(height: 12.h),
                Text(
                  "Chưa có đơn hàng",
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

            final data = ds.data() as Map<String, dynamic>;
            final status = data["status"] ?? "Pending";
            final total =
                double.tryParse(data["total"]?.toString() ?? "0") ?? 0;
            final quantity = data["quantity"] ?? "1";
            final foodName = data["foodName"] ?? "Không rõ tên";
            final foodImage = data["foodImage"] ?? "";
            final address = data["address"] ?? "Không có địa chỉ";
            final createdAt = data["createdAt"];

            return Container(
              padding: EdgeInsets.all(14.w),
              margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.w),
                border: Border.all(width: 1.5, color: statusColor(status)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (createdAt != null)
                        Text(
                          formatOrderDate(createdAt),
                          style: AppTextStyles.of(context).regular24.copyWith(
                            color: AppColors.of(context).neutralColor12,
                          ),
                        ),
                      Spacer(),
                      Text(
                        statusText(status),
                        style: AppTextStyles.of(
                          context,
                        ).regular24.copyWith(color: statusColor(status)),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ảnh sản phẩm
                      Container(
                        width: 100.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.w),
                          color: AppColors.of(context).neutralColor10,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14.w),
                          child: foodImage.toString().startsWith("http")
                              ? Image.network(
                                  foodImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: AppColors.of(
                                        context,
                                      ).neutralColor5,
                                      child: Icon(
                                        Icons.fastfood,
                                        size: 36.w,
                                        color: AppColors.of(
                                          context,
                                        ).neutralColor10,
                                      ),
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                )
                              : Icon(
                                  Icons.fastfood,
                                  size: 36.w,
                                  color: AppColors.of(context).neutralColor10,
                                ),
                        ),
                      ),
                      SizedBox(width: 20.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tên sản phẩm
                            Text(
                              foodName,
                              style: AppTextStyles.of(context).bold24.copyWith(
                                color: AppColors.of(context).neutralColor12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            // Giá, số lượng
                            Row(
                              children: [
                                Icon(
                                  Icons.production_quantity_limits_rounded,
                                  color: AppColors.of(context).neutralColor10,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  "$quantity",
                                  style: AppTextStyles.of(context).regular24
                                      .copyWith(
                                        color: AppColors.of(
                                          context,
                                        ).neutralColor11,
                                      ),
                                ),
                                SizedBox(width: 30.w),
                                Icon(
                                  Icons.attach_money,
                                  color: AppColors.of(context).neutralColor10,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  total.toStringAsFixed(2),
                                  style: AppTextStyles.of(context).regular24
                                      .copyWith(
                                        color: AppColors.of(
                                          context,
                                        ).neutralColor11,
                                      ),
                                ),
                              ],
                            ),

                            // Địa chỉ
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 24.w,
                                  color: AppColors.of(context).primaryColor10,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  address,
                                  style: AppTextStyles.of(context).regular24
                                      .copyWith(
                                        color: AppColors.of(
                                          context,
                                        ).neutralColor12,
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
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Đơn hàng của bạn",
                  style: AppWidget.HeadlineTextFieldStyle(context),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.3,
                    child: allOrder(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
