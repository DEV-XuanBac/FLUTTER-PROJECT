import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/pages/Auth/login_page.dart';
import 'package:btl_food_delivery_app/pages/bottom_nav.dart';
import 'package:btl_food_delivery_app/services/database.dart';
import 'package:btl_food_delivery_app/services/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:random_string/random_string.dart';

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

  registration() async {
    if (password.isNotEmpty &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        String id = randomAlphaNumeric(10);
        Map<String, dynamic> userInforMap = {
          "name": nameController.text,
          "email": emailController.text,
          "id": id,
          "wallet": "0",
        };
        await SharedPref().saveUserEmail(email);
        await SharedPref().saveUserName(nameController.text);
        await SharedPref().saveUserId(id);

        await DatabaseMethods().addUserDetails(userInforMap, id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Registered Successfully",
              style: AppTextStyles.of(context).bold20,
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => BottomNav()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak-password") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.of(context).primaryColor11,
              content: Text(
                "Password provided is too weak",
                style: AppTextStyles.of(context).bold20,
              ),
            ),
          );
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.of(context).primaryColor11,
              content: Text(
                "Account already exists",
                style: AppTextStyles.of(context).bold20,
              ),
            ),
          );
        }
      }
    }
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
                          "Sign Up",
                          style: AppTextStyles.of(context).bold32.copyWith(
                            color: AppColors.of(context).primaryColor12,
                          ),
                        ),
                      ),

                      Text(
                        "Name:",
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
                          controller: nameController,
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
                        "Email:",
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
                            if (nameController.text.isNotEmpty &&
                                emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              setState(() {
                                name = nameController.text;
                                password = passwordController.text;
                                email = emailController.text;
                              });
                              registration();
                            }
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
                              "Sign Up",
                              style: AppTextStyles.of(context).bold32.copyWith(
                                color: AppColors.of(context).neutralColor1,
                              ),
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
                              "Already have an account? ",
                              style: AppTextStyles.of(context).light20.copyWith(
                                color: AppColors.of(context).neutralColor11,
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
                                "Login here",
                                style: AppTextStyles.of(context).bold20
                                    .copyWith(
                                      color: AppColors.of(
                                        context,
                                      ).primaryColor10,
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
        ],
      ),
    );
  }
}
