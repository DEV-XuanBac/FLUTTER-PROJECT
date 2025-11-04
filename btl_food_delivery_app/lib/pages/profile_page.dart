import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/l10n/l10n.dart';
import 'package:btl_food_delivery_app/main.dart';
import 'package:btl_food_delivery_app/pages/onboarding.dart';
import 'package:btl_food_delivery_app/services/auth_methods.dart';
import 'package:btl_food_delivery_app/services/shared_pref.dart';
import 'package:btl_food_delivery_app/services/widget_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? email, name;

  getTheSharedPref() async {
    name = await SharedPref().getUsername();
    email = await SharedPref().getUserEmail();
    setState(() {});
  }

  @override
  void initState() {
    getTheSharedPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (name == null || email == null)
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.only(top: 40.h),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      S.of(context).profile,
                      style: AppWidget.HeadlineTextFieldStyle(context),
                    ),
                  ),
                  SizedBox(height: 10.h),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 50.h),
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.w),
                              child: Image.asset(
                                "assets/profilez.png",
                                width: 100.w,
                                height: 100.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // Name
                          SizedBox(height: 40.h),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Material(
                              borderRadius: BorderRadius.circular(18.w),
                              elevation: 3.0,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                decoration: BoxDecoration(
                                  color: AppColors.of(context).neutralColor1,
                                  borderRadius: BorderRadius.circular(18.w),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person_outlined,
                                      size: 30.w,
                                      color: AppColors.of(
                                        context,
                                      ).primaryColor10,
                                    ),
                                    SizedBox(width: 20.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          S.of(context).name,
                                          style: AppTextStyles.of(context)
                                              .bold20
                                              .copyWith(
                                                color: AppColors.of(
                                                  context,
                                                ).neutralColor10,
                                              ),
                                        ),
                                        Text(
                                          name!,
                                          style: AppTextStyles.of(context)
                                              .regular24
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
                            ),
                          ),

                          // Email
                          SizedBox(height: 20.h),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Material(
                              borderRadius: BorderRadius.circular(18.w),
                              elevation: 3.0,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                decoration: BoxDecoration(
                                  color: AppColors.of(context).neutralColor1,
                                  borderRadius: BorderRadius.circular(18.w),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.email_outlined,
                                      size: 30.w,
                                      color: AppColors.of(
                                        context,
                                      ).primaryColor10,
                                    ),
                                    SizedBox(width: 20.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          S.of(context).email,
                                          style: AppTextStyles.of(context)
                                              .bold20
                                              .copyWith(
                                                color: AppColors.of(
                                                  context,
                                                ).neutralColor10,
                                              ),
                                        ),
                                        Text(
                                          email!,
                                          style: AppTextStyles.of(context)
                                              .regular24
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
                            ),
                          ),

                          // Language
                          SizedBox(height: 20.h),
                          GestureDetector(
                            onTap: () async {
                              Locale current = await SharedPref().getLanguage();
                              Locale newLocale = current.languageCode == 'en'
                                  ? Locale("vi")
                                  : Locale("en");

                              await SharedPref().setLanguage(
                                newLocale.languageCode,
                              );
                              MyApp.setLocale(context, newLocale);
                              setState(() {
                                newLocale.languageCode == 'en';
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Material(
                                borderRadius: BorderRadius.circular(18.w),
                                elevation: 3.0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 14.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.of(context).neutralColor1,
                                    borderRadius: BorderRadius.circular(18.w),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.language,
                                        size: 30.w,
                                        color: AppColors.of(
                                          context,
                                        ).primaryColor10,
                                      ),
                                      SizedBox(width: 20.w),
                                      Text(
                                        S.of(context).english,
                                        style: AppTextStyles.of(context)
                                            .regular24
                                            .copyWith(
                                              color: AppColors.of(
                                                context,
                                              ).neutralColor12,
                                            ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.change_circle_outlined,
                                        size: 30.w,
                                        color: AppColors.of(
                                          context,
                                        ).primaryColor10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // LogOut - Done
                          SizedBox(height: 20.h),
                          GestureDetector(
                            onTap: () async {
                              await AuthMethods().signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => Onboarding()),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Material(
                                borderRadius: BorderRadius.circular(18.w),
                                elevation: 3.0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 14.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.of(context).neutralColor1,
                                    borderRadius: BorderRadius.circular(18.w),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.logout_outlined,
                                        size: 30.w,
                                        color: AppColors.of(
                                          context,
                                        ).primaryColor10,
                                      ),
                                      SizedBox(width: 20.w),
                                      Text(
                                        S.of(context).logOut,
                                        style: AppTextStyles.of(context)
                                            .regular24
                                            .copyWith(
                                              color: AppColors.of(
                                                context,
                                              ).neutralColor12,
                                            ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 20.w,
                                        color: AppColors.of(
                                          context,
                                        ).primaryColor10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Delete user
                          SizedBox(height: 40.h),
                          // Phần này đã Ok nhưng số dư trong ví > 0 cũng sẽ bị mất
                          //=> chưa có hướng xử lí khi số dư > 0 nếu xóa sẽ mất luôn
                          // GestureDetector(
                          //   onTap: () async {
                          //     bool? confirmDel = await showDialog(
                          //       context: context,
                          //       builder: (context) {
                          //         return AlertDialog(
                          //           title: Text(
                          //             "Confirm delete account",
                          //             style: AppTextStyles.of(
                          //               context,
                          //             ).bold24.copyWith(color: Colors.red),
                          //           ),
                          //           actions: [
                          //             TextButton(
                          //               onPressed: () {
                          //                 Navigator.of(context).pop(false);
                          //               },
                          //               child: Text(
                          //                 "Cancel",
                          //                 style: AppTextStyles.of(context)
                          //                     .regular20
                          //                     .copyWith(
                          //                       color: AppColors.of(
                          //                         context,
                          //                       ).neutralColor12,
                          //                     ),
                          //               ),
                          //             ),

                          //             TextButton(
                          //               onPressed: () {
                          //                 Navigator.of(context).pop(true);
                          //               },
                          //               child: Text(
                          //                 "Agree",
                          //                 style: AppTextStyles.of(context)
                          //                     .regular20
                          //                     .copyWith(color: Colors.red),
                          //               ),
                          //             ),
                          //           ],
                          //         );
                          //       },
                          //     );

                          //     if (confirmDel == true) {
                          //       await AuthMethods().deleteUser();
                          //       await Future.delayed(
                          //         Duration(microseconds: 400),
                          //       );
                          //       Navigator.pushAndRemoveUntil(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (_) => Onboarding(),
                          //         ),
                          //         (route) => false,
                          //       );
                          //     }
                          //   },
                          //   child: Container(
                          //     margin: EdgeInsets.symmetric(horizontal: 20.w),
                          //     child: Material(
                          //       borderRadius: BorderRadius.circular(18.w),
                          //       elevation: 3.0,
                          //       child: Container(
                          //         width: MediaQuery.of(context).size.width,
                          //         padding: EdgeInsets.symmetric(
                          //           horizontal: 20.w,
                          //           vertical: 8.w,
                          //         ),
                          //         decoration: BoxDecoration(
                          //           color: Colors.red.shade500,
                          //           borderRadius: BorderRadius.circular(18.w),
                          //         ),
                          //         child: Row(
                          //           children: [
                          //             Icon(
                          //               Icons.delete_outlined,
                          //               size: 30.w,
                          //               color: Colors.white,
                          //             ),
                          //             SizedBox(width: 20.w),
                          //             Text(
                          //               "Delete account",
                          //               style: AppTextStyles.of(context)
                          //                   .regular24
                          //                   .copyWith(color: Colors.white),
                          //             ),
                          //             Spacer(),
                          //             Icon(
                          //               Icons.arrow_forward_ios_outlined,
                          //               size: 20.w,
                          //               color: Colors.white,
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
