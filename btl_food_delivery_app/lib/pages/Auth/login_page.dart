import 'package:btl_food_delivery_app/admin/Auth/admin_login_page.dart';
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
  String email = "", password = "";
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool obscurePw = true;

  Future<void> userLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNav()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String error = "Đã xảy ra lỗi, thử lại";
      if (e.code == "user-not-found") {
        error = "Không tìm thấy người dùng";
      } else if (e.code == "wrong-password") {
        error = "mật khẩu không chính xác";
      } else if (e.code == "invalid-email") {
        error = "Email không hợp lệ";
      } else if (e.code == "too-many-requests") {
        error = "Quá nhiều lần thử. Vui lòng thử lại sau";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.of(context).primaryColor10,
          content: Text(
            error,
            style: AppTextStyles.of(
              context,
            ).bold20.copyWith(color: AppColors.of(context).neutralColor1),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.of(context).primaryColor5,
                  AppColors.of(context).primaryColor9,
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
                  height: MediaQuery.of(context).size.height / 1.75,
                  decoration: BoxDecoration(
                    color: AppColors.of(context).neutralColor2,
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        Center(
                          child: Text(
                            "Đăng nhập",
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
                            border: Border.all(
                              color: AppColors.of(context).neutralColor8,
                              width: 1.w,
                            ),
                          ),
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                            onChanged: (value) => setState(() => email = value),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nhập email của bạn",
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: AppColors.of(context).neutralColor10,
                              ),
                              hintStyle: AppTextStyles.of(context).regular24
                                  .copyWith(
                                    color: AppColors.of(context).neutralColor10,
                                  ),
                              errorStyle: AppTextStyles.of(context).regular14
                                  .copyWith(
                                    color: AppColors.of(context).primaryColor11,
                                  ),
                            ),
                            style: AppTextStyles.of(context).regular24.copyWith(
                              color: AppColors.of(context).neutralColor12,
                            ),
                          ),
                        ),

                        // SizedBox(height: 10.h),
                        Text(
                          "Mật khẩu: ",
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
                              width: 1.w,
                            ),
                          ),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: obscurePw,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nhập mật khẩu của bạn",
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: AppColors.of(context).neutralColor10,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurePw = !obscurePw;
                                  });
                                },
                                icon: Icon(
                                  obscurePw
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.of(context).neutralColor10,
                                ),
                              ),
                              hintStyle: AppTextStyles.of(context).regular24
                                  .copyWith(
                                    color: AppColors.of(context).neutralColor10,
                                  ),
                              errorStyle: AppTextStyles.of(context).regular14
                                  .copyWith(
                                    color: AppColors.of(context).primaryColor11,
                                  ),
                            ),
                            style: AppTextStyles.of(context).regular24.copyWith(
                              color: AppColors.of(context).neutralColor12,
                            ),
                            validator: _validatePassword,
                            onChanged: (value) =>
                                setState(() => password = value),
                          ),
                        ),

                        SizedBox(height: 5.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Tính năng đang được phát triển",
                                    style: AppTextStyles.of(context).regular20
                                        .copyWith(
                                          color: AppColors.of(
                                            context,
                                          ).neutralColor1,
                                        ),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Quên mật khẩu?",
                              style: AppTextStyles.of(context).regular16
                                  .copyWith(
                                    color: AppColors.of(context).primaryColor10,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : userLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.of(
                                context,
                              ).primaryColor9,
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.w),
                              ),
                              elevation: 2,
                            ),
                            child: isLoading
                                ? SizedBox(child: CircularProgressIndicator())
                                : Text(
                                    "Đăng Nhập",
                                    style: AppTextStyles.of(context).bold20
                                        .copyWith(
                                          color: AppColors.of(
                                            context,
                                          ).neutralColor1,
                                        ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Center(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                "Chưa có tài khoản? ",
                                style: AppTextStyles.of(context).regular16
                                    .copyWith(
                                      color: AppColors.of(
                                        context,
                                      ).neutralColor11,
                                    ),
                              ),
                              GestureDetector(
                                onTap: isLoading
                                    ? null
                                    : () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => SignupPage(),
                                          ),
                                        );
                                      },
                                child: Text(
                                  "Đăng ký",
                                  style: AppTextStyles.of(context).bold16
                                      .copyWith(
                                        color: AppColors.of(
                                          context,
                                        ).primaryColor10,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.of(context).neutralColor6,
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.business_center_outlined,
                                color: AppColors.of(context).primaryColor9,
                                size: 24.w,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Đối tác nhà hàng?",
                                      style: AppTextStyles.of(context).bold16
                                          .copyWith(
                                            color: AppColors.of(
                                              context,
                                            ).neutralColor11,
                                          ),
                                    ),
                                    Text(
                                      "Liên hệ: 0123456789",
                                      style: AppTextStyles.of(context).regular16
                                          .copyWith(
                                            color: AppColors.of(
                                              context,
                                            ).neutralColor11,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: isLoading
                                    ? null
                                    : () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => AdminLoginPage(),
                                          ),
                                        );
                                      },
                                child: Text(
                                  "Partner",
                                  style: AppTextStyles.of(context).bold16
                                      .copyWith(
                                        color: AppColors.of(
                                          context,
                                        ).primaryColor9,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                            ],
                          ),
                        ),
                      ],
                    ),
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
