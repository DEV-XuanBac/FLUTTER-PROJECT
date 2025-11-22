import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/pages/Auth/login_page.dart';
import 'package:btl_food_delivery_app/pages/bottom_nav.dart';
import 'package:btl_food_delivery_app/services/database.dart';
import 'package:btl_food_delivery_app/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String email = "", password = "", name = "";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscurePw = true;

  Future<void> registration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      String id = userCredential.user!.uid;
      Map<String, dynamic> userInforMap = {
        "username": nameController.text.trim(),
        "email": emailController.text.trim(),
        "userId": id,
        "wallet": "0",
        "createdAt": FieldValue.serverTimestamp(),
      };
      await SharedPref().saveUserEmail(emailController.text.trim());
      await SharedPref().saveUserName(nameController.text.trim());
      await SharedPref().saveUserId(id);

      await DatabaseMethods().addUserDetails(userInforMap, id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Đăng kí thành công.",
              style: AppTextStyles.of(context).bold24,
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.w),
            ),
          ),
        );
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNav()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Đã xảy ra lỗi. Vui lòng thử lại.";
      if (e.code == "weak-password") {
        errorMessage = "Mật khẩu quá yếu, nhập lại";
      } else if (e.code == "email-already-in-use") {
        errorMessage = "Email đã được sử dụng";
      } else if (e.code == "invalid-email") {
        errorMessage = "Email không hợp lệ";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.of(context).primaryColor10,
          content: Text(
            errorMessage,
            style: AppTextStyles.of(
              context,
            ).bold20.copyWith(color: AppColors.of(context).neutralColor1),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập họ tên';
    }
    return null;
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2.7,
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
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).neutralColor1,
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Đăng kí",
                            style: AppTextStyles.of(context).bold32.copyWith(
                              color: AppColors.of(context).primaryColor12,
                            ),
                          ),
                        ),

                        Text(
                          "Họ tên:",
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
                            controller: nameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nhập họ tên của bạn",
                              prefixIcon: Icon(
                                Icons.person_outline,
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
                            validator: _validateName,
                            onChanged: (value) => setState(() => name = value),
                          ),
                        ),
                        SizedBox(height: 10.h),

                        Text(
                          "Email:",
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
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                            onChanged: (value) => setState(() => email = value),
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
                              width: 1.w,
                            ),
                          ),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: _obscurePw,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nhập mật khẩu",
                              prefixIcon: Icon(
                                Icons.lock_outline,
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
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePw = !_obscurePw;
                                  });
                                },
                                icon: Icon(
                                  _obscurePw
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.of(context).neutralColor10,
                                ),
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

                        SizedBox(height: 15.h),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : registration,
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
                            child: _isLoading
                                ? SizedBox(child: CircularProgressIndicator())
                                : Text(
                                    "Đăng Kí",
                                    style: AppTextStyles.of(context).bold24
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
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                "Bạn đã có tài khoản? ",
                                style: AppTextStyles.of(context).regular20
                                    .copyWith(
                                      color: AppColors.of(
                                        context,
                                      ).neutralColor11,
                                    ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Đăng nhập",
                                  style: AppTextStyles.of(context).bold20
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
