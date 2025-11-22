import 'package:btl_food_delivery_app/admin/Function/add_new_category.dart';
import 'package:btl_food_delivery_app/admin/Function/update_category.dart';
import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageCategories extends StatefulWidget {
  const ManageCategories({super.key});
  @override
  State<ManageCategories> createState() => _ManageCategoriesState();
}

class _ManageCategoriesState extends State<ManageCategories> {
  Stream? categoryStream;

  getOnTheLoad() async {
    categoryStream = await DatabaseMethods().getAllCategories();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getOnTheLoad();
    super.initState();
  }

  Widget allCategories() {
    return StreamBuilder(
      stream: categoryStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 70.h,
                      decoration: BoxDecoration(
                        color: AppColors.of(context).neutralColor1,
                        borderRadius: BorderRadius.circular(18.w),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Image.network(
                              ds["categoryImage"],
                              width: 50.w,
                              height: 50.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            ds["categoryName"],
                            style: AppTextStyles.of(context).bold24.copyWith(
                              color: AppColors.of(context).neutralColor12,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UpdateCategory(categoryId: ds["categoryId"]),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.all(14.w),
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              decoration: BoxDecoration(
                                color: AppColors.of(context).neutralColor6,
                                borderRadius: BorderRadius.circular(12.w),
                              ),
                              child: Center(
                                child: Text(
                                  "Cập nhật",
                                  style: AppTextStyles.of(context).bold20
                                      .copyWith(
                                        color: AppColors.of(
                                          context,
                                        ).neutralColor12,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              DatabaseMethods().deleteCategory(
                                ds["categoryId"],
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 15.w,
                                bottom: 15.w,
                                right: 10.w,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12.w),
                              ),
                              child: Center(
                                child: Text(
                                  "Xóa",
                                  style: AppTextStyles.of(
                                    context,
                                  ).bold20.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Appbar
          Padding(
            padding: EdgeInsets.only(top: 45.h, left: 12.w, right: 12.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.of(context).primaryColor9,
                      borderRadius: BorderRadius.circular(50.w),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.of(context).neutralColor1,
                    ),
                  ),
                ),
                SizedBox(width: 80.w),
                Text(
                  "Categories",
                  style: AppTextStyles.of(context).bold32.copyWith(
                    color: AppColors.of(context).neutralColor12,
                  ),
                ),
              ],
            ),
          ),

          // Display list
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.of(context).neutralColor7,
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: allCategories(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.w),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddNewCategory()),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 1.6,
              padding: EdgeInsets.symmetric(vertical: 4.w),
              decoration: BoxDecoration(
                color: AppColors.of(context).primaryColor10,
                borderRadius: BorderRadius.circular(16.w),
              ),
              child: Center(
                child: Text(
                  "Thêm mới",
                  style: AppTextStyles.of(
                    context,
                  ).bold32.copyWith(color: AppColors.of(context).neutralColor1),
                ),
              ),
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
