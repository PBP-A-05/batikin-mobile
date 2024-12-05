// lib/screens/profile/history_pemesanan_page.dart
import 'package:batikin_mobile/screens/profile/order_detail_page.dart';
import 'package:batikin_mobile/utils/utils_function.dart';
import 'package:flutter/material.dart';
import 'package:batikin_mobile/models/order_model.dart';
import 'package:batikin_mobile/services/order_service.dart';
import 'package:batikin_mobile/utils/toast_util.dart';
import 'package:batikin_mobile/constants/colors.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:batikin_mobile/widgets/custom_button.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HistoryPemesananPage extends StatefulWidget {
  const HistoryPemesananPage({super.key});

  @override
  State<HistoryPemesananPage> createState() => _HistoryPemesananPageState();
}

class _HistoryPemesananPageState extends State<HistoryPemesananPage> {
  late Future<List<Order>> _orderFuture;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    final orderService = OrderService(request);
    _orderFuture = orderService.fetchOrderHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History Pemesanan',
          style: TextStyle(
            color: AppColors.coklat2,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.coklat2,
      ),
      body: FutureBuilder<List<Order>>(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: TextStyle(color: AppColors.coklat2)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No orders found.',
                  style: TextStyle(color: AppColors.coklat2)),
            );
          } else {
            final orders = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final firstItem = order.items[0];
                final additionalItemsCount = order.items.length - 1;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF4ED),
                    border:
                        Border.all(color: AppColors.coklat1Rgba, width: 0.2),
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Header: Date and Order ID
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order #${order.orderId}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.coklat2,
                            ),
                          ),
                          Text(
                            formatDate(order.createdAt),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Item Image
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(firstItem.imageUrls.isNotEmpty
                                ? firstItem.imageUrls[0]
                                : 'https://via.placeholder.com/150'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Product Name and Additional Items
                      Text(
                        firstItem.productName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.coklat2,
                        ),
                      ),
                      if (additionalItemsCount > 0)
                        Text(
                          '+$additionalItemsCount produk lainnya',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.coklat3,
                          ),
                        ),
                      const SizedBox(height: 8),
                      // Total Price
                      Text(
                        'Rp${formatPrice(order.totalPrice)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.coklat2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Buttons: Lihat Detail Pemesanan & Ulas
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              showOrderDetails(context, order);
                            },
                            child: Text(
                              'Lihat Detail Pemesanan',
                              style: TextStyle(
                                color: AppColors.coklat2,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CustomButton(
                            text: 'Ulas',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OrderDetailPage(order: order),
                                ),
                              );
                            },
                            width: 80,
                            height: 35,
                            backgroundColor: AppColors.coklat1,
                            textColor: Colors.white,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void showOrderDetails(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order #${order.orderId} Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Price: Rp${formatPrice(order.totalPrice)}'),
                const SizedBox(height: 8),
                Text(
                    'Address: ${order.address.title}, ${order.address.address}'),
                const SizedBox(height: 8),
                const Text(
                  'Items:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...order.items.map((item) => ListTile(
                      leading: Image.network(
                        item.imageUrls.isNotEmpty
                            ? item.imageUrls[0]
                            : 'https://via.placeholder.com/50',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item.productName),
                      subtitle: Text('Quantity: ${item.quantity}'),
                      trailing: Text('Rp${formatPrice(item.price)}'),
                    )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
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
