import 'dart:convert';

import 'package:btl_food_delivery_app/core/constants/stripe_key_constants.dart';
import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/services/database.dart';
import 'package:btl_food_delivery_app/services/shared_pref.dart';
import 'package:btl_food_delivery_app/services/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  String image, name, price;
  DetailPage({
    super.key,
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;
  double totalPrice = 0;
  bool isExpanded = false; // Biến trạng thái để kiểm soát mở rộng text\

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
    wallet = "${querySnapshot.docs[0]["wallet"]}";
    setState(() {});
  }

  @override
  void initState() {
    totalPrice = double.parse(widget.price);
    getUserWallet();
    super.initState();
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

              Center(
                child: Image.asset(
                  widget.image,
                  height: MediaQuery.of(context).size.height / 3,
                  fit: BoxFit.contain,
                ),
              ),

              Text(
                widget.name,
                style: AppWidget.HeadlineTextFieldStyle(context),
              ),

              Text(
                "\$ ${widget.price}",
                style: AppWidget.SimpleTextFieldStyle(context),
              ),

              AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bánh cuốn Hà Nội là một món ăn truyền thống thanh đạm nhưng đầy tinh tế, làm say lòng biết bao thực khách. Lớp bánh được tráng mỏng tang, trắng trong từ bột gạo, quyện trong lớp nhân thơm phức từ thịt xay cùng mộc nhĩ, hành khô. Bánh cuốn nóng hổi được dùng kèm nước chấm chua ngọt đậm đà, điểm xuyến vài cọng hành lá xanh, rau thơm thơm mát. Không thể thiếu chả quế thơm lừng, cà cuống giòn rụm tạo nên hương vị đặc trưng, hòa quyện cùng vị bùi của bánh, vị chua cay mặn ngọt của nước chấm, tất cả tạo nên một dư vị khó quên, là linh hồn của ẩm thực Hà Nội.",
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
                              isExpanded ? "Read less" : "Read more",
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
                "Quantity: ",
                style: AppTextStyles.of(
                  context,
                ).bold32.copyWith(color: AppColors.of(context).neutralColor11),
              ),

              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (quantity > 1) {
                        quantity = quantity - 1;
                        totalPrice = double.parse(
                          (totalPrice - double.parse(widget.price))
                              .toStringAsFixed(2),
                        );
                        setState(() {});
                      }
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
                  GestureDetector(
                    onTap: () {
                      quantity = quantity + 1;
                      totalPrice = double.parse(
                        (totalPrice + double.parse(widget.price))
                            .toStringAsFixed(2),
                      );
                      setState(() {});
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
                      topLeft: Radius.circular(20.w),
                      bottomRight: Radius.circular(20.w),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      decoration: BoxDecoration(
                        color: AppColors.of(context).primaryColor9,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.w),
                          bottomRight: Radius.circular(20.w),
                        ),
                      ),
                      child: Text(
                        "\$ ${totalPrice.toString()}",
                        style: AppTextStyles.of(context).bold32.copyWith(
                          color: AppColors.of(context).neutralColor1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),

              // Button ORDER
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if (address == null) {
                      openBox();
                    } else if (double.parse(wallet!) > totalPrice) {
                      double updatedWallet = double.parse(wallet!) - totalPrice;
                      DatabaseMethods().updateUserWallet(
                        updatedWallet.toString(),
                        id!,
                      );
                      String orderId = randomAlphaNumeric(10);
                      Map<String, dynamic> userOrderMap = {
                        "name": name,
                        "id": id,
                        "quantity": quantity.toString(),
                        "total": totalPrice.toString(),
                        "email": email,
                        "food_name": widget.name,
                        "food_image": widget.image,
                        "order_id": orderId,
                        "status": "Pending",
                        "address": address ?? addressController.text,
                      };
                      await DatabaseMethods().addUserOrderDetails(
                        userOrderMap,
                        id!,
                        orderId,
                      );
                      await DatabaseMethods().addAdminOrderDetails(
                        userOrderMap,
                        orderId,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            "Order placed successfully",
                            style: AppTextStyles.of(context).bold24.copyWith(
                              color: AppColors.of(context).neutralColor12,
                            ),
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "Add some money to your Wallet",
                            style: AppTextStyles.of(context).bold24.copyWith(
                              color: AppColors.of(context).neutralColor12,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(20.w),
                    child: Container(
                      height: 56.h,
                      width: 180.w,
                      decoration: BoxDecoration(
                        color: AppColors.of(context).primaryColor8,
                        borderRadius: BorderRadius.circular(20.w),
                      ),
                      child: Center(
                        child: Text(
                          "ORDER NOW",
                          style: AppTextStyles.of(context).bold32.copyWith(
                            color: AppColors.of(context).neutralColor1,
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
                        Text("Payment Successful"),
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
        builder: (_) => AlertDialog(content: Text("Cancelled")),
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
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 30.w),
                  Text(
                    "Add the address",
                    style: AppTextStyles.of(context).bold32.copyWith(
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
                    hintText: "Address",
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
                        "Add",
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
    ),
  );
}
