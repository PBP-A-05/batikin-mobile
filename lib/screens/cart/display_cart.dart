import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:batikin_mobile/services/cart_service.dart';
import 'package:batikin_mobile/models/view_cart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:batikin_mobile/constant/colors.dart';

class DisplayCart extends StatefulWidget {
  const DisplayCart({super.key});

  @override
  State<DisplayCart> createState() => _DisplayCartState();
}

class _DisplayCartState extends State<DisplayCart> {
  String? selectedSort;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final cartService = CartService(request);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: AppColors.coklat1.withOpacity(0.15),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.coklat1, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.coklat1, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person, color: AppColors.coklat1, size: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<ViewCart>(
        future: cartService.viewCart(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.data.cartItems.isEmpty) {
            return const Center(child: Text('Keranjang kosong'));
          }

          final cart = snapshot.data!;
          
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Keranjang',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.coklat2,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.coklat1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: Text(
                          'Urutkan berdasarkan',
                          style: GoogleFonts.poppins(
                            color: AppColors.coklat2,
                            fontSize: 12,
                          ),
                        ),
                        label: Icon(Icons.arrow_drop_down, color: AppColors.coklat2),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.data.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cart.data.cartItems[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: AppColors.coklat1.withOpacity(0.25),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (value) {},
                              activeColor: AppColors.coklat2,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.imageUrls[0],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.coklat3,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.coklat1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _getCategoryDisplayName(item.category),
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: AppColors.coklat2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Rp${_formatNumber(item.price)}',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.coklat2,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.delete_outline, color: AppColors.coklat2),
                                            onPressed: () {},
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: AppColors.coklat1.withOpacity(0.25)),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.remove, color: AppColors.coklat2),
                                                  onPressed: () {},
                                                ),
                                                Text(
                                                  '${item.quantity}',
                                                  style: GoogleFonts.poppins(
                                                    color: AppColors.coklat2,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.add, color: AppColors.coklat2),
                                                  onPressed: () {},
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 32,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            gradient: AppColors.bgGradientCoklat,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder<ViewCart>(
                future: cartService.viewCart(),
                builder: (context, snapshot) {
                  final price = snapshot.data?.data.totalPrice ?? "0";
                  return Text(
                    'Rp${_formatNumber(price)}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              Text(
                'Beli sekarang!',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'pakaian_pria':
        return 'Pakaian Pria';
      case 'pakaian_wanita':
        return 'Pakaian Wanita';
      case 'aksesoris':
        return 'Aksesoris';
      default:
        return category;
    }
  }

  String _formatNumber(String number) {
    final cleanNumber = number.replaceAll(RegExp(r'[^0-9]'), '');
    
    final value = double.tryParse(cleanNumber) ?? 0;
    final parts = value.toStringAsFixed(0).split('');
    final formattedParts = <String>[];
    
    for (var i = parts.length - 1, count = 0; i >= 0; i--, count++) {
      if (count > 0 && count % 3 == 0) {
        formattedParts.insert(0, '.');
      }
      formattedParts.insert(0, parts[i]);
    }
    
    return formattedParts.join('');
  }
}