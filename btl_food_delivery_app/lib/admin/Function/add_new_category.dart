import 'dart:io';

import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/services/cloudinary_services.dart';
import 'package:btl_food_delivery_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddNewCategory extends StatefulWidget {
  const AddNewCategory({super.key});

  @override
  State<AddNewCategory> createState() => _AddNewCategoryState();
}

class _AddNewCategoryState extends State<AddNewCategory> {
  TextEditingController nameController = TextEditingController();
  File? imageFile;
  bool loading = false;

  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  Future saveCategories() async {
    if (nameController.text.isEmpty || imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập đầy đủ tên và chọn ảnh")),
      );
      return;
    }

    setState(() => loading = true);

    // Upload anh len cloudinary
    String? imageUrl = await CloudinaryServices.uploadImage(imageFile!);

    if (imageUrl == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload ảnh thất bại")));
      setState(() => loading = false);
      return;
    }

    String categoryId = DateTime.now().millisecondsSinceEpoch.toString();

    // Luu vao Firestore
    Map<String, dynamic> categoryMap = {
      "categoryName": nameController.text.trim(),
      "categoryImage": imageUrl,
      "categoryId": categoryId,
    };

    await DatabaseMethods().addCategory(categoryMap, categoryId);

    setState(() => loading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.w),
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
                    SizedBox(width: 62.w),
                    Text(
                      "Thêm danh mục",
                      style: AppTextStyles.of(context).bold32.copyWith(
                        color: AppColors.of(context).neutralColor12,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 40.h),
                TextField(
                  controller: nameController,
                  style: AppTextStyles.of(context).bold24.copyWith(
                    color: AppColors.of(context).neutralColor12,
                  ),
                  decoration: InputDecoration(
                    hintText: "Tên danh mục",
                    hintStyle: AppTextStyles.of(context).regular24.copyWith(
                      color: AppColors.of(context).neutralColor9,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 20.h),

                Center(
                  child: GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: 300.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: imageFile == null
                          ? Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/imagePick.png",
                                    width: 20.w,
                                    height: 20.w,
                                    color: AppColors.of(context).neutralColor10,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "Chọn ảnh",
                                    style: AppTextStyles.of(context).regular24
                                        .copyWith(
                                          color: AppColors.of(
                                            context,
                                          ).neutralColor10,
                                        ),
                                  ),
                                ],
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(imageFile!, fit: BoxFit.cover),
                            ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                /// Nút Thêm
                GestureDetector(
                  onTap: () => saveCategories(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.w),
                      color: AppColors.of(context).primaryColor10,
                    ),
                    child: Center(
                      child: Text(
                        "Thêm danh mục",
                        style: AppTextStyles.of(context).bold32.copyWith(
                          color: AppColors.of(context).neutralColor1,
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
}
