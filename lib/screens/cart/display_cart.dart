import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:batikin_mobile/services/cart_service.dart';
import 'package:batikin_mobile/models/view_cart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:batikin_mobile/constants/colors.dart';

class DisplayCart extends StatefulWidget {
  const DisplayCart({super.key});

  @override
  State<DisplayCart> createState() => _DisplayCartState();
}

class _DisplayCartState extends State<DisplayCart> {
  Map<int, bool> selectedItems = {};
  double totalPrice = 0;
  final String baseUrl = 'http://127.0.0.1:8000';
  ViewCart? cartData;
  bool isLoading = true;
  String _selectedSort = '';
  final List<Map<String, dynamic>> _sortOptions = [
    {'value': '', 'label': 'Urutkan berdasarkan', 'disabled': 'true'},
    {
      'value': 'added',
      'label': 'Waktu Ditambahkan (Terbaru)',
      'disabled': 'false'
    },
    {'value': 'men', 'label': 'Kategori Pakaian Pria', 'disabled': 'false'},
    {'value': 'women', 'label': 'Kategori Pakaian Wanita', 'disabled': 'false'},
    {
      'value': 'accessories',
      'label': 'Kategori Aksesoris',
      'disabled': 'false'
    },
  ];

  @override
  void initState() {
    super.initState();
    loadCartData();
  }

  Future<void> loadCartData() async {
    final request = context.read<CookieRequest>();
    try {
      final cart = await CartService(request).viewCart();
      setState(() {
        cartData = cart;
        isLoading = false;
      });
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading cart: $e")),
      );
    }
  }

  void updateTotalPrice(List<CartItem> items) {
    double total = 0;
    for (var item in items) {
      if (selectedItems[item.id] == true) {
        final priceString = item.price.replaceAll(RegExp(r'[^0-9]'), '');
        final price = double.tryParse(priceString) ?? 0;
        total += price * item.quantity;
      }
    }
    setState(() {
      totalPrice = total;
    });
  }

  Future<void> handleQuantityChange(CartItem item, bool increment) async {
    final request = context.read<CookieRequest>();
    int newQuantity = increment ? item.quantity + 1 : item.quantity - 1;

    if (newQuantity < 1) return;

    try {
      final response = await request.post(
        '$baseUrl/cart/api/update/${item.id}/',
        {
          'quantity': newQuantity.toString(),
        },
      );

      if (response['status'] == 'success') {
        setState(() {
          final index =
              cartData!.data.cartItems.indexWhere((i) => i.id == item.id);
          if (index != -1) {
            cartData!.data.cartItems[index].quantity = newQuantity;
            updateTotalPrice(cartData!.data.cartItems);
          }
        });
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Gagal mengupdate jumlah"),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> handleRemoveItem(int itemId) async {
    final request = context.read<CookieRequest>();

    try {
      final response = await request.post(
        '$baseUrl/cart/api/remove/$itemId/',
        {},
      );

      if (response['status'] == 'success') {
        setState(() {
          cartData!.data.cartItems.removeWhere((item) => item.id == itemId);
          selectedItems.remove(itemId);
          updateTotalPrice(cartData!.data.cartItems);
        });
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Gagal menghapus item"),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> handleSort(String sortBy) async {
    setState(() {
      isLoading = true;
      _selectedSort = sortBy;
    });

    final request = context.read<CookieRequest>();
    try {
      final cart = await CartService(request).sortCart(sortBy);
      setState(() {
        cartData = cart;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sorting cart: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor:
            Colors.white, 
        elevation: 2,
        shadowColor: AppColors.coklat1.withOpacity(0.15),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: AppColors.coklat1, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border,
                color: AppColors.coklat1, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person, color: AppColors.coklat1, size: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartData == null || cartData!.data.cartItems.isEmpty
              ? const Center(child: Text('Belum ada item di keranjang!'))
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
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
                              color: Colors.white,
                              border: Border.all(color: AppColors.coklat1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: PopupMenuButton<String>(
                              color: Colors
                                  .white, 
                              onSelected: (value) {
                                if (value.isNotEmpty) {
                                  handleSort(value);
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return _sortOptions.map((option) {
                                  return PopupMenuItem<String>(
                                    value: option['value']!,
                                    enabled: option['disabled'] == 'false',
                                    child: Container(
                                      color: Colors
                                          .white, 
                                      child: Text(
                                        option['label']!,
                                        style: GoogleFonts.poppins(
                                          color: option['disabled'] == 'true'
                                              ? Colors.grey
                                              : AppColors.coklat3,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _selectedSort.isEmpty
                                          ? 'Urutkan berdasarkan'
                                          : _sortOptions.firstWhere((option) =>
                                              option['value'] ==
                                              _selectedSort)['label']!,
                                      style: GoogleFonts.poppins(
                                        color: AppColors.coklat3,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down,
                                        color: AppColors.coklat3),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: cartData!.data.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartData!.data.cartItems[index];
                          selectedItems.putIfAbsent(item.id, () => false);

                          return Dismissible(
                            key: Key(item.id.toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              handleRemoveItem(item.id);
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Card(
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
                                      value: selectedItems[item.id] ?? false,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          selectedItems[item.id] =
                                              value ?? false;
                                          updateTotalPrice(
                                              cartData!.data.cartItems);
                                        });
                                      },
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              border: Border.all(
                                                  color: AppColors.coklat1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              _getCategoryDisplayName(
                                                  item.category),
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                color: AppColors.coklat2,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                    icon: const Icon(
                                                        Icons.delete_outline),
                                                    onPressed: () =>
                                                        handleRemoveItem(
                                                            item.id),
                                                    color: AppColors.coklat2,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: AppColors
                                                              .coklat1
                                                              .withOpacity(
                                                                  0.25)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.remove),
                                                          onPressed: item
                                                                      .quantity >
                                                                  1
                                                              ? () =>
                                                                  handleQuantityChange(
                                                                      item,
                                                                      false)
                                                              : null,
                                                          color:
                                                              AppColors.coklat2,
                                                        ),
                                                        Text(
                                                          '${item.quantity}',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: AppColors
                                                                .coklat2,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.add),
                                                          onPressed: () =>
                                                              handleQuantityChange(
                                                                  item, true),
                                                          color:
                                                              AppColors.coklat2,
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
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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
              Text(
                'Rp${_formatNumber(totalPrice.toStringAsFixed(0))}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
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
