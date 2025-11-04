import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/pages/Auth/signup_page.dart';
import 'package:btl_food_delivery_app/pages/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "", password = "", name = "";
  TextEditingController nameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.of(context).primaryColor11,
            content: Text(
              "No user found for that Email",
              style: AppTextStyles.of(context).bold20,
            ),
          ),
        );
      } else if (e.code == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.of(context).primaryColor11,
            content: Text(
              "Wrong password provided by user",
              style: AppTextStyles.of(context).bold20,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          SingleChildScrollView(
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
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.8,
                  decoration: BoxDecoration(
                    color: AppColors.of(context).neutralColor2,
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Center(
                        child: Text(
                          "LogIn",
                          style: AppTextStyles.of(context).bold32.copyWith(
                            color: AppColors.of(context).primaryColor12,
                          ),
                        ),
                      ),

                      Text(
                        "Email: ",
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
                          controller: emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter email",
                            prefixIcon: Icon(Icons.email_outlined),
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
                        "Password: ",
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

                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Forgot password?",
                              style: AppTextStyles.of(context).regular20
                                  .copyWith(
                                    color: AppColors.of(context).primaryColor10,
                                  ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 30.h),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            if (emailController.text != "" &&
                                passwordController.text != "") {
                              setState(() {
                                email = emailController.text;
                                password = passwordController.text;
                              });
                              userLogin();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 35.w,
                              vertical: 3.w,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Don't have account? ",
                            style: AppTextStyles.of(context).light20.copyWith(
                              color: AppColors.of(context).neutralColor11,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => SignupPage()),
                              );
                            },
                            child: Text(
                              "Signup here",
                              style: AppTextStyles.of(context).bold20.copyWith(
                                color: AppColors.of(context).primaryColor10,
                              ),
                            ),
                          ),
                        ],
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
