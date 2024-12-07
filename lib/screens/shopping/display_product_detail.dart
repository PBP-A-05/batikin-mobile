import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:batikin_mobile/models/product_detail.dart';
import 'package:batikin_mobile/constant/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:batikin_mobile/screens/cart/display_cart.dart'; // Import the cart page

class DisplayProductDetail extends StatefulWidget {
  final String productId;

  const DisplayProductDetail({super.key, required this.productId});

  @override
  State<DisplayProductDetail> createState() => _DisplayProductDetailState();
}

class _DisplayProductDetailState extends State<DisplayProductDetail> {
  ProductDetail? product;
  bool isLoading = true;
  bool isDescriptionExpanded = true;
  int quantity = 1;
  bool isLiked = false;
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchProductDetail();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchProductDetail() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/shopping/json/${widget.productId}/'),
      );
      if (response.statusCode == 200) {
        final products = productDetailFromJson(response.body);
        setState(() {
          product = products.first; // Mengambil item pertama karena API mengembalikan list
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text('Product not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main Content
          CustomScrollView(
            slivers: [
              // Spacing for AppBar with increased gap
              const SliverToBoxAdapter(
                child: SizedBox(height: kToolbarHeight + 32), // Increased spacing
              ),

              // Product Image with adjusted size
              SliverToBoxAdapter(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width * 0.8, // Reduced height
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        physics: const PageScrollPhysics().applyTo(
                          const BouncingScrollPhysics(
                            decelerationRate: ScrollDecelerationRate.fast,
                          ),
                        ), // Adjusted scroll physics
                        itemCount: product!.fields.imageUrls.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(product!.fields.imageUrls[index]),
                                fit: BoxFit.contain, // Changed to contain
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Dots Indicator
                    Positioned(
                      bottom: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: product!.fields.imageUrls.asMap().entries.map((entry) {
                          return Container(
                            width: 6.0, // Smaller dots
                            height: 6.0, // Smaller dots
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(
                                _currentImageIndex == entry.key ? 0.9 : 0.4,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // Product Details with adjusted spacing
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32), // Increased spacing significantly
                        _buildCategoryLabel(product!.fields.category),
                        const SizedBox(height: 12), // Increased spacing

                        Text(
                          product!.fields.productName,
                          style: GoogleFonts.poppins(
                            fontSize: 16, // Reduced font size
                            fontWeight: FontWeight.w600,
                            color: AppColors.coklat1,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Text(
                              product!.fields.price,
                              style: GoogleFonts.poppins(
                                fontSize: 18, // Reduced font size
                                fontWeight: FontWeight.bold,
                                color: AppColors.coklat2,
                              ),
                            ),
                            const Spacer(),
                            _buildStoreButton(
                              icon: Icons.store,
                              label: 'Kunjungi Toko',
                              onTap: () {/* Implement */},
                            ),
                            const SizedBox(width: 8),
                            _buildStoreButton(
                              icon: Icons.location_on,
                              label: 'Kabupaten Jogja',
                              onTap: () {/* Implement */},
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Like and Quantity Controls
                        Row(
                          children: [
                            _buildLikeButton(),
                            const SizedBox(width: 16),
                            _buildQuantityControls(),
                            const Spacer(),
                            _buildRatingStars(),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Updated Description Section
                        const SizedBox(height: 24), // Increased spacing
                        const Divider(color: Color(0xFFDCD2C2)),
                        const SizedBox(height: 16), // Added spacing
                        _buildExpandableDescription(),
                        const SizedBox(height: 16), // Added spacing
                        const Divider(color: Color(0xFFDCD2C2)), // Added bottom divider
                        const SizedBox(height: 32), // Added bottom spacing
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Fixed AppBar
          _buildAppBar(),

          // Floating Action Button
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildFloatingActionButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
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
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.coklat1),
                onPressed: () => Navigator.pop(context),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.favorite_border, color: AppColors.coklat1),
                onPressed: () {/* Implement wishlist */},
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart, color: AppColors.coklat1),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DisplayCart()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: AppColors.coklat1),
                onPressed: () {/* Implement profile */},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryLabel(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Smaller padding
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.coklat1),
        borderRadius: BorderRadius.circular(16), // Smaller radius
      ),
      child: Text(
        _getCategoryDisplayName(category),
        style: GoogleFonts.poppins(
          fontSize: 11, // Smaller font size
          color: AppColors.coklat3,
        ),
      ),
    );
  }

  Widget _buildStoreButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Smaller padding
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDCD2C2)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: AppColors.coklat3.withOpacity(0.5)), // Smaller icon
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11, // Smaller font size
                  color: AppColors.coklat3.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLikeButton() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.coklat1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              isLiked = !isLiked;
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : AppColors.coklat1,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControls() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.coklat1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildQuantityButton(
            icon: Icons.remove,
            onTap: () {
              if (quantity > 1) {
                setState(() => quantity--);
              }
            },
          ),
          Container(
            width: 40,
            alignment: Alignment.center,
            child: Text(
              quantity.toString(),
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.coklat1,
              ),
            ),
          ),
          _buildQuantityButton(
            icon: Icons.add,
            onTap: () => setState(() => quantity++),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 20, color: AppColors.coklat1),
        ),
      ),
    );
  }

  Widget _buildRatingStars() {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < 4 ? Icons.star : Icons.star_border,
          color: AppColors.coklat2,
          size: 20,
        );
      }),
    );
  }

  Widget _buildExpandableDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => isDescriptionExpanded = !isDescriptionExpanded),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Deskripsi Produk',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.coklat3,
                ),
              ),
              Icon(
                isDescriptionExpanded ? Icons.expand_less : Icons.expand_more,
                color: AppColors.coklat3,
              ),
            ],
          ),
        ),
        if (isDescriptionExpanded) ...[
          const SizedBox(height: 8),
          Text(
            product!.fields.additionalInfo,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.coklat2,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    // Parse price string to get numeric value
    final priceString = product!.fields.price.replaceAll(RegExp(r'[^0-9]'), '');
    final price = double.tryParse(priceString) ?? 0;
    final totalPrice = price * quantity;
    
    // Format price 
    final formattedPrice = 'Rp${_formatNumber(totalPrice)}';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            formattedPrice,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () {
              // Implement add to cart
            },
            child: Text(
              'Tambahkan ke Keranjang',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to format number with thousand separators
  String _formatNumber(double number) {
    final parts = number.toStringAsFixed(0).split('');
    final formattedParts = <String>[];
    for (var i = parts.length - 1, count = 0; i >= 0; i--, count++) {
      if (count > 0 && count % 3 == 0) {
        formattedParts.insert(0, '.');
      }
      formattedParts.insert(0, parts[i]);
    }
    return formattedParts.join('');
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