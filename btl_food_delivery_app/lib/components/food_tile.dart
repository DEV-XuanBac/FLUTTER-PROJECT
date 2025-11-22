import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:btl_food_delivery_app/model/food_model.dart';
import 'package:btl_food_delivery_app/pages/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodTile extends StatelessWidget {
  final FoodModel food;

  const FoodTile({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(food: food)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.of(context).neutralColor1,
          borderRadius: BorderRadius.circular(16.w),
          boxShadow: [
            BoxShadow(
              color: AppColors.of(context).neutralColor7,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(color: AppColors.of(context).primaryColor6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh sản phẩm
            Container(
              height: 120.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.w),
                  topRight: Radius.circular(16.w),
                ),
                color: AppColors.of(context).neutralColor7,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.w),
                  topRight: Radius.circular(16.w),
                ),
                child: food.image!.startsWith('http')
                    ? Image.network(
                        food.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.of(context).neutralColor6,
                            child: Icon(
                              Icons.fastfood,
                              size: 40.w,
                              color: AppColors.of(context).neutralColor9,
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
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                                color: AppColors.of(context).primaryColor9,
                              ),
                            ),
                          );
                        },
                      )
                    : Image.asset("assets/imagePick.png", fit: BoxFit.cover),
              ),
            ),

            // Thông tin sản phẩm
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.name!,
                              style: AppTextStyles.of(context).regular32
                                  .copyWith(
                                    color: AppColors.of(context).neutralColor12,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "\$${food.price!.toStringAsFixed(2)}",
                              style: AppTextStyles.of(context).bold20.copyWith(
                                color: AppColors.of(context).primaryColor10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (food.kcal != null && food.kcal!.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 20.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.of(context).neutralColor6,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6.w),
                        bottomLeft: Radius.circular(6.w),
                      ),
                    ),
                    child: Text(
                      "${food.kcal} kcal",
                      style: AppTextStyles.of(context).regular20.copyWith(
                        color: AppColors.of(context).neutralColor12,
                      ),
                    ),
                  ),
              ],
            ),

            Spacer(),

            // Nút chi tiết
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 32.h,
                width: 50.w,
                decoration: BoxDecoration(
                  color: AppColors.of(context).primaryColor10,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.w),
                    bottomRight: Radius.circular(16.w),
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  size: 20.w,
                  color: AppColors.of(context).neutralColor1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
