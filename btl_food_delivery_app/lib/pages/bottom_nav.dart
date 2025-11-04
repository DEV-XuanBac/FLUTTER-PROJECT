import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/pages/app_home.dart';
import 'package:btl_food_delivery_app/pages/order_page.dart';
import 'package:btl_food_delivery_app/pages/profile_page.dart';
import 'package:btl_food_delivery_app/pages/wallet_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;

  late AppHome appHome;
  late OrderPage orderPage;
  late WalletPage walletPage;
  late ProfilePage profilePage;

  int currentIdx = 0;

  @override
  void initState() {
    appHome = AppHome();
    orderPage = OrderPage();
    walletPage = WalletPage();
    profilePage = ProfilePage();

    pages = [appHome, orderPage, walletPage, profilePage];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 60.h,
        backgroundColor: Colors.transparent,
        color: AppColors.of(context).primaryColor9,
        animationDuration: Duration(microseconds: 500),
        onTap: (int index) {
          setState(() {
            currentIdx = index;
          });
        },
        items: [
          Icon(
            Icons.home,
            color: AppColors.of(context).neutralColor1,
            size: 30.w,
          ),
          Icon(
            Icons.shopping_bag,
            color: AppColors.of(context).neutralColor1,
            size: 30.w,
          ),
          Icon(
            Icons.wallet,
            color: AppColors.of(context).neutralColor1,
            size: 30.w,
          ),
          Icon(
            Icons.person,
            color: AppColors.of(context).neutralColor1,
            size: 30.w,
          ),
        ],
      ),
      body: pages[currentIdx],
    );
  }
}
