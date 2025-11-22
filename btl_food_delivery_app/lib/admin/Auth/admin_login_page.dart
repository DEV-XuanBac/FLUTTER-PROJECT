import 'package:btl_food_delivery_app/admin/home_admin.dart';
import 'package:btl_food_delivery_app/pages/Auth/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/thems_extension.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  loginAdmin() {
    FirebaseFirestore.instance.collection("admin").get().then((value) {
      for (var result in value.docs) {
        if (result.data()['username'] != usernameController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Tên đăng nhập không chính xác",
                style: AppTextStyles.of(context).bold24,
              ),
            ),
          );
        } else if (result.data()["password"] != passwordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Mật khẩu không chính xác",
                style: AppTextStyles.of(context).bold24,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HomeAdmin()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.7,
            padding: EdgeInsets.only(top: 30.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.of(context).primaryColor8,
                  AppColors.of(context).primaryColor6,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(22.w),
                bottomRight: Radius.circular(22.w),
              ),
            ),
            child: Center(
              child: Image.asset(
                "assets/logo.png",
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width / 1.6,
                fit: BoxFit.contain,
              ),
            ),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 30.h),
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 3,
                left: 25.w,
                right: 25.w,
              ),
              child: Material(
                elevation: 8.0,
                borderRadius: BorderRadius.circular(20.w),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 20.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).neutralColor2,
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Quản lý",
                          style: AppTextStyles.of(context).bold32.copyWith(
                            color: AppColors.of(context).primaryColor12,
                          ),
                        ),
                      ),

                      Text(
                        "Tên người dùng:",
                        style: AppTextStyles.of(context).bold24.copyWith(
                          color: AppColors.of(context).neutralColor11,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor7,
                          borderRadius: BorderRadius.circular(12.w),
                          border: Border.all(
                            color: AppColors.of(context).neutralColor8,
                          ),
                        ),
                        child: TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Nhập tên người dùng",
                            prefixIcon: Icon(Icons.person_outline),
                            hintStyle: AppTextStyles.of(context).regular24
                                .copyWith(
                                  color: AppColors.of(context).neutralColor10,
                                ),
                          ),
                          style: AppTextStyles.of(context).regular24.copyWith(
                            color: AppColors.of(context).neutralColor10,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),

                      Text(
                        "Mật khẩu:",
                        style: AppTextStyles.of(context).bold24.copyWith(
                          color: AppColors.of(context).neutralColor11,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor7,
                          borderRadius: BorderRadius.circular(12.w),
                          border: Border.all(
                            color: AppColors.of(context).neutralColor8,
                          ),
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Nhập mật khẩu",
                            prefixIcon: Icon(Icons.password_outlined),
                            hintStyle: AppTextStyles.of(context).regular24
                                .copyWith(
                                  color: AppColors.of(context).neutralColor10,
                                ),
                          ),
                          style: AppTextStyles.of(context).regular24.copyWith(
                            color: AppColors.of(context).neutralColor10,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            loginAdmin();
                            // username: Xuan Bac
                            // password: xuanbac12345
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 35.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.of(context).primaryColor9,
                              borderRadius: BorderRadius.circular(14.w),
                            ),
                            child: Text(
                              "Đăng nhập",
                              style: AppTextStyles.of(context).bold32.copyWith(
                                color: AppColors.of(context).neutralColor1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => LoginPage()),
                            );
                          },
                          child: Text(
                            "Vai trò khách hàng",
                            style: AppTextStyles.of(context).bold20.copyWith(
                              color: AppColors.of(context).primaryColor9,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
