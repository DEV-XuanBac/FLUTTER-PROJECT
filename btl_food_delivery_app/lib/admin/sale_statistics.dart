import 'package:btl_food_delivery_app/core/extensions/thems_extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class SaleStatistics extends StatefulWidget {
  const SaleStatistics({super.key});

  @override
  State<SaleStatistics> createState() => _SaleStatisticsState();
}

class _SaleStatisticsState extends State<SaleStatistics> {
  int totalFoodItems = 0;
  int totalOrders = 0;
  double totalRevenue = 0.0;
  Map<String, int> foodOrderCount = {};
  String mostPopularFood = 'Đang tải...';
  int mostPopularFoodCount = 0;

  bool isLoading = true;
  DateTimeRange? selectedDateRange;
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDateRange = DateTimeRange(start: startDate, end: endDate);
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    setState(() {
      isLoading = true;
    });

    try {
      await Future.wait([
        getTotalFoodItems(),
        getTotalOrdersAndRevenue(),
        getMostPopularFoodItem(),
      ]);
    } catch (e) {
      print('Lỗi tải thống kê: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> getTotalFoodItems() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('foods')
          .count()
          .get();
      setState(() {
        totalFoodItems = snapshot.count!;
      });
    } catch (e) {
      print('Lỗi tải tổng số món ăn: $e');
    }
  }

  Future<void> getTotalOrdersAndRevenue() async {
    try {
      QuerySnapshot querySnapshot;

      if (selectedDateRange == null) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where(
              'createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(
                selectedDateRange!.start,
              ),
            )
            .where(
              'createdAt',
              isLessThanOrEqualTo: Timestamp.fromDate(
                selectedDateRange!.end.add(Duration(days: 1)),
              ),
            )
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .get();
      }

      int ordersCount = querySnapshot.docs.length;
      double revenue = 0.0;
      Map<String, int> foodCountMap = {};

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        // Tính tổng doanh thu
        if (data['total'] != null) {
          try {
            revenue += double.parse(data['total']).toDouble();
          } catch (e) {
            print('Lỗi chuyển đổi tổng thành số: $e');
          }
        }

        // Đếm số lượng món ăn đã bán
        String foodName = data['foodName']?.toString() ?? '';
        int quantity = int.tryParse(data['quantity']?.toString() ?? '1') ?? 1;

