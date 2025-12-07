import 'dart:io';

import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/pages/onboarding.dart';
import 'package:btl_food_delivery_app/services/auth_methods.dart';
import 'package:btl_food_delivery_app/services/cloudinary_services.dart';
import 'package:btl_food_delivery_app/services/database.dart';
import 'package:btl_food_delivery_app/services/shared_pref.dart';
import 'package:btl_food_delivery_app/components/widget_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? email, name, imageUrl, phone, address;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isEditName = false;
  bool isEditPhone = false;
  bool isEditAddress = false;
  bool isLoading = false;
  bool initialLoading = true; // initial shared prefs load
  File? imageFile;

  getTheSharedPref() async {
    try {
      name = await SharedPref().getUsername();
      email = await SharedPref().getUserEmail();
      imageUrl = await SharedPref().getUserImage();
      phone = await SharedPref().getUserPhone();
      address = await SharedPref().getUserAddress();

      nameController.text = name ?? "";
      phoneController.text = phone ?? "";
      addressController.text = address ?? "";
    } catch (e) {
      print("Error loading: $e");
    } finally {
      setState(() {
        initialLoading = false;
      });
    }
  }

  @override
  void initState() {
    getTheSharedPref();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        isLoading = true;
      });

      try {
        String? uploadUrl = await CloudinaryServices.uploadImage(imageFile!);

        if (uploadUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Lỗi tải ảnh lên Cloudinary",
                style: AppTextStyles.of(
                  context,
                ).regular20.copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        await SharedPref().saveUserImage(uploadUrl);

        String userId = await SharedPref().getUserId() ?? "";
        if (userId.isNotEmpty) {
          await DatabaseMethods().updateUserProfileImg(userId, uploadUrl);
        }

        setState(() {
          imageUrl = uploadUrl;
          imageFile = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Cập nhật ảnh đại diện thành công",
              style: AppTextStyles.of(
                context,
              ).regular20.copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Lỗi khi tải ảnh lên: $e',
              style: AppTextStyles.of(
                context,
              ).regular20.copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> updateName() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không để trống họ tên',
            style: AppTextStyles.of(
              context,
            ).regular20.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String newName = nameController.text.trim();

      await SharedPref().saveUserName(newName);

      String userId = await SharedPref().getUserId() ?? "";
      if (userId.isNotEmpty) {
        await DatabaseMethods().updateUserName(userId, newName);
      }

      setState(() {
        name = newName;
        isEditName = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Đã cập nhật tên người dùng",
            style: AppTextStyles.of(
              context,
            ).regular20.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lỗi khi cập nhật: $e',
            style: AppTextStyles.of(
              context,
            ).regular20.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updatePhone() async {
    if (phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không để trống số điện thoại',
            style: AppTextStyles.of(
              context,
            ).regular20.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String newPhone = phoneController.text.trim();
      await SharedPref().saveUserPhone(newPhone);
      String userId = await SharedPref().getUserId() ?? "";
      if (userId.isNotEmpty) {
        await DatabaseMethods().updateUserPhone(userId, newPhone);
      }

      setState(() {
        phone = newPhone;
        isEditPhone = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Đã cập nhật số điện thoại",
            style: AppTextStyles.of(
              context,
            ).regular20.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lỗi khi cập nhật lên: $e',
            style: AppTextStyles.of(
              context,
            ).regular20.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateAddress() async {
    if (addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không để trống địa chỉ',
            style: AppTextStyles.of(
              context,
            ).regular20.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String newAddress = addressController.text.trim();
      await SharedPref().saveUserAddress(newAddress);
      String userId = await SharedPref().getUserId() ?? "";
      if (userId.isNotEmpty) {
        await DatabaseMethods().updateUserAddress(userId, newAddress);
      }

      setState(() {
        address = newAddress;
        isEditAddress = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Cập nhật địa chỉ thành công",
            style: AppTextStyles.of(
              context,
            ).regular20.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lỗi khi cập nhật lên: $e',
            style: AppTextStyles.of(
              context,
            ).regular20.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleTheme() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tính năng đang được phát triển'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (initialLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.of(context).primaryColor10,
          ),
        ),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: Center(
              child: Text(
                "Hồ sơ cá nhân",
                style: AppWidget.HeadlineTextFieldStyle(context),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.of(context).neutralColor8,
                      AppColors.of(context).neutralColor1,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.w),
                    topRight: Radius.circular(20.w),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: pickImage,
                      child: Stack(
                        children: [
                          Container(
                            width: 110.w,
                            height: 110.w,
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70.w),
                              border: Border.all(
                                color: AppColors.of(context).primaryColor10,
                                width: 1.w,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.w),
                              child: buildProfileImage(),
                            ),
                          ),

                          if (isLoading)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.of(context).neutralColor9,
                                  borderRadius: BorderRadius.circular(70.w),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.of(context).primaryColor10,
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 0,
                            right: 2,
                            child: Container(
                              padding: EdgeInsets.all(5.w),
                              decoration: BoxDecoration(
                                color: AppColors.of(context).neutralColor10,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: AppColors.of(context).neutralColor1,
                                size: 16.w,
                              ),
                            ),
                          ),
                        ],
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
                                color: AppColors.of(context).primaryColor10,
                              ),
                              SizedBox(width: 20.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email:",
                                    style: AppTextStyles.of(context).bold20
                                        .copyWith(
                                          color: AppColors.of(
                                            context,
                                          ).neutralColor10,
                                        ),
                                  ),
                                  Text(
                                    email ?? "Email trống",
                                    style: AppTextStyles.of(context).regular24
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

                    //Name
                    SizedBox(height: 15.h),
                    buildNameSection(context),

                    //Address
                    SizedBox(height: 15.h),
                    buildAddressSection(context),

                    //Phone
                    SizedBox(height: 15.h),
                    buildPhoneSection(context),

                    // Mode sáng tối
                    SizedBox(height: 15.h),
                    GestureDetector(
                      onTap: toggleTheme,
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
                                  Icons.brightness_6_outlined,
                                  size: 30.w,
                                  color: AppColors.of(context).primaryColor10,
                                ),
                                SizedBox(width: 20.w),
                                Text(
                                  "Chế độ sáng/tối",
                                  style: AppTextStyles.of(context).regular24
                                      .copyWith(
                                        color: AppColors.of(
                                          context,
                                        ).neutralColor12,
                                      ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.toggle_on_outlined,
                                  size: 30.w,
                                  color: AppColors.of(context).primaryColor10,
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
                                  color: AppColors.of(context).primaryColor10,
                                ),
                                SizedBox(width: 20.w),
                                Text(
                                  "Đăng xuất",
                                  style: AppTextStyles.of(context).regular24
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
                                  color: AppColors.of(context).primaryColor10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildProfileImage() {
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        width: 100.w,
        height: 100.w,
        fit: BoxFit.cover,
      );
    } else if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        width: 100.w,
        height: 100.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/profile.png",
            width: 100.w,
            height: 100.w,
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
      );
    } else {
      return Image.asset(
        "assets/profile.png",
        width: 100.w,
        height: 100.w,
        fit: BoxFit.cover,
      );
    }
  }

  Widget buildNameSection(BuildContext context) {
    return Container(
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
                color: AppColors.of(context).primaryColor10,
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: isEditName
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 6.w),
                        height: 52.w,
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor6,
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                        child: TextFormField(
                          controller: nameController,
                          style: AppTextStyles.of(context).regular24.copyWith(
                            color: AppColors.of(context).neutralColor12,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Nhập tên của bạn",
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Họ tên:",
                            style: AppTextStyles.of(context).bold20.copyWith(
                              color: AppColors.of(context).neutralColor10,
                            ),
                          ),
                          Text(
                            name ?? "Chưa có tên",
                            style: AppTextStyles.of(context).regular24.copyWith(
                              color: AppColors.of(context).neutralColor12,
                            ),
                          ),
                        ],
                      ),
              ),

              if (!isEditName)
                IconButton(
                  onPressed: () {
                    setState(() {
                      isEditName = true;
                    });
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 24.w,
                    color: AppColors.of(context).primaryColor10,
                  ),
                ),
              if (isEditName)
                Row(
                  children: [
                    IconButton(
                      onPressed: updateName,
                      icon: Icon(Icons.check, size: 24.w, color: Colors.green),
                    ),

                    IconButton(
                      onPressed: () {
                        setState(() {
                          isEditName = false;
                          nameController.text = name ?? "";
                        });
                      },
                      icon: Icon(Icons.close, size: 24.w, color: Colors.red),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPhoneSection(BuildContext context) {
    return Container(
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
                Icons.phone_outlined,
                size: 30.w,
                color: AppColors.of(context).primaryColor10,
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: isEditPhone
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 6.w),
                        height: 52.w,
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor6,
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                        child: TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          style: AppTextStyles.of(context).regular24.copyWith(
                            color: AppColors.of(context).neutralColor12,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Nhập SĐT",
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Số điện thoại:",
                            style: AppTextStyles.of(context).bold20.copyWith(
                              color: AppColors.of(context).neutralColor10,
                            ),
                          ),
                          Text(
                            phone?.isNotEmpty == true ? phone! : "Trống",
                            style: AppTextStyles.of(context).regular24.copyWith(
                              color: AppColors.of(context).neutralColor12,
                            ),
                          ),
                        ],
                      ),
              ),

              if (!isEditPhone)
                IconButton(
                  onPressed: () {
                    setState(() {
                      isEditPhone = true;
                    });
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 24.w,
                    color: AppColors.of(context).primaryColor10,
                  ),
                ),
              if (isEditPhone)
                Row(
                  children: [
                    IconButton(
                      onPressed: updatePhone,
                      icon: Icon(Icons.check, size: 24.w, color: Colors.green),
                    ),

                    IconButton(
                      onPressed: () {
                        setState(() {
                          isEditPhone = false;
                          phoneController.text = phone ?? "";
                        });
                      },
                      icon: Icon(Icons.close, size: 24.w, color: Colors.red),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddressSection(BuildContext context) {
    return Container(
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
                Icons.location_on_outlined,
                size: 30.w,
                color: AppColors.of(context).primaryColor10,
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: isEditAddress
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 6.w),
                        height: 52.w,
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor6,
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                        child: TextFormField(
                          controller: addressController,
                          style: AppTextStyles.of(context).regular24.copyWith(
                            color: AppColors.of(context).neutralColor12,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Nhập địa chỉ",
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Địa chỉ:",
                            style: AppTextStyles.of(context).bold20.copyWith(
                              color: AppColors.of(context).neutralColor10,
                            ),
                          ),
                          Text(
                            address?.isNotEmpty == true ? address! : "Trống",
                            style: AppTextStyles.of(context).regular24.copyWith(
                              color: AppColors.of(context).neutralColor12,
                            ),
                          ),
                        ],
                      ),
              ),

              if (!isEditAddress)
                IconButton(
                  onPressed: () {
                    setState(() {
                      isEditAddress = true;
                    });
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 24.w,
                    color: AppColors.of(context).primaryColor10,
                  ),
                ),
              if (isEditAddress)
                Row(
                  children: [
                    IconButton(
                      onPressed: updateAddress,
                      icon: Icon(Icons.check, size: 24.w, color: Colors.green),
                    ),

                    IconButton(
                      onPressed: () {
                        setState(() {
                          isEditAddress = false;
                          addressController.text = address ?? "";
                        });
                      },
                      icon: Icon(Icons.close, size: 24.w, color: Colors.red),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
