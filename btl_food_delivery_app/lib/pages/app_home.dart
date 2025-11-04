import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/l10n/l10n.dart';
import 'package:btl_food_delivery_app/model/category_model.dart';
import 'package:btl_food_delivery_app/model/fastfood_model.dart';
import 'package:btl_food_delivery_app/model/happyfood_model.dart';
import 'package:btl_food_delivery_app/pages/detail_page.dart';
import 'package:btl_food_delivery_app/services/category_data.dart';
import 'package:btl_food_delivery_app/services/database.dart';
import 'package:btl_food_delivery_app/services/fastfood_data.dart';
import 'package:btl_food_delivery_app/services/happyfood_data.dart';
import 'package:btl_food_delivery_app/services/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});
  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  List<CategoryModel> categories = [];
  List<FastfoodModel> foods = [];
  List<HappyfoodModel> happys = [];
  String track = "0";
  bool search = false;

  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    foods = getFastFood();
    happys = getHappyFood();
    super.initState();
  }

  var queryResult = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResult = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });

    var textSearch = value.subString(0, 1).toUpperCase() + value.subString(1);
    if (queryResult.isEmpty && value.length == 1) {
      DatabaseMethods().search(value).then((QuerySnapshot snapshot) {
        for (int i = 0; i < snapshot.docs.length; i++) {
          queryResult.add(snapshot.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResult.forEach((element) {
        if (element['name'].startsWith(textSearch)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    categories = getCategories(context);
    return Scaffold(
      appBar: appBar(),
      backgroundColor: AppColors.of(context).primaryColor2,
      body: Column(
        children: [
          Row(
            children: [
              // Tìm kiếm Fields
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 20.w,
                  ),
                  padding: EdgeInsets.only(left: 10.w),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).neutralColor6,
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                  child: TextField(
                    controller: searchController,
                    // onChanged: (value) {
                    //   initiateSearch(value.toUpperCase());
                    // },
                    // tạo bảng food xong làm tiếp
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: S.of(context).searchFoodItem,
                      hintStyle: AppTextStyles.of(context).regular20.copyWith(
                        color: AppColors.of(context).neutralColor9,
                      ),
                    ),
                  ),
                ),
              ),

              // Button search
              Container(
                margin: EdgeInsets.only(right: 10.w),
                padding: EdgeInsets.all(9.w),
                decoration: BoxDecoration(
                  color: AppColors.of(context).primaryColor9,
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: Icon(Icons.search, color: Colors.white),
              ),
            ],
          ),

          SizedBox(height: 10.h),
          // Category
          Container(
            height: 45.h,
            margin: EdgeInsets.only(left: 10.w),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return CategoryTile(
                  categories[index].name!,
                  categories[index].image!,
                  index.toString(),
                );
              },
            ),
          ),

          SizedBox(height: 10.h),
          track == "0"
              ? Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(10.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.74,
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 10.0,
                    ),
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      return FoodTile(
                        foods[index].name!,
                        foods[index].image!,
                        foods[index].price!,
                      );
                    },
                  ),
                )
              : track == "1"
              ? Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(10.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.74,
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 10.0,
                    ),
                    itemCount: happys.length,
                    itemBuilder: (context, index) {
                      return FoodTile(
                        happys[index].name!,
                        happys[index].image!,
                        happys[index].price!,
                      );
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: AppColors.of(context).primaryColor2,
      centerTitle: true,
      toolbarHeight: 60.h,
      automaticallyImplyLeading: false, // Tắt nút back default
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/logo.png", width: 70.w, fit: BoxFit.contain),
          SizedBox(width: 15.w),
          Icon(Icons.location_on_outlined, size: 20.w, color: Colors.red),
          SizedBox(width: 5.w),
          Flexible(
            child: Text(
              "Hà Nội, Việt Nam",
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.of(
                context,
              ).bold24.copyWith(color: AppColors.of(context).neutralColor11),
            ),
          ),
          SizedBox(width: 5.w),
          Icon(
            Icons.keyboard_arrow_down_outlined,
            size: 20.w,
            color: Colors.grey,
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.w),
            child: Container(
              padding: EdgeInsets.all(6.w),
              child: Image.asset(
                "assets/profilez.png",
                height: 40.w,
                width: 40.w,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget CategoryTile(String name, String image, String categoryIdx) {
    return GestureDetector(
      onTap: () {
        track = categoryIdx.toString();
        setState(() {});
      },
      child: track == categoryIdx
          ? Container(
              margin: EdgeInsets.only(right: 20.w),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(20.w),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).primaryColor9,
                    borderRadius: BorderRadius.circular(18.w),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        image,
                        height: 35.w,
                        width: 35.w,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 10.w),
                      Text(name, style: AppWidget.whiteTextFieldStyle(context)),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              margin: EdgeInsets.only(right: 20.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: AppColors.of(context).neutralColor8,
                borderRadius: BorderRadius.circular(18.w),
              ),
              child: Row(
                children: [
                  Image.asset(
                    image,
                    height: 35.w,
                    width: 35.w,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10.w),
                  Text(name, style: AppWidget.blackTextFieldStyle(context)),
                ],
              ),
            ),
    );
  }

  Widget FoodTile(String name, String image, String price) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.of(context).neutralColor9),
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 100.w, width: 100.w, fit: BoxFit.contain),
          Text(
            name,
            style: AppTextStyles.of(
              context,
            ).bold32.copyWith(color: AppColors.of(context).neutralColor12),
          ),
          Text(
            "\$ $price",
            style: AppTextStyles.of(
              context,
            ).bold24.copyWith(color: AppColors.of(context).primaryColor10),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailPage(image: image, name: name, price: price),
                    ),
                  );
                },
                child: Container(
                  height: 42.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    color: AppColors.of(context).primaryColor10,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.w),
                      topLeft: Radius.circular(20.w),
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 24.sp,
                    color: AppColors.of(context).neutralColor1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