        foodCountMap[foodName] = (foodCountMap[foodName] ?? 0) + quantity;
      }
      setState(() {
        totalOrders = ordersCount;
        totalRevenue = revenue;
        foodOrderCount = foodCountMap;
      });
    } catch (e) {
      print('Lỗi tải tổng số đơn hàng và doanh thu: $e');
    }
  }

  Future<void> getMostPopularFoodItem() async {
    if (foodOrderCount.isEmpty) {
      await getTotalOrdersAndRevenue();
    }

    if (foodOrderCount.isNotEmpty) {
      var mostPopular = foodOrderCount.entries.reduce((a, b) {
        return a.value > b.value ? a : b;
      });

      setState(() {
        mostPopularFood = mostPopular.key;
        mostPopularFoodCount = mostPopular.value;
      });
    } else {
      setState(() {
        mostPopularFood = 'Chưa có dữ liệu';
        mostPopularFoodCount = 0;
      });
    }
  }

  Future _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDateRange: selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.of(context).primaryColor9,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
        startDate = picked.start;
        endDate = picked.end;
      });
      await loadStatistics();
    }
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(16.w),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.of(context).neutralColor1,
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 30.w, color: color),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.of(context).bold20.copyWith(
                      color: AppColors.of(context).neutralColor11,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              value,
              style: AppTextStyles.of(
                context,
              ).regular32.copyWith(color: AppColors.of(context).primaryColor10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodRankingCard() {
    List<MapEntry<String, int>> sortedFoods = foodOrderCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value))
      ..take(5);

    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(16.w),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.of(context).neutralColor1,
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Top 5 món ăn bán chạy",
              style: AppTextStyles.of(
                context,
              ).bold24.copyWith(color: AppColors.of(context).neutralColor12),
            ),
            SizedBox(height: 10.h),
            if (sortedFoods.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Center(
                  child: Text(
                    "Chưa có dữ liệu đơn hàng",
                    style: AppTextStyles.of(context).regular20.copyWith(
                      color: AppColors.of(context).neutralColor10,
                    ),
                  ),
                ),
              )
            else
              Column(
                children: sortedFoods.asMap().entries.map((entry) {
                  int index = entry.key;
                  var food = entry.value;

                  return Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.of(context).neutralColor3,
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: _getRankColor(index),
                            borderRadius: BorderRadius.circular(50.w),
                          ),
                          child: Center(
                            child: Text(
                              "${index + 1}",
                              style: AppTextStyles.of(
                                context,
                              ).bold20.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            food.key,
                            style: AppTextStyles.of(context).regular24.copyWith(
                              color: AppColors.of(context).neutralColor12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "${food.value} đơn",
                          style: AppTextStyles.of(context).bold20.copyWith(
                            color: AppColors.of(context).primaryColor9,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber[700]!;
      case 1:
        return Colors.grey[600]!;
      case 2:
        return Colors.brown[700]!;
      default:
        return AppColors.of(context).neutralColor8;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // App Bar
          Container(
            padding: EdgeInsets.only(
              top: 45.h,
              left: 20.w,
              right: 20.w,
              bottom: 10.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.of(context).primaryColor9,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.w),
                bottomRight: Radius.circular(20.w),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.of(context).neutralColor1,
                    size: 24.w,
                  ),
                ),
                SizedBox(width: 30.w),
                Expanded(
                  child: Text(
                    "Thống kê doanh số",
                    style: AppTextStyles.of(context).bold32.copyWith(
                      color: AppColors.of(context).neutralColor1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chọn khoảng thời gian
          Padding(
            padding: EdgeInsets.all(12.w),
            child: GestureDetector(
              onTap: () => _selectDateRange(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.of(context).neutralColor3,
                  borderRadius: BorderRadius.circular(12.w),
                  border: Border.all(
                    width: 1.3.w,
                    color: AppColors.of(context).primaryColor9,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: AppColors.of(context).primaryColor9,
                          size: 20.w,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "Khoảng thời gian:",
                          style: AppTextStyles.of(context).regular20.copyWith(
                            color: AppColors.of(context).neutralColor12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}",
                      style: AppTextStyles.of(context).regular20.copyWith(
                        color: AppColors.of(context).primaryColor9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.of(context).primaryColor9,
                    ),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        // Row 1: Tổng quan
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                "Tổng số món ăn",
                                "$totalFoodItems",
                                Icons.fastfood,
                                Colors.orange,
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: _buildStatCard(
                                "Tổng đơn hàng",
                                "$totalOrders",
                                Icons.shopping_cart,
                                Colors.green,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Row 2: Doanh thu
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                "Tổng doanh thu",
                                "\$ ${totalRevenue.toStringAsFixed(2)}",
                                Icons.attach_money,
                                Colors.amber,
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: _buildStatCard(
                                "Bán chạy nhất",
                                mostPopularFood,
                                Icons.star,
                                Colors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 45.h),

                        // Top 5 món ăn bán chạy
                        _buildFoodRankingCard(),
                        SizedBox(height: 20.h),

                        // Button làm mới
                        GestureDetector(
                          onTap: loadStatistics,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: AppColors.of(context).primaryColor9,
                              borderRadius: BorderRadius.circular(12.w),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh,
                                    color: AppColors.of(context).neutralColor1,
                                    size: 20.w,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "Làm mới dữ liệu",
                                    style: AppTextStyles.of(context).bold24
                                        .copyWith(
                                          color: AppColors.of(
                                            context,
                                          ).neutralColor1,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
