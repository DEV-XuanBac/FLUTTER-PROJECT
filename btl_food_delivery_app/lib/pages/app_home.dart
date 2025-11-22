import 'dart:async';
import 'package:btl_food_delivery_app/components/food_tile.dart';
import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/model/category_model.dart';
import 'package:btl_food_delivery_app/model/food_model.dart';
import 'package:btl_food_delivery_app/services/database.dart';
import 'package:btl_food_delivery_app/services/shared_pref.dart';
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
  List<FoodModel> allFoods = [];
  List<FoodModel> displayFoods = [];
  String isCategorySelected = "0"; // => hiển thị all food
  bool isLoading = true;
  bool isSearching = false;
  String? imageUrl;

  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();

  StreamSubscription? _categoriesSub;
  StreamSubscription? _foodsSub;

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadFoods();
    loadUserImage();

    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        performSearch();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchNode.dispose();
    _categoriesSub?.cancel();
    _foodsSub?.cancel();
    super.dispose();
  }

  Future<void> loadUserImage() async {
    try {
      String? userImg = await SharedPref().getUserImage();
      if (mounted) {
        setState(() {
          imageUrl = userImg;
        });
      }
    } catch (e) {
      print("Lỗi load ảnht: $e");
    }
  }

  Future<void> loadCategories() async {
    try {
      final stream = await DatabaseMethods().getAllCategories();
      _categoriesSub = stream.listen((QuerySnapshot snapshot) {
        List<CategoryModel> loadedCategories = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return CategoryModel(
            categoryId: doc.id,
            categoryName: data["categoryName"] ?? "",
            categoryImage: data["categoryImage"] ?? "",
          );
        }).toList();

        if (mounted) {
          setState(() {
            categories = loadedCategories;
          });
        }
      });
    } catch (e) {
      print("Lỗi tải categories: $e");
    }
  }

  Future<void> loadFoods() async {
    try {
      final stream = await DatabaseMethods().getListFood();
      _foodsSub = stream.listen((QuerySnapshot snapshot) {
        List<FoodModel> loadedFoods = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return FoodModel(
            id: doc.id,
            name: data["name"] ?? "",
            image: data["image"] ?? "",
            price: (data["price"] as num?)?.toDouble() ?? 0.0,
            categoryId: data["categoryId"] ?? "",
            description: data["description"] ?? "",
            item: data["item"] ?? "",
            kcal: data["kcal"] ?? "",
            isAvailable: data["isAvailable"] ?? true,
            searchKey: data["searchKey"] ?? "",
          );
        }).toList();

        loadedFoods = loadedFoods
            .where((food) => food.isAvailable == true)
            .toList();

        if (mounted) {
          setState(() {
            allFoods = loadedFoods;
            displayFoods = loadedFoods; // Default hiển thị all
            isLoading = false;
          });
        }
      });
    } catch (e) {
      print("Lỗi tải dữ liệu sản phẩm: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void applySearch() {
    List<FoodModel> currentList = (isCategorySelected == "0")
        ? allFoods
        : allFoods
              .where((food) => food.categoryId == isCategorySelected)
              .toList();
    if (searchController.text.isEmpty) {
      setState(() {
        displayFoods = currentList;
        isSearching = false;
      });
    } else {
      setState(() {
        displayFoods = currentList.where((food) {
          return food.name!.toLowerCase().contains(
                searchController.text.toLowerCase(),
              ) ||
              (food.searchKey?.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  ) ??
                  false);
        }).toList();
        isSearching = true;
      });
    }
  }

  void filterByCategories(String categoryId) {
    setState(() {
      isCategorySelected = categoryId;
      if (categoryId == "0") {
        displayFoods = allFoods;
      } else {
        displayFoods = allFoods.where((food) {
          return food.categoryId == categoryId;
        }).toList();
      }

      if (searchController.text.isNotEmpty) {
        applySearch();
      }
    });
  }

  void performSearch() {
    applySearch();
    setState(() {
      isSearching = searchController.text.isNotEmpty;
    });
  }

  void clearSearch() {
    searchController.clear();
    searchNode.unfocus();
    setState(() {
      isSearching = false;
    });
    filterByCategories(isCategorySelected);
  }

  void onSearchSubmit(String value) {
    performSearch();
  }

  @override
  Widget build(BuildContext context) {
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
                    border: Border.all(
                      color: isSearching
                          ? AppColors.of(context).primaryColor9
                          : AppColors.of(context).neutralColor8,
                      width: 1.w,
                    ),
                  ),
                  child: TextField(
                    controller: searchController,
                    focusNode: searchNode,
                    onSubmitted: onSearchSubmit,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Tìm kiếm món ăn...",
                      hintStyle: AppTextStyles.of(context).regular20.copyWith(
                        color: AppColors.of(context).neutralColor9,
                      ),
                    ),
                    style: AppTextStyles.of(context).regular20.copyWith(
                      color: AppColors.of(context).neutralColor11,
                    ),
                  ),
                ),
              ),

              // Button search
              GestureDetector(
                onTap: () {
                  FocusScope.of(
                    context,
                  ).unfocus(); // Ẩn bàn phím khi ấn nút tìm kiếm
                  performSearch();
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10.w),
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).primaryColor9,
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: Icon(
                    Icons.search,
                    size: 30.w,
                    color: AppColors.of(context).neutralColor1,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // Category section
          Container(
            height: 45.h,
            margin: EdgeInsets.only(left: 10.w),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return CategoryTile(
                    categoryName: "Tất cả",
                    icon: Icons.all_inclusive,
                    categoryId: "0",
                    isSelected: isCategorySelected == "0",
                    onTap: filterByCategories,
                  ); // default
                } else {
                  final category = categories[index - 1];
                  return CategoryTile(
                    categoryName: category.categoryName!,
                    imageUrl: category.categoryImage,
                    categoryId: category.categoryId!,
                    isSelected: isCategorySelected == category.categoryId,
                    onTap: filterByCategories,
                  );
                }
              },
            ),
          ),

          if (isSearching && searchController.text.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.of(context).primaryColor4,
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Kết quả tìm kiếm cho '${searchController.text}' (${displayFoods.length} kết quả)",
                    style: AppTextStyles.of(context).regular16.copyWith(
                      color: AppColors.of(context).neutralColor11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  GestureDetector(
                    onTap: clearSearch,
                    child: Icon(
                      Icons.close_rounded,
                      size: 24.w,
                      color: AppColors.of(context).primaryColor11,
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: 10.h),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : (displayFoods.isEmpty ? buildEmptyState() : buildFoodGrid()),
          ),
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
          SizedBox(width: 10.w),
          Flexible(
            child: Text(
              "Hôm nay bạn muốn ăn gì?",
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.of(
                context,
              ).bold24.copyWith(color: AppColors.of(context).neutralColor11),
            ),
          ),
        ],
      ),
      actions: [
        Container(
          padding: EdgeInsets.all(4.w),
          margin: EdgeInsets.only(right: 10.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.of(context).primaryColor9,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(50.w),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.w),
            child: (imageUrl != null && imageUrl!.isNotEmpty)
                ? Image.network(
                    imageUrl!,
                    height: 48.w,
                    width: 48.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/profilez.png",
                        height: 48.w,
                        width: 48.w,
                        fit: BoxFit.cover,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.of(context).primaryColor10,
                        ),
                      );
                    },
                  )
                : Image.asset(
                    "assets/profilez.png",
                    height: 48.w,
                    width: 48.w,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ],
    );
  }

  Widget CategoryTile({
    required String categoryName,
    required String categoryId,
    String? imageUrl,
    IconData? icon,
    required bool isSelected,
    required Function(String) onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(categoryId),
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.of(context).primaryColor9
              : AppColors.of(context).neutralColor6,
          borderRadius: BorderRadius.circular(12.w),
          border: Border.all(
            color: isSelected
                ? AppColors.of(context).primaryColor9
                : AppColors.of(context).neutralColor8,
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 20.w,
                color: isSelected
                    ? AppColors.of(context).neutralColor1
                    : AppColors.of(context).neutralColor12,
              )
            else if (imageUrl != null)
              Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Icon(
                Icons.category,
                size: 20.w,
                color: isSelected
                    ? AppColors.of(context).neutralColor1
                    : AppColors.of(context).neutralColor12,
              ),
            SizedBox(width: 10.w),
            Text(
              categoryName,
              style: isSelected
                  ? AppTextStyles.of(context).bold20.copyWith(
                      color: AppColors.of(context).neutralColor1,
                    )
                  : AppTextStyles.of(context).regular20.copyWith(
                      color: AppColors.of(context).neutralColor12,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fastfood_outlined,
            size: 80.w,
            color: AppColors.of(context).neutralColor9,
          ),
          SizedBox(height: 12.h),
          Text(
            searchController.text.isNotEmpty
                ? "Không tìm thấy sản phẩm phù hợp"
                : "Không có sản phẩm trong danh mục này",
            style: AppTextStyles.of(
              context,
            ).bold24.copyWith(color: AppColors.of(context).neutralColor11),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          Text(
            isSearching
                ? "Hãy tìm kiếm với sản phẩm khác"
                : "Vui lòng chọn danh mục khác",
            style: AppTextStyles.of(
              context,
            ).regular24.copyWith(color: AppColors.of(context).neutralColor10),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          if (isSearching || searchController.text.isNotEmpty)
            ElevatedButton(
              onPressed: clearSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.of(context).primaryColor9,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.w),
                ),
              ),
              child: Text(
                "Xóa tìm kiếm",
                style: AppTextStyles.of(context).regular20.copyWith(
                  color: AppColors.of(context).neutralColor1,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildFoodGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          mainAxisSpacing: 15.w,
          crossAxisSpacing: 15.w,
        ),
        itemCount: displayFoods.length,
        itemBuilder: (context, index) {
          final food = displayFoods[index];
          return FoodTile(food: food);
        },
      ),
    );
  }
}
