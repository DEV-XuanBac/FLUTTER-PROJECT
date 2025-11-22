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
                "Your username is not correct",
                style: AppTextStyles.of(context).bold24,
              ),
            ),
          );
        } else if (result.data()["password"] != passwordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Your password is not correct",
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
              color: AppColors.of(context).primaryColor5,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(22.w),
                bottomRight: Radius.circular(22.w),
              ),
            ),
            child: Center(
              child: Image.asset(
                "assets/logo.png",
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2.7,
            padding: EdgeInsets.only(top: 30.h),
            decoration: BoxDecoration(
              color: AppColors.of(context).primaryColor5,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(22.w),
                bottomRight: Radius.circular(22.w),
              ),
            ),
            child: Center(
              child: Image.asset(
                "assets/logo.png",
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
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
                elevation: 3.0,
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
                          "Admin",
                          style: AppTextStyles.of(context).bold32.copyWith(
                            color: AppColors.of(context).primaryColor12,
                          ),
                        ),
                      ),

                      Text(
                        "User name:",
                        style: AppTextStyles.of(context).bold24.copyWith(
                          color: AppColors.of(context).neutralColor11,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor7,
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        child: TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter name",
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
                        "Password:",
                        style: AppTextStyles.of(context).bold24.copyWith(
                          color: AppColors.of(context).neutralColor11,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor7,
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter password",
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
                              borderRadius: BorderRadius.circular(50.w),
                            ),
                            child: Text(
                              "Log In",
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
                            "Login with role customer",
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
