import 'dart:io';
import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/services/cloudinary_services.dart';
import 'package:btl_food_delivery_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UpdateFood extends StatefulWidget {
  final String foodId;
  const UpdateFood({super.key, required this.foodId});

  @override
  State<UpdateFood> createState() => _UpdateFoodState();
}

class _UpdateFoodState extends State<UpdateFood> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController kcalController = TextEditingController();

  File? newImgFoodFile;
  String? oldImageFoodUrl;

  bool loading = false;
  bool isAvailable = true;

  List<Map<String, dynamic>> categories = [];
  Map<String, dynamic>? selectedCategory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFoodsData();
    loadCategories();
  }

  Future loadFoodsData() async {
    DocumentSnapshot snapshot = await DatabaseMethods().getFoodById(
      widget.foodId,
    );
    setState(() {
      nameController.text = snapshot["name"] ?? "";
      descriptionController.text = snapshot["description"] ?? "";
      oldImageFoodUrl = snapshot["image"] ?? "";
      isAvailable = snapshot["isAvailable"] ?? true;
      itemController.text = snapshot["item"] ?? "";
      kcalController.text = snapshot["kcal"] ?? "";
      priceController.text = snapshot["price"]?.toString() ?? "";

      String currentCategoryId = snapshot["categoryId"] ?? "";

      if (currentCategoryId.isNotEmpty) {
        for (var category in categories) {
          if (currentCategoryId == category["categoryId"]) {
            selectedCategory = category;
            break;
          }
        }
      }
    });
  }

  Future<void> loadCategories() async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection("categories")
          .get();

      List<Map<String, dynamic>> loadedCategories = query.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          "categoryId": doc.id,
          "categoryName": data["categoryName"] ?? "",
          "categoryImage": data["categoryImage"] ?? "",
        };
      }).toList();

      setState(() {
        categories = loadedCategories;
      });

      await loadFoodsData();
    } catch (e) {
      print("Lỗi tải categories từ Firebase: $e");
    }
  }

  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        newImgFoodFile = File(picked.path);
        oldImageFoodUrl = null; // Bỏ ảnh cũ
      });
    }
  }

  Future updateFood() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin sản phẩm")),
      );
      return;
    }

    setState(() => loading = true);

    String imageFoodUrl = "";

    // Upload ảnh mới lên Cloudinary
    if (newImgFoodFile != null) {
      final uploadUrl = await CloudinaryServices.uploadImage(newImgFoodFile!);

      if (uploadUrl == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Upload ảnh thất bại")));
        setState(() => loading = false);
        return;
      }

      imageFoodUrl = uploadUrl;
    } else {
      imageFoodUrl = oldImageFoodUrl ?? "";
    }

    String searchKey = nameController.text.trim().toLowerCase();

    // Luu vao Firestore
    Map<String, dynamic> updateMap = {
      "name": nameController.text.trim(),
      "image": imageFoodUrl,
      "price": double.parse(priceController.text.trim()),
      "categoryId": selectedCategory!["categoryId"],
      "description": descriptionController.text.trim(),
      "item": itemController.text.trim(),
      "kcal": kcalController.text.trim(),
      "isAvailable": isAvailable,
      "searchKey": searchKey,
    };

    await DatabaseMethods().updateFood(updateMap, widget.foodId);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Cập nhật sản phẩm thành công")));

    setState(() => loading = false);
    Navigator.pop(context);
  }

  void showCategories() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Chọn danh mục",
            style: AppTextStyles.of(
              context,
            ).bold24.copyWith(color: AppColors.of(context).primaryColor10),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  leading: category["categoryImage"] != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                            category["categoryImage"],
                          ),
                        )
                      : CircleAvatar(child: Icon(Icons.category)),
                  title: Text(
                    category["categoryName"] ?? "NULL",
                    style: AppTextStyles.of(context).regular24.copyWith(
                      color: AppColors.of(context).neutralColor12,
                    ),
                  ),
                  trailing:
                      selectedCategory?["categoryId"] == category["categoryId"]
                      ? Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Đóng",
                style: AppTextStyles.of(context).regular24.copyWith(
                  color: AppColors.of(context).neutralColor10,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// AppBar
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    SizedBox(width: 54.w),
                    Text(
                      "Cập nhật sản phẩm",
                      style: AppTextStyles.of(context).bold32.copyWith(
                        color: AppColors.of(context).neutralColor12,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 6.h),
                buildTextField(
                  controller: nameController,
                  label: "Tên sản phẩm",
                  hintText: "Bánh mì...",
                ),

                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 120.h,
                        width: 120.w,
                        margin: EdgeInsets.only(right: 10.w, top: 36.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.of(context).primaryColor8,
                            width: 1.w,
                          ),
                        ),
                        child: newImgFoodFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  newImgFoodFile!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : (oldImageFoodUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        oldImageFoodUrl!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Center(child: CircularProgressIndicator())),
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: [
                          buildTextField(
                            controller: priceController,
                            label: "Giá sản phẩm",
                            hintText: "Nhập giá",
                          ),
                          SizedBox(height: 2.h),
                          buildTextField(
                            controller: kcalController,
                            label: "Calories",
                            hintText: "Nhập calories (kcal)",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Chọn danh mục
                Text(
                  "Danh mục",
                  style: AppTextStyles.of(context).regular24.copyWith(
                    color: AppColors.of(context).neutralColor12,
                  ),
                ),
                GestureDetector(
                  onTap: showCategories,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.of(context).neutralColor5,
                      borderRadius: BorderRadius.circular(10.w),
                      border: Border.all(
                        color: AppColors.of(context).primaryColor8,
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: selectedCategory != null
                              ? Row(
                                  children: [
                                    if (selectedCategory!["categoryImage"] !=
                                        null)
                                      CircleAvatar(
                                        radius: 18.w,
                                        backgroundImage: NetworkImage(
                                          selectedCategory!["categoryImage"],
                                        ),
                                      )
                                    else
                                      CircleAvatar(
                                        radius: 18.w,
                                        child: Icon(Icons.category, size: 15.w),
                                      ),

                                    SizedBox(width: 10.w),
                                    Text(
                                      selectedCategory!["categoryName"] ??
                                          "NULL",
                                      style: AppTextStyles.of(context).regular24
                                          .copyWith(
                                            color: AppColors.of(
                                              context,
                                            ).neutralColor11,
                                          ),
                                    ),
                                  ],
                                )
                              : Text("Chọn danh mục"),
                        ),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),

                // item
                SizedBox(height: 10.h),
                buildTextField(
                  controller: itemController,
                  label: "Thành phần",
                  hintText: "Bánh mì, dưa chuột,...",
                ),

                // MÔ TẢ
                SizedBox(height: 10.h),
                buildDescriptionField(),

                SizedBox(height: 12.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).neutralColor5,
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sản phẩm còn hàng",
                        style: AppTextStyles.of(context).regular24.copyWith(
                          color: AppColors.of(context).neutralColor12,
                        ),
                      ),
                      Switch(
                        value: isAvailable,
                        onChanged: (value) {
                          setState(() {
                            isAvailable = value;
                          });
                        },
                        activeTrackColor: AppColors.of(context).primaryColor9,
                        inactiveTrackColor: AppColors.of(context).neutralColor8,
                        inactiveThumbColor: AppColors.of(context).neutralColor9,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.w),

                // Nút Thêm
                loading
                    ? Center(child: CircularProgressIndicator())
                    : GestureDetector(
                        onTap: () => updateFood(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.w),
                            color: AppColors.of(context).primaryColor10,
                          ),
                          child: Center(
                            child: Text(
                              "Cập nhật",
                              style: AppTextStyles.of(context).bold32.copyWith(
                                color: AppColors.of(context).neutralColor4,
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.of(
            context,
          ).regular24.copyWith(color: AppColors.of(context).neutralColor12),
        ),
        Container(
          padding: EdgeInsets.only(left: 10.w),
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 50.h),
          decoration: BoxDecoration(
            color: AppColors.of(context).neutralColor5,
            borderRadius: BorderRadius.circular(10.w),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppTextStyles.of(
              context,
            ).regular24.copyWith(color: AppColors.of(context).neutralColor12),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: AppTextStyles.of(
                context,
              ).regular20.copyWith(color: AppColors.of(context).neutralColor11),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Mô tả",
          style: AppTextStyles.of(
            context,
          ).regular24.copyWith(color: AppColors.of(context).neutralColor12),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          constraints: BoxConstraints(minHeight: 20.h),
          decoration: BoxDecoration(
            color: AppColors.of(context).neutralColor5,
            borderRadius: BorderRadius.circular(10.w),
          ),
          child: TextField(
            controller: descriptionController,
            maxLines: 4,
            style: AppTextStyles.of(
              context,
            ).regular20.copyWith(color: AppColors.of(context).neutralColor12),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Nhập mô tả chi tiết sản phẩm",
              hintStyle: AppTextStyles.of(
                context,
              ).regular20.copyWith(color: AppColors.of(context).neutralColor11),
            ),
          ),
        ),
      ],
    );
  }
}
