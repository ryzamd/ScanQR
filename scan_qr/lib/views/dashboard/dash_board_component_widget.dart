import 'package:flutter/material.dart';
import 'package:scan_qr/routes/routes_system.dart';

class DashboardWidgets {
  static Widget buildHeader(BuildContext context) {
    return Row(
      children: [
        // Ảnh đại diện
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage("assets/images/zucca-logo.png"),
          backgroundColor: Colors.white,
        ),
        const SizedBox(width: 16),
        // Thông tin user
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back,",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            Text(
              "John Doe",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget buildStatisticCards(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // canh giữa
      children: [
        _buildCardButton(
          context: context,
          label: "TEMPORARY",
          onPressed: () => Navigator.pushNamed(context, AppRouter.temporary),
        ),
        const SizedBox(width: 16), // khoảng cách giữa hai button
        _buildCardButton(
          context: context,
          label: "OUTBOUND",
          onPressed: () => Navigator.pushNamed(context, AppRouter.outbound),
        ),
      ],
    );
  }

  static Widget _buildCardButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        // Đảm bảo màu chữ là trắng, không bị theme ghi đè
        foregroundColor: Colors.white,
        // Loại bỏ mọi padding mặc định
        padding: EdgeInsets.zero,
        // Tạo bo góc
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Container(
        // Đảm bảo kích thước (ví dụ 100x100)
        width: 150,
        height: 100,
        margin: const EdgeInsets.only(right: 0),
        decoration: BoxDecoration(
          color: const Color(0xff58A8C6), // màu xanh theo thiết kế
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        // Canh chữ vào giữa
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Chắc chắn màu trắng
          ),
        ),
      ),
    );
  }

  static Widget buildFeatureTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 5, color: Colors.black),
        borderRadius: BorderRadius.circular(1),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.grey[350],
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Expanded(
                  child: Text(
                    "Category",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Status",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Total",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 250,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                String category = "Dashboard";
                String status = "Active";
                String total = "120 PS";
                if (index == 1) {
                  category = "Users";
                  status = "Online";
                  total = "450 PS";
                } else if (index == 2) {
                  category = "Orders";
                  status = "Pending";
                  total = "78 PS";
                }
                // Tạo hàng dữ liệu
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          category,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          status,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          total,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
