import 'dart:io';

import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/services/cloudinary_services.dart';
import 'package:btl_food_delivery_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UpdateCategory extends StatefulWidget {
  final String categoryId;
  const UpdateCategory({super.key, required this.categoryId});

  @override
  State<UpdateCategory> createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
  TextEditingController nameController = TextEditingController();

  File? newImageFile;
  String? oldImageUrl;

  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCategoryData();
  }

  Future loadCategoryData() async {
    DocumentSnapshot snapshot = await DatabaseMethods().getCategoryById(
      widget.categoryId,
    );

    setState(() {
      nameController.text = snapshot["categoryName"];
      oldImageUrl = snapshot["categoryImage"];
    });
  }

  // Chon anh moi
  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        newImageFile = File(picked.path);
        oldImageUrl = null; // Bỏ ảnh cũ
      });
    }
  }

  // Cap nhat
  Future updateCategory() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Tên danh mục không để trống")));
      return;
    }

    setState(() => loading = true);

    String imageUrl = "";

    // Up anh moi len cloudinary
    if (newImageFile != null) {
      final uploadUrl = await CloudinaryServices.uploadImage(newImageFile!);

      if (uploadUrl == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Upload anh that bai")));
        setState(() => loading = false);
        return;
      }

      imageUrl = uploadUrl;
    } else {
      imageUrl = oldImageUrl ?? ""; // Neu up that bai tra lai anh cu
    }

    Map<String, dynamic> updateMap = {
      "categoryName": nameController.text.trim(),
      "categoryImage": imageUrl,
    };

    await DatabaseMethods().updateCategory(updateMap, widget.categoryId);

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
                    SizedBox(width: 52.w),
                    Text(
                      "Cập nhật danh mục",
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
                      child: newImageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                newImageFile!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : (oldImageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      oldImageUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(child: CircularProgressIndicator())),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                /// Nút Thêm
                GestureDetector(
                  onTap: () => updateCategory(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.w),
                      color: AppColors.of(context).primaryColor10,
                    ),
                    child: Center(
                      child: Text(
                        "Cập nhật",
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
