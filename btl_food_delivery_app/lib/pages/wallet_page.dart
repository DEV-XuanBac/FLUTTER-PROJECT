import 'dart:convert';

import 'package:btl_food_delivery_app/core/constants/stripe_key_constants.dart';
import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/services/database.dart';
import 'package:btl_food_delivery_app/services/shared_pref.dart';
import 'package:btl_food_delivery_app/components/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  Map<String, dynamic>? paymentIntent;
  TextEditingController amountController = TextEditingController();
  String? email, wallet, id;
  Stream? walletStream;
  bool _isLoading = true;

  getTheSharedPref() async {
    email = await SharedPref().getUserEmail();
    id = await SharedPref().getUserId();
    if (mounted) setState(() {});
  }

  getUserWallet() async {
    await getTheSharedPref();
    walletStream = await DatabaseMethods().getUserTransactions(id!);
    try {
      QuerySnapshot querySnapshot = await DatabaseMethods()
          .getUserWalletByEmail(email!);

      if (querySnapshot.docs.isNotEmpty) {
        if (mounted) {
          setState(() {
            wallet = "${querySnapshot.docs[0]["wallet"]}";
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error getting wallet: $e");
      if (mounted) {
        setState(() {
          _isLoading = true;
          wallet = "0.00";
        });
      }
    }
  }

  @override
  void initState() {
    getUserWallet();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    amountController.dispose();
    super.dispose();
  }

  Widget allTrans() {
    return StreamBuilder(
      stream: walletStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Lỗi tải giao dịch",
              style: AppTextStyles.of(
                context,
              ).regular24.copyWith(color: AppColors.of(context).neutralColor11),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 60.w,
                  color: AppColors.of(context).neutralColor11,
                ),
                SizedBox(height: 16.h),
                Text(
                  "Chưa có giao dịch nào",
                  style: AppTextStyles.of(context).regular24.copyWith(
                    color: AppColors.of(context).neutralColor11,
                  ),
                ),
              ],
            ),
          );
        }

        var docs = snapshot.data.docs;

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = docs[index];
            final data = ds.data() as Map<String, dynamic>;
            final type = data["type"] ?? "deposit";
            final amount = data["amount"] ?? "0.0";
            final date = data["date"] ?? "Unknown";
            final foodName = data["foodName"] ?? "";
            final orderId = data["orderId"] ?? "";

            return transactionItem(
              type: type,
              amount: amount,
              date: date,
              foodName: foodName,
              orderId: orderId,
            );
          },
        );
      },
    );
  }

  Widget transactionItem({
    required String type,
    required String amount,
    required String date,
    String foodName = "",
    String orderId = "",
  }) {
    final isDeposit = type == "deposit";
    final isOrder = type == "order";

    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
      decoration: BoxDecoration(
        color: AppColors.of(context).neutralColor6,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(
          color: AppColors.of(context).neutralColor8,
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDeposit
                      ? "Nạp tiền vào ví"
                      : isOrder
                      ? "Đơn hàng $foodName"
                      : "Giao dịch",
                  style: AppTextStyles.of(context).bold20.copyWith(
                    color: AppColors.of(context).neutralColor12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${isDeposit ? "+" : "-"} \$$amount",
                  style: AppTextStyles.of(context).bold24.copyWith(
                    color: isDeposit
                        ? Colors.green
                        : AppColors.of(context).primaryColor10,
                  ),
                ),
              ],
            ),
          ),

          // Ngày và icon
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                date,
                style: AppTextStyles.of(context).regular24.copyWith(
                  color: AppColors.of(context).neutralColor11,
                ),
              ),
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: isDeposit
                      ? Colors.green
                      : AppColors.of(context).primaryColor10,
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: Center(
                  child: Icon(
                    isDeposit ? Icons.check_circle : Icons.shopping_bag,
                    size: 18.w,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.of(context).primaryColor2,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.only(top: 40.h),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Ví của bạn",
                      style: AppWidget.HeadlineTextFieldStyle(context),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.of(context).neutralColor7,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.w),
                          topRight: Radius.circular(20.w),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Số dư
                          Container(
                            margin: EdgeInsets.only(
                              left: 10.w,
                              right: 10.w,
                              top: 20.h,
                            ),
                            child: Material(
                              elevation: 4.0,
                              borderRadius: BorderRadius.circular(14.w),
                              child: Container(
                                padding: EdgeInsets.all(10.w),
                                width: double.infinity,
                                height: 100.h,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.of(context).primaryColor6,
                                      AppColors.of(context).primaryColor7,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14.w),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10.w),
                                      child: Icon(
                                        Icons.account_balance_wallet,
                                        size: 45.w,
                                        color: AppColors.of(
                                          context,
                                        ).neutralColor11,
                                      ),
                                    ),
                                    SizedBox(width: 20.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Số dư hiện tại",
                                            style: AppTextStyles.of(context)
                                                .regular24
                                                .copyWith(
                                                  color: AppColors.of(
                                                    context,
                                                  ).neutralColor12,
                                                ),
                                          ),
                                          Text(
                                            "\$ $wallet",
                                            style: AppTextStyles.of(context)
                                                .bold32
                                                .copyWith(
                                                  color: AppColors.of(
                                                    context,
                                                  ).primaryColor10,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 20.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildAmountButton("50"),
                                buildAmountButton("100"),
                                buildAmountButton("200"),
                              ],
                            ),
                          ),

                          // ADD money
                          SizedBox(height: 10.h),
                          GestureDetector(
                            onTap: () {
                              openBox();
                            },
                            child: Container(
                              height: 46.h,
                              width: MediaQuery.of(context).size.width / 1.4,
                              decoration: BoxDecoration(
                                color: AppColors.of(context).primaryColor10,
                                borderRadius: BorderRadius.circular(12.w),
                              ),
                              child: Center(
                                child: Text(
                                  "Nạp tiền vào ví",
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
                          SizedBox(height: 10.h),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: AppColors.of(context).neutralColor1,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.w),
                                  topRight: Radius.circular(20.w),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 5.h),
                                  Text(
                                    "Danh sách giao dịch",
                                    style: AppTextStyles.of(context).bold32
                                        .copyWith(
                                          color: AppColors.of(
                                            context,
                                          ).neutralColor11,
                                        ),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height /
                                        2.6,
                                    child: allTrans(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildAmountButton(String amount) {
    return GestureDetector(
      onTap: () {
        makePayment(amount);
      },
      child: Container(
        height: 46.h,
        width: 100.w,
        decoration: BoxDecoration(
          color: AppColors.of(context).neutralColor5,
          border: Border.all(
            color: AppColors.of(context).primaryColor9,
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(14.w),
        ),
        child: Center(
          child: Text(
            "\$$amount",
            style: AppTextStyles.of(
              context,
            ).bold24.copyWith(color: AppColors.of(context).primaryColor10),
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

  Future<void> displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet();

      // payment successful
      double updatedWallet = double.parse(wallet!) + double.parse(amount);
      await DatabaseMethods().updateUserWallet(
        updatedWallet.toStringAsFixed(2),
        id!,
      );

      // update transaction
      DateTime now = DateTime.now();
      String formattedDate = DateFormat("dd/MM/yyyy - HH:mm").format(now);
      Map<String, dynamic> userTrans = {
        "amount": amount,
        "date": formattedDate,
        "type": "deposit",
        "timestamp": FieldValue.serverTimestamp(),
      };
      await DatabaseMethods().addUserTransaction(userTrans, id!);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8.w),
                Text(
                  "Thành công",
                  style: AppTextStyles.of(context).regular24.copyWith(
                    color: AppColors.of(context).neutralColor12,
                  ),
                ),
              ],
            ),
            content: Text("Nạp tiền thành công"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }

      paymentIntent == null;
    } on StripeException catch (e) {
      print("Error is: --> $e");
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(content: Text("Thanh toán thất bại")),
        );
      }
    } catch (e) {
      print("$e");
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(content: Text("Lỗi thanh toán: $e")),
        );
      }
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
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      print("Error charging user: ${e.toString()}");
      rethrow;
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.w)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 30.w),
                Text(
                  "Nạp tiền",
                  style: AppTextStyles.of(context).bold32.copyWith(
                    color: AppColors.of(context).primaryColor10,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 24.w),
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
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Số tiền muốn nạp",
                  hintStyle: AppTextStyles.of(context).regular24.copyWith(
                    color: AppColors.of(context).neutralColor11,
                  ),
                  prefixText: "\$ ",
                ),
                style: AppTextStyles.of(context).regular24.copyWith(
                  color: AppColors.of(context).neutralColor11,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (amountController.text.isNotEmpty) {
                    Navigator.pop(context);
                    await makePayment(amountController.text);
                    amountController.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Nhập số tiền hợp lệ"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.of(context).primaryColor9,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                ),
                child: Text(
                  "Thanh toán",
                  style: AppTextStyles.of(
                    context,
                  ).bold24.copyWith(color: AppColors.of(context).neutralColor1),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
