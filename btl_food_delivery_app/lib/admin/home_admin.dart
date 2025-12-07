import 'package:btl_food_delivery_app/admin/Auth/admin_login_page.dart';
import 'package:btl_food_delivery_app/admin/all_order.dart';
import 'package:btl_food_delivery_app/admin/manage_categories.dart';
import 'package:btl_food_delivery_app/admin/manage_foods.dart';
import 'package:btl_food_delivery_app/admin/manage_users.dart';
import 'package:btl_food_delivery_app/admin/sale_statistics.dart';
import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 45.h, left: 12.w, right: 12.w),
            child: Row(
              children: [
                Text(
                  "Trang quản trị",
                  style: AppTextStyles.of(context).bold32.copyWith(
                    color: AppColors.of(context).neutralColor12,
                  ),
                ),
              ],
            ),
          ),

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
                  SizedBox(height: 20.h),
                  // Quản lí danh sách orders
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AllOrder()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(20.w),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(5.w, 5.w, 20.w, 5.w),
                          decoration: BoxDecoration(
                            color: AppColors.of(context).neutralColor1,
                            borderRadius: BorderRadius.circular(20.w),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "assets/order.png",
                                width: 80.w,
                                height: 80.h,
                                fit: BoxFit.contain,
                              ),
                              Text(
                                "Quản lí đơn hàng",
                                style: AppTextStyles.of(context).bold32
                                    .copyWith(
                                      color: AppColors.of(
                                        context,
                                      ).neutralColor12,
                                    ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.of(context).primaryColor10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                  // Quản lí danh sách users
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ManageUsers()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(20.w),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(5.w, 5.w, 20.w, 5.w),
                          decoration: BoxDecoration(
                            color: AppColors.of(context).neutralColor1,
                            borderRadius: BorderRadius.circular(20.w),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 14.w,
                                  horizontal: 10.w,
                                ),
                                child: Image.asset(
                                  "assets/profile.png",
                                  width: 50.w,
                                  height: 50.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                "Quản lí người dùng",
                                style: AppTextStyles.of(context).bold32
                                    .copyWith(
                                      color: AppColors.of(
                                        context,
                                      ).neutralColor12,
                                    ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.of(context).primaryColor10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                  // Quản lí sản phẩm
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ManageFoods()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(20.w),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(5.w, 5.w, 20.w, 5.w),
                          decoration: BoxDecoration(
                            color: AppColors.of(context).neutralColor1,
                            borderRadius: BorderRadius.circular(20.w),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 14.w,
                                  horizontal: 10.w,
                                ),
                                child: Image.asset(
                                  "assets/food.png",
                                  width: 50.w,
                                  height: 50.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                "Quản lí sản phẩm",
                                style: AppTextStyles.of(context).bold32
                                    .copyWith(
                                      color: AppColors.of(
                                        context,
                                      ).neutralColor12,
                                    ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.of(context).primaryColor10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                  // Quản lí danh mục
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ManageCategories()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(20.w),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(5.w, 5.w, 20.w, 5.w),
                          decoration: BoxDecoration(
                            color: AppColors.of(context).neutralColor1,
                            borderRadius: BorderRadius.circular(20.w),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 14.w,
                                  horizontal: 10.w,
                                ),
                                child: Image.asset(
                                  "assets/categories.png",
                                  width: 50.w,
                                  height: 50.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                "Quản lí danh mục",
                                style: AppTextStyles.of(context).bold32
                                    .copyWith(
                                      color: AppColors.of(
                                        context,
                                      ).neutralColor12,
                                    ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.of(context).primaryColor10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                  // Thống kê doanh số
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SaleStatistics()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(20.w),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(5.w, 5.w, 20.w, 5.w),
                          decoration: BoxDecoration(
                            color: AppColors.of(context).neutralColor1,
                            borderRadius: BorderRadius.circular(20.w),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 14.w,
                                  horizontal: 10.w,
                                ),
                                child: Image.asset(
                                  "assets/statistics.png",
                                  width: 50.w,
                                  height: 50.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                "Thống kê doanh số",
                                style: AppTextStyles.of(context).bold32
                                    .copyWith(
                                      color: AppColors.of(
                                        context,
                                      ).neutralColor12,
                                    ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.of(context).primaryColor10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                  // Đăng xuất
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => AdminLoginPage()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(20.w),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(5.w, 5.w, 20.w, 5.w),
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.circular(20.w),
                          ),
                          child: Center(
                            child: Text(
                              "Đăng xuất",
                              style: AppTextStyles.of(
                                context,
                              ).bold32.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
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
