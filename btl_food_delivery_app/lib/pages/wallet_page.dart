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
import 'package:intl/intl.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  Map<String, dynamic>? paymentIntent;

  TextEditingController amountController = new TextEditingController();

  String? email, wallet, id;

  Stream? walletStream;

  getTheSharedPref() async {
    email = await SharedPref().getUserEmail();
    id = await SharedPref().getUserId();
    setState(() {});
  }

  getUserWallet() async {
    await getTheSharedPref();
    walletStream = await DatabaseMethods().getUserTransactions(id!);
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserWalletByEmail(
      email!,
    );
    wallet = "${querySnapshot.docs[0]["wallet"]}";
    print(wallet);
    setState(() {});
  }

  @override
  void initState() {
    getUserWallet();
    super.initState();
  }

  Widget allTrans() {
    return StreamBuilder(
      stream: walletStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
                    padding: EdgeInsets.all(10.w),
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 5.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.of(context).neutralColor6,
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Added ",
                                style: AppTextStyles.of(context).regular20
                                    .copyWith(
                                      color: AppColors.of(
                                        context,
                                      ).neutralColor11,
                                    ),
                              ),
                              TextSpan(
                                text: "\$${ds["amount"]} ",
                                style: AppTextStyles.of(context).bold24
                                    .copyWith(
                                      color: AppColors.of(
                                        context,
                                      ).primaryColor10,
                                    ),
                              ),
                              TextSpan(
                                text: "to your wallet",
                                style: AppTextStyles.of(context).regular20
                                    .copyWith(
                                      color: AppColors.of(
                                        context,
                                      ).neutralColor11,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          ds["date"],
                          style: AppTextStyles.of(context).regular24.copyWith(
                            color: AppColors.of(context).neutralColor12,
                          ),
                        ),
                      ],
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
      body: wallet == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.only(top: 40.h),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Wallet",
                      style: AppWidget.HeadlineTextFieldStyle(context),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColors.of(context).neutralColor7,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.w),
                          topRight: Radius.circular(20.w),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 10.w,
                              right: 10.w,
                              top: 20.h,
                            ),
                            child: Material(
                              elevation: 3.0,
                              borderRadius: BorderRadius.circular(14.w),
                              child: Container(
                                padding: EdgeInsets.all(10.w),
                                width: MediaQuery.of(context).size.width,
                                height: 100.h,
                                decoration: BoxDecoration(
                                  color: AppColors.of(context).primaryColor7,
                                  borderRadius: BorderRadius.circular(14.w),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/order.png",
                                      height: 60.w,
                                      width: 60.w,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 20.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Your wallet",
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
                                GestureDetector(
                                  onTap: () {
                                    makePayment("50");
                                  },
                                  child: Container(
                                    height: 46.h,
                                    width: 86.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.of(
                                        context,
                                      ).neutralColor1,
                                      border: Border.all(
                                        color: AppColors.of(
                                          context,
                                        ).neutralColor10,
                                        width: 2.w,
                                      ),
                                      borderRadius: BorderRadius.circular(12.w),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "\$50",
                                        style: AppTextStyles.of(context).bold32
                                            .copyWith(
                                              color: AppColors.of(
                                                context,
                                              ).neutralColor11,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {
                                    makePayment("100");
                                  },
                                  child: Container(
                                    height: 46.h,
                                    width: 86.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.of(
                                        context,
                                      ).neutralColor1,
                                      border: Border.all(
                                        color: AppColors.of(
                                          context,
                                        ).neutralColor10,
                                        width: 2.w,
                                      ),
                                      borderRadius: BorderRadius.circular(12.w),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "\$100",
                                        style: AppTextStyles.of(context).bold32
                                            .copyWith(
                                              color: AppColors.of(
                                                context,
                                              ).neutralColor11,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {
                                    makePayment("200");
                                  },
                                  child: Container(
                                    height: 46.h,
                                    width: 86.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.of(
                                        context,
                                      ).neutralColor1,
                                      border: Border.all(
                                        color: AppColors.of(
                                          context,
                                        ).neutralColor10,
                                        width: 2.w,
                                      ),
                                      borderRadius: BorderRadius.circular(12.w),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "\$200",
                                        style: AppTextStyles.of(context).bold32
                                            .copyWith(
                                              color: AppColors.of(
                                                context,
                                              ).neutralColor11,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
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
                                  "Add money",
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
                                    "Your transactions",
                                    style: AppTextStyles.of(context).bold32
                                        .copyWith(
                                          color: AppColors.of(
                                            context,
                                          ).neutralColor11,
                                        ),
                                  ),
                                  Container(
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
            double updatedWallet = double.parse(wallet!) + double.parse(amount);
            await DatabaseMethods().updateUserWallet(
              updatedWallet.toStringAsFixed(2),
              id!,
            );
            await getUserWallet();
            setState(() {});
            DateTime now = DateTime.now();
            String formattedDate = DateFormat("dd MMM").format(now);
            Map<String, dynamic> userTrans = {
              "amount": amount,
              "date": formattedDate,
            };
            await DatabaseMethods().addUserTransaction(userTrans, id!);

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
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
          'Authorization': 'Bearer $secretkey',
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
                    "Add amount",
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
                  controller: amountController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "amount",
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
                  makePayment(amountController.text);
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
