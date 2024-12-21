import 'package:batikin_mobile/screens/profile/order_detail_page.dart';
import 'package:batikin_mobile/utils/utils_function.dart';
import 'package:flutter/material.dart';
import 'package:batikin_mobile/models/order_model.dart';
import 'package:batikin_mobile/services/order_service.dart';
import 'package:batikin_mobile/utils/toast_util.dart';
import 'package:batikin_mobile/constants/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:batikin_mobile/widgets/custom_button.dart';
import 'package:carousel_slider/carousel_slider.dart';

// Define sorting options
enum SortOption {
  dateAsc,
  dateDesc,
  priceAsc,
  priceDesc,
}

class HistoryPemesananPage extends StatefulWidget {
  const HistoryPemesananPage({super.key});

  @override
  State<HistoryPemesananPage> createState() => _HistoryPemesananPageState();
}

class _HistoryPemesananPageState extends State<HistoryPemesananPage> {
  late Future<List<Order>> _orderFuture;
  SortOption _currentSortOption = SortOption.dateDesc; // Default sort option

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    final orderService = OrderService(request);
    _orderFuture = orderService.fetchOrderHistory();
    // Removed the local _count variable
  }

  // Method to sort orders based on the selected sort option
  void _sortOrders(List<Order> orders) {
    switch (_currentSortOption) {
      case SortOption.dateAsc:
        orders.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortOption.dateDesc:
        orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.priceAsc:
        orders.sort((a, b) => a.totalPrice.compareTo(b.totalPrice));
        break;
      case SortOption.priceDesc:
        orders.sort((a, b) => b.totalPrice.compareTo(a.totalPrice));
        break;
    }
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
        actions: [
          // Sorting Button
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort, color: AppColors.coklat2),
            onSelected: (SortOption result) {
              setState(() {
                _currentSortOption = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
              const PopupMenuItem<SortOption>(
                value: SortOption.dateAsc,
                child: Text('Sort by Date Ascending'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.dateDesc,
                child: Text('Sort by Date Descending'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.priceAsc,
                child: Text('Sort by Price Ascending'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.priceDesc,
                child: Text('Sort by Price Descending'),
              ),
            ],
          ),
        ],
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
            final orders = List<Order>.from(snapshot.data!);
            _sortOrders(orders); // Sort the orders based on the selected option

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final firstItem =
                    order.items.isNotEmpty ? order.items[0] : null;
                final additionalItemsCount = order.items.length - 1;

                if (firstItem == null) {
                  return const SizedBox.shrink(); // Skip rendering if no items
                }

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
                      // Order Header: Date and Sequential Order Number
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order #${index + 1}',
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
                        height: 300,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailPage(
                                      order: order, count: index + 1),
                                ),
                              );
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
                          OutlinedButton(
                            onPressed: () {
                              showToast(
                                context,
                                'Fitur belum tersedia',
                                type: ToastType.alert, // Changed to alert
                                gravity: ToastGravity.BOTTOM_RIGHT,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.coklat2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            child: const Text(
                              'Ulas',
                              style: TextStyle(
                                color: AppColors.coklat2,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

  // Updated showOrderDetails to accept sequential count if needed
  void showOrderDetails(BuildContext context, Order order, int count) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order #$count Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Price: Rp${formatPrice(order.totalPrice)}',
                    style: TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                Text(
                    'Address: ${order.address.title}, ${order.address.address}',
                    style: TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                const Text(
                  'Items:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                ...order.items.map((item) => ListTile(
                      leading: Image.network(
                        item.imageUrls.isNotEmpty
                            ? item.imageUrls[0]
                            : 'https://via.placeholder.com/100',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item.productName,
                          style: TextStyle(fontSize: 14)),
                      subtitle: Text('Quantity: ${item.quantity}',
                          style: TextStyle(fontSize: 14)),
                      trailing: Text('Rp${formatPrice(item.price)}',
                          style: TextStyle(fontSize: 14)),
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
