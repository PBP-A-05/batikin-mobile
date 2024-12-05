// lib/screens/profile/order_detail_page.dart
import 'package:flutter/material.dart';
import 'package:batikin_mobile/models/order_model.dart';
import 'package:batikin_mobile/constants/colors.dart';
import 'package:batikin_mobile/widgets/custom_button.dart';
import 'package:batikin_mobile/utils/utils_function.dart';
import 'package:batikin_mobile/utils/toast_util.dart';
import 'package:carousel_slider/carousel_slider.dart';

class OrderDetailPage extends StatelessWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order #${order.orderId} Details',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.coklat2,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Order Information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ID: ${order.orderId}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.coklat2,
                    ),
                  ),
                  Text(
                    formatDate(order.createdAt),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Address Information
              Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.coklat2),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${order.address.title}, ${order.address.address}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // List of Items in the Order
              const Text(
                'Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.coklat2,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return OrderItemWidget(item: item);
                },
              ),
              const SizedBox(height: 20),
              // Total Price
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Total Price: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.coklat2,
                    ),
                  ),
                  Text(
                    'Rp${formatPrice(order.totalPrice)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.coklat1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    text: 'Leave a Review',
                    onPressed: () {
                      // Implement navigation to review page or show review dialog
                      showToast(context, 'Navigate to review page.',
                          type: ToastType.success);
                    },
                    width: 150,
                    height: 50.0,
                    backgroundColor: AppColors.coklat1,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  ),
                  CustomButton(
                    text: 'Reorder',
                    onPressed: () {
                      // Implement reorder functionality
                      showToast(
                          context, 'Reorder functionality not implemented.',
                          type: ToastType.alert);
                    },
                    width: 150,
                    height: 50.0,
                    backgroundColor: AppColors.coklat2,
                    textColor: Colors.white,
                    fontSize: 16.0,
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

class OrderItemWidget extends StatelessWidget {
  final Item item;

  const OrderItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(item.imageUrls.isNotEmpty
                      ? item.imageUrls[0]
                      : 'https://via.placeholder.com/80'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.coklat2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Category: ${item.category.replaceAll('_', ' ').toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Quantity: ${item.quantity}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Price
            Text(
              'Rp${formatPrice(item.price)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.coklat1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
