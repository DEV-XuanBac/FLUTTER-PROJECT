import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/pages/Auth/login_page.dart';
import 'package:btl_food_delivery_app/components/widget_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40.h),
        child: Column(
          children: [
            Image.asset("assets/onz.png"),
            SizedBox(height: 25.h),
            Text(
              "The Fastest\nFood Delivery",
              textAlign: TextAlign.center,
              style: AppWidget.HeadlineTextFieldStyle(context),
            ),
            SizedBox(height: 15.h),
            Text(
              "Craving something delicious?\nOrder now and get your favorites\ndelivered fast!",
              textAlign: TextAlign.center,
              style: AppWidget.SimpleTextFieldStyle(context),
            ),
            SizedBox(height: 30.h),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
              child: Container(
                height: 45.h,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  color: AppColors.of(context).primaryColor11,
                  borderRadius: BorderRadius.circular(18.w),
                ),
                child: Center(
                  child: Text(
                    "Get started",
                    style: AppTextStyles.of(context).bold24.copyWith(
                      color: AppColors.of(context).neutralColor1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
