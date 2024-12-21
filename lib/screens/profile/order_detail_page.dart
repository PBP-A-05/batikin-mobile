// lib/screens/profile/order_detail_page.dart
import 'package:flutter/material.dart';
import 'package:batikin_mobile/models/order_model.dart';
import 'package:batikin_mobile/utils/utils_function.dart';
import 'package:batikin_mobile/constants/colors.dart';

class OrderDetailPage extends StatelessWidget {
  final Order order;
  final int count;

  const OrderDetailPage({Key? key, required this.order, required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Pemesanan',
          style: TextStyle(color: AppColors.coklat2),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.coklat2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #${order.orderId}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.coklat2,
              ),
            ),
            const SizedBox(height: 16),
            // Harga Total
            Text(
              'Harga Total',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Rp${formatPrice(order.totalPrice)}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            // Alamat Pengiriman
            Text(
              'Alamat Pengiriman',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              order.address.title,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              order.address.address,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Items:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.coklat2,
              ),
            ),
            const SizedBox(height: 8),
            // Product Cards with shadow and margin
            Column(
              children: order.items
                  .map((item) => Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        color: const Color(
                            0xFFFAF4ED), // Customize the card color here

                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Larger Image
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      item.imageUrls.isNotEmpty
                                          ? item.imageUrls[0]
                                          : 'https://via.placeholder.com/120',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Item details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Quantity: ${item.quantity}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Rp${formatPrice(item.price)}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
