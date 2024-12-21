import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:batikin_mobile/models/product.dart';
import 'package:batikin_mobile/constants/colors.dart';
import 'package:batikin_mobile/constants/fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:batikin_mobile/screens/shopping/display_product_detail.dart';
import 'package:batikin_mobile/screens/cart/display_cart.dart'; 
import 'package:batikin_mobile/services/product_service.dart';
import 'package:batikin_mobile/utils/toast_util.dart';

class DisplayProduct extends StatefulWidget {
  final String initialCategory;

  const DisplayProduct({super.key, required this.initialCategory});

  @override
  State<DisplayProduct> createState() => _DisplayProductState();
}

class _DisplayProductState extends State<DisplayProduct>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentIndex = 0;
  List<Product> products = [];
  bool isLoading = true;
  late String selectedCategory;
  final ProductService _productService = ProductService();
  late String username;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      username = ModalRoute.of(context)?.settings.arguments as String? ?? '';
    });
    selectedCategory = widget.initialCategory;
    fetchProducts();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await _productService.fetchProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Product> getFilteredProducts() {
    return products
        .where((product) => product.fields.category == selectedCategory)
        .toList();
  }

  void _showLoginRequiredToast(String feature) {
    showToast(
      context,
      'Masuk ke Batikin untuk melihat $feature!',
      type: ToastType.alert,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(height: kToolbarHeight + 20),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Koleksi Batikin',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.coklat2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: const Color(0xFFDCD2C2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Temukan keindahan batik Yogyakarta yang kaya makna di sini.',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.coklat3,
                        ),
                      ),
                      const SizedBox(height: 16),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          width: MediaQuery.of(context)
                              .size
                              .width, 
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center, 
                            children: [
                              _buildFilterButton(
                                  'pakaian_pria', 'Pakaian Pria'),
                              const SizedBox(width: 40),
                              _buildFilterButton(
                                  'pakaian_wanita', 'Pakaian Wanita'),
                              const SizedBox(width: 40),
                              _buildFilterButton('aksesoris', 'Aksesoris'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final products = getFilteredProducts();
                      if (index >= products.length) return null;
                      return FadeTransition(
                        opacity: _animation,
                        child: _buildProductCard(products[index]),
                      );
                    },
                    childCount: isLoading ? 4 : getFilteredProducts().length,
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.coklat1.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: kToolbarHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Back Arrow
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: AppColors.coklat1),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      // Center Title
                      Text(
                        'Batikin',
                        style: TextStyle(
                          fontFamily: AppFonts.javaneseText,
                          fontSize: 24,
                          color: AppColors.coklat1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              if (username.isEmpty || username == 'test') {
                if (index == 2) {
                  _showLoginRequiredToast('keranjang');
                  return;
                }
              }
              
              if (index == 2) {
                Navigator.pushNamed(context, '/cart');
              } else if (index == 3) {
                Navigator.pushNamed(context, '/profile');
              } else {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.coklat3,
            unselectedItemColor: AppColors.coklat1Rgba,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: 'Wishlist',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String category, String label) {
    final isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
        _controller.reset();
        _controller.forward();
      },
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: AppColors.coklat2,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: 3,
            width: 80,
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.bgGradientCoklat : null,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (username.isEmpty || username == 'test') {
            _showLoginRequiredToast('detail produk');
            return;
          }
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayProductDetail(
                productId: product.pk,
              ),
              settings: RouteSettings(arguments: username), // Use stored username
            ),
          );
        },
        borderRadius: BorderRadius.circular(4),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all( 
              color: AppColors.coklat1.withOpacity(0.25),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                  child: Image.network(
                    product.fields.imageUrls[0],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFFDCD2C2), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getCategoryDisplayName(product.fields.category),
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: AppColors.coklat3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      product.fields.productName,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.coklat1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.fields.price,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.coklat2,
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.favorite_border,
                                size: 20,
                                color: Color(0xFFDCD2C2),
                              ),
                            ),
                          ),
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
}
