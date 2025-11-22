import 'dart:convert';

import 'package:btl_food_delivery_app/core/constants/stripe_key_constants.dart';
import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/model/food_model.dart';
import 'package:btl_food_delivery_app/services/database.dart';
import 'package:btl_food_delivery_app/services/shared_pref.dart';
import 'package:btl_food_delivery_app/components/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  final FoodModel food;
  DetailPage({super.key, required this.food});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;
  double totalPrice = 0;
  bool isExpanded = false; // Biến trạng thái để kiểm soát mở rộng text
  bool isLoading = false;

  Map<String, dynamic>? paymentIntent;
  String? name, id, email, address, wallet;
  TextEditingController addressController = TextEditingController();

  getTheSharedPref() async {
    name = await SharedPref().getUsername();
    id = await SharedPref().getUserId();
    email = await SharedPref().getUserEmail();
    address = await SharedPref().getUserAddress();
    setState(() {});
  }

  getUserWallet() async {
    await getTheSharedPref();
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserWalletByEmail(
      email!,
    );

    if (querySnapshot.docs.isNotEmpty && mounted) {
      setState(() {
        wallet = "${querySnapshot.docs[0]["wallet"]}";
      });
    }
  }

  @override
  void initState() {
    totalPrice = widget.food.price ?? 0;
    getUserWallet();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 45.w, left: 15.w, right: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).primaryColor9,
                    borderRadius: BorderRadius.circular(50.w),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    size: 30.w,
                    color: AppColors.of(context).neutralColor1,
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              // Ảnh sản phẩm
              Center(
                child: Container(
                  height: 250.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.w),
                    color: AppColors.of(context).neutralColor7,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.w),
                    child: widget.food.image!.startsWith("http")
                        ? Image.network(
                            widget.food.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.of(context).neutralColor6,
                                child: Icon(
                                  Icons.fastfood,
                                  size: 60.w,
                                  color: AppColors.of(context).neutralColor10,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: AppColors.of(context).neutralColor6,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                        : null,
                                    color: AppColors.of(context).primaryColor10,
                                  ),
                                ),
                              );
                            },
                          )
                        : Image.asset(
                            "assets/imagePick.png",
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),

              Text(
                widget.food.name ?? "Đoán xem món gì :))",
                style: AppWidget.HeadlineTextFieldStyle(context),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$ ${widget.food.price?.toStringAsFixed(2) ?? "0.0"}",
                    style: AppTextStyles.of(context).regular32.copyWith(
                      color: AppColors.of(context).primaryColor9,
                    ),
                  ),
                  if (widget.food.kcal != null)
                    Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: AppColors.of(context).neutralColor3,
                        borderRadius: BorderRadius.circular(14.w),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: AppColors.of(context).primaryColor10,
                            size: 20.w,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "${widget.food.kcal} kcal",
                            style: AppTextStyles.of(context).bold20.copyWith(
                              color: AppColors.of(context).neutralColor12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              Text(
                "Thành phần: ${widget.food.item!}",
                style: AppTextStyles.of(context).regular24.copyWith(
                  color: AppColors.of(context).neutralColor11,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Mô tả
              AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mô tả",
                        style: AppTextStyles.of(context).bold24.copyWith(
                          color: AppColors.of(context).neutralColor11,
                        ),
                      ),
                      Text(
                        widget.food.description ?? "Không có mô tả",
                        maxLines: isExpanded
                            ? null // null khi mở rộng
                            : 3, // 3 dòng khi thu gọn
                        overflow: isExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis, // Cắt text khi thu gọn
                        style: AppTextStyles.of(context).light24,
                      ),
                      SizedBox(height: 6.h),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded; // Đảo ngược trạng thái
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isExpanded ? "Thu gọn" : "Đọc thêm",
                              style: AppTextStyles.of(context).light24.copyWith(
                                color: AppColors.of(context).primaryColor8,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: AppColors.of(context).primaryColor8,
                              size: 16.sp,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Text(
                "Số lượng",
                style: AppTextStyles.of(
                  context,
                ).bold32.copyWith(color: AppColors.of(context).neutralColor11),
              ),

              Row(
                children: [
                  // Nút giảm
                  GestureDetector(
                    onTap: () {
                      if (quantity > 1) {
                        quantity = quantity - 1;
                        totalPrice = (widget.food.price ?? 0) * quantity;
                        setState(() {});
                      }
                    },
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10.w),
                      child: Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: quantity > 1
                              ? AppColors.of(context).primaryColor9
                              : AppColors.of(context).neutralColor10,
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: AppColors.of(context).neutralColor1,
                          size: 26.w,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Text("$quantity", style: AppTextStyles.of(context).bold32),
                  SizedBox(width: 15.w),

                  // Nút tăng
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        quantity = quantity + 1;
                        totalPrice = (widget.food.price ?? 0) * quantity;
                      });
                    },
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10.w),
                      child: Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: AppColors.of(context).primaryColor9,
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                        child: Icon(
                          Icons.add,
                          color: AppColors.of(context).neutralColor1,
                          size: 26.w,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.w),
                      bottomRight: Radius.circular(50.w),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 5.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.of(context).primaryColor9,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.w),
                          bottomRight: Radius.circular(20.w),
                        ),
                      ),
                      child: Text(
                        "\$ ${totalPrice.toStringAsFixed(2)}",
                        style: AppTextStyles.of(context).bold32.copyWith(
                          color: AppColors.of(context).neutralColor1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              if (wallet != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).neutralColor1,
                    borderRadius: BorderRadius.circular(12.w),
                    border: Border.all(
                      color: double.parse(wallet!) >= totalPrice
                          ? Colors.green
                          : Colors.orange,
                      width: 1.w,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        double.parse(wallet!) >= totalPrice
                            ? Icons.check_circle
                            : Icons.warning,
                        color: double.parse(wallet!) >= totalPrice
                            ? Colors.green
                            : Colors.orange,
                        size: 24.w,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          double.parse(wallet!) >= totalPrice
                              ? "Số dư khả dụng: \$$wallet"
                              : "Số dư không đủ: \$$wallet, hãy nạp thêm!",
                          style: AppTextStyles.of(context).regular20.copyWith(
                            color: AppColors.of(context).neutralColor12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 10.h),
              // Button ORDER
              Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : GestureDetector(
                        onTap: () async {
                          if (address == null) {
                            openBox();
                          } else if (double.parse(wallet!) >= totalPrice) {
                            createOrder();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  "Nạp thêm tiền vào tài khoản",
                                  style: AppTextStyles.of(context).bold24
                                      .copyWith(
                                        color: AppColors.of(
                                          context,
                                        ).neutralColor12,
                                      ),
                                ),
                              ),
                            );
                          }
                        },
                        child: Material(
                          elevation: 8.0,
                          borderRadius: BorderRadius.circular(16.w),
                          child: Container(
                            height: 56.h,
                            width: 200.w,
                            decoration: BoxDecoration(
                              color: AppColors.of(context).primaryColor9,
                              borderRadius: BorderRadius.circular(16.w),
                            ),
                            child: Center(
                              child: Text(
                                "Đặt hàng ngay",
                                style: AppTextStyles.of(context).bold32
                                    .copyWith(
                                      color: AppColors.of(
                                        context,
                                      ).neutralColor1,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createOrder() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      double updateWallet = double.parse(wallet!) - totalPrice;
      await DatabaseMethods().updateUserWallet(
        updateWallet.toStringAsFixed(2),
        id!,
      );

      // Tạo bảng order
      String orderId = randomAlphaNumeric(10);
      Map<String, dynamic> userOrderMap = {
        "username": name,
        "id": id,
        "quantity": quantity.toString(),
        "total": totalPrice.toStringAsFixed(2),
        "email": email,
        "foodName": widget.food.name,
        "foodImage": widget.food.image,
        "orderId": orderId,
        "status": "Pending",
        "address": address!,
        "createdAt": FieldValue.serverTimestamp(),
      };

      await DatabaseMethods().addUserOrderDetails(userOrderMap, id!, orderId);
      await DatabaseMethods().addAdminOrderDetails(userOrderMap, orderId);

      Map<String, dynamic> transactionMap = {
        "type": "order",
        "amount": totalPrice.toStringAsFixed(2),
        "orderId": orderId,
        "foodName": widget.food.name,
        "date": DateFormat("dd/MM/yyyy - HH:mm").format(DateTime.now()),
        "timestamp": FieldValue.serverTimestamp(),
      };
      await DatabaseMethods().addUserTransaction(transactionMap, id!);

      if (mounted) {
        setState(() {
          wallet = updateWallet.toStringAsFixed(2);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Đặt hàng thành công!",
              style: AppTextStyles.of(context).bold20,
            ),
          ),
        );

        // Tự quay lại sau 2s
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent?["client_secret"],
              style: ThemeMode.dark,
              merchantDisplayName: 'Adnan',
            ),
          )
          .then((value) {});
      displayPaymentSheet(amount);
    } catch (e, s) {
      print("Exception: $e$s");
    }
  }

  displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance
          .presentPaymentSheet()
          .then((value) async {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        Text("Thanh toán thành công"),
                      ],
                    ),
                  ],
                ),
              ),
            );
            paymentIntent = null;
          })
          .onError((error, stackTree) {
            print("Error is: --> $error $stackTree");
          });
    } on StripeException catch (e) {
      print("Error is: --> $e");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(content: Text("Quay lại")),
      );
    } catch (e) {
      print("$e");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var res = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${StripeKeyConstants.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      print("Payment Intent response: ${res.body}");
      return jsonDecode(res.body);
    } catch (e) {
      print("Error charging user: ${e.toString()}");
      return null;
    }
  }

  String calculateAmount(String amount) {
    final calculatedAmount = double.parse(amount);
    final int amountInCents = (calculatedAmount * 100).toInt();
    return amountInCents.toString();
  }

  Future openBox() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SizedBox(width: 30.w),
                Text(
                  "Thêm địa chỉ",
                  style: AppTextStyles.of(context).bold24.copyWith(
                    color: AppColors.of(context).primaryColor10,
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.cancel, size: 26.w),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.of(context).neutralColor9,
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(14.w),
              ),
              child: TextField(
                controller: addressController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Địa chỉ của bạn",
                  hintStyle: AppTextStyles.of(context).regular24.copyWith(
                    color: AppColors.of(context).neutralColor11,
                  ),
                ),
                style: AppTextStyles.of(context).regular24.copyWith(
                  color: AppColors.of(context).neutralColor11,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () async {
                address = addressController.text;
                await SharedPref().saveUserAddress(addressController.text);
                Navigator.pop(context);
              },
              child: Center(
                child: Container(
                  width: 130.w,
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).primaryColor9,
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                  child: Center(
                    child: Text(
                      "Cập nhật",
                      style: AppTextStyles.of(context).bold24.copyWith(
                        color: AppColors.of(context).neutralColor1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
