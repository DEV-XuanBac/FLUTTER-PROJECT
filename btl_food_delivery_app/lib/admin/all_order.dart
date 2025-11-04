import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllOrder extends StatefulWidget {
  const AllOrder({super.key});

  @override
  State<AllOrder> createState() => _AllOrderState();
}

class _AllOrderState extends State<AllOrder> {
  Stream? orderStream;

  getInTheLoad() async {
    orderStream = await DatabaseMethods().getAdminOrders();
    setState(() {});
  }

  @override
  void initState() {
    getInTheLoad();
    super.initState();
  }

  Widget allOrder() {
    return StreamBuilder(
      stream: orderStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
                    margin: EdgeInsets.only(top: 20.h, left: 10.w, right: 10.w),
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14.w),
                        topRight: Radius.circular(14.w),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 5.h,
                        ),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor1,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(14.w),
                            topRight: Radius.circular(14.w),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: AppColors.of(context).primaryColor10,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  ds["address"],
                                  style: AppTextStyles.of(context).bold32
                                      .copyWith(
                                        color: AppColors.of(
                                          context,
                                        ).neutralColor12,
                                      ),
                                ),
                              ],
                            ),
                            Divider(
                              color: AppColors.of(context).neutralColor12,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  ds["food_image"],
                                  height: 85.h,
                                  width: 85.w,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(width: 30.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ds["food_name"],
                                      style: AppTextStyles.of(context).bold32
                                          .copyWith(
                                            color: AppColors.of(
                                              context,
                                            ).neutralColor12,
                                          ),
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.production_quantity_limits,
                                              size: 16.w,
                                              color: AppColors.of(
                                                context,
                                              ).primaryColor10,
                                            ),
                                            SizedBox(width: 6.w),
                                            Text(
                                              ds["quantity"],
                                              style: AppTextStyles.of(
                                                context,
                                              ).bold16,
                                            ),
                                            SizedBox(width: 30.w),
                                            Icon(
                                              Icons.monetization_on,
                                              size: 16.w,
                                              color: AppColors.of(
                                                context,
                                              ).primaryColor10,
                                            ),
                                            SizedBox(width: 6.w),
                                            Text(
                                              "\$ ${ds["total"]}",
                                              style: AppTextStyles.of(
                                                context,
                                              ).bold16,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 18.w,
                                          color: AppColors.of(
                                            context,
                                          ).primaryColor9,
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          ds["name"],
                                          style: AppTextStyles.of(context)
                                              .regular24
                                              .copyWith(
                                                color: AppColors.of(
                                                  context,
                                                ).neutralColor12,
                                              ),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Icon(
                                          Icons.email,
                                          size: 18.w,
                                          color: AppColors.of(
                                            context,
                                          ).primaryColor9,
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          ds["email"],
                                          style: AppTextStyles.of(context)
                                              .regular24
                                              .copyWith(
                                                color: AppColors.of(
                                                  context,
                                                ).neutralColor11,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          ds["status"] + "!",
                                          style: AppTextStyles.of(context)
                                              .bold24
                                              .copyWith(
                                                color: AppColors.of(
                                                  context,
                                                ).primaryColor10,
                                              ),
                                        ),
                                        SizedBox(width: 20.w),

                                        GestureDetector(
                                          onTap: () async {
                                            await DatabaseMethods()
                                                .updateAdminOrder(ds.id);
                                            await DatabaseMethods()
                                                .updateUserOrder(
                                                  ds["id"],
                                                  ds.id,
                                                );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20.w,
                                              vertical: 4.w,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.of(
                                                context,
                                              ).primaryColor9,
                                              borderRadius:
                                                  BorderRadius.circular(10.w),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Delivered",
                                                style: AppTextStyles.of(context)
                                                    .bold24
                                                    .copyWith(
                                                      color: AppColors.of(
                                                        context,
                                                      ).neutralColor1,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 45.h, left: 12.w, right: 12.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.of(context).primaryColor9,
                      borderRadius: BorderRadius.circular(50.w),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.of(context).neutralColor1,
                    ),
                  ),
                ),
                SizedBox(width: 88.w),
                Text(
                  "All orders",
                  style: AppTextStyles.of(context).bold32.copyWith(
                    color: AppColors.of(context).neutralColor12,
                  ),
                ),
              ],
            ),
          ),

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
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: allOrder(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
