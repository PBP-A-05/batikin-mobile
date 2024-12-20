import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:batikin_mobile/models/product_detail.dart';
import 'package:batikin_mobile/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:batikin_mobile/screens/cart/display_cart.dart'; 
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:batikin_mobile/services/cart_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:batikin_mobile/config/config.dart';

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
        Uri.parse('${Config.baseUrl}/shopping/json/${widget.productId}/'),
      );
      if (response.statusCode == 200) {
        final products = productDetailFromJson(response.body);
        setState(() {
          product = products
              .first; 
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
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child:
                    SizedBox(height: kToolbarHeight + 32), 
              ),

              SliverToBoxAdapter(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width *
                          0.8, 
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
                        ), 
                        itemCount: product!.fields.imageUrls.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    product!.fields.imageUrls[index]),
                                fit: BoxFit.contain, 
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: product!.fields.imageUrls
                            .asMap()
                            .entries
                            .map((entry) {
                          return Container(
                            width: 6.0, 
                            height: 6.0, 
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

              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                            height: 32), 
                        _buildCategoryLabel(product!.fields.category),
                        const SizedBox(height: 12), 

                        Text(
                          product!.fields.productName,
                          style: GoogleFonts.poppins(
                            fontSize: 16, 
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
                                fontSize: 18,
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

                        const SizedBox(height: 24), 
                        const Divider(color: Color(0xFFDCD2C2)),
                        const SizedBox(height: 16), 
                        _buildExpandableDescription(),
                        const SizedBox(height: 16), 
                        const Divider(
                            color: Color(0xFFDCD2C2)), 
                        const SizedBox(height: 32), 
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          _buildAppBar(),

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
                    MaterialPageRoute(
                        builder: (context) => const DisplayCart()),
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
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 4), 
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.coklat1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        _getCategoryDisplayName(category),
        style: GoogleFonts.poppins(
          fontSize: 11, 
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
        onTap: () {
          if (label == 'Kunjungi Toko') {
            _showVisitStoreDialog();
          } else {
            onTap();
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 4), 
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDCD2C2)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 14,
                  color: AppColors.coklat3.withOpacity(0.5)), 
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11, 
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
          onTap: () =>
              setState(() => isDescriptionExpanded = !isDescriptionExpanded),
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
    final priceString = product!.fields.price.replaceAll(RegExp(r'[^0-9]'), '');
    final price = double.tryParse(priceString) ?? 0;
    final totalPrice = price * quantity;
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
            onPressed: () async {
              final request =
                  Provider.of<CookieRequest>(context, listen: false);
              final cartService = CartService(request);

              try {
                final response = await cartService.addToCart(
                  product!.pk,
                  quantity,
                );

                if (response.status == "success") {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "$quantity produk berhasil dimasukkan ke keranjang!"),
                      backgroundColor: AppColors.coklat2,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Gagal menambahkan ke keranjang"),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
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

  void _showVisitStoreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kunjungi Toko',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.coklat2,
                  ),
                ),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Anda akan diarahkan ke halaman toko. Lanjutkan?',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.coklat1,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Batal',
                        style: GoogleFonts.poppins(
                          color: AppColors.coklat1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _launchURL(product!.fields.storeUrl);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: AppColors.bgGradientCoklat,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Text(
                            'Ya, Lanjutkan',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tidak dapat membuka halaman toko',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
