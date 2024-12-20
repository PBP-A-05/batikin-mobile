import 'package:flutter/material.dart';
import 'package:batikin_mobile/constants/colors.dart';
import 'package:batikin_mobile/constants/fonts.dart';
import 'package:batikin_mobile/constants/image_strings.dart';
import 'package:batikin_mobile/screens/shopping/display_product.dart';
import 'package:batikin_mobile/screens/cart/display_cart.dart'; 
import 'package:google_fonts/google_fonts.dart';
import 'package:batikin_mobile/screens/profile/profile_screen.dart';
import 'package:batikin_mobile/constants/colors.dart'; 
import 'package:http/http.dart' as http;
import 'package:batikin_mobile/models/product.dart';
import 'package:batikin_mobile/screens/shopping/display_product_detail.dart';
import 'package:batikin_mobile/config/config.dart';

class MyHomePage extends StatefulWidget {
  final String username;

  const MyHomePage({super.key, required this.username});

  @override
  _MyHomePageState createState() => _MyHomePageState();
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
      return 'Lainnya';
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.8);

  List<Product> recommendedProducts = [];
  bool isLoadingRecommendations = true;

  @override
  void initState() {
    super.initState();
    fetchRecommendedProducts();
  }

  Future<void> fetchRecommendedProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/shopping/json/'), 
      );
      if (response.statusCode == 200) {
        final allProducts = productFromJson(response.body);
        
        final categorizedProducts = {
          'pakaian_pria': [],
          'pakaian_wanita': [],
          'aksesoris': [],
        };

        for (var product in allProducts) {
          categorizedProducts[product.fields.category]?.add(product);
        }

        final randomProducts = [];
        categorizedProducts.forEach((category, products) {
          products.shuffle();
          randomProducts.addAll(products.take(3));
        });
        
        randomProducts.shuffle();

        setState(() {
          recommendedProducts = randomProducts.cast<Product>();
          isLoadingRecommendations = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingRecommendations = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 56),

                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 255, 
                  child: Stack(
                    children: [
                      Image.asset(
                        ImageStrings.selamatDatang,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        left: 16,
                        bottom: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.username.isEmpty || widget.username == 'test') ...[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Eksplorasi Yogyakarta',
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'bersama Batikin.',
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(context, '/profile');
                                      },
                                      borderRadius: BorderRadius.circular(30),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white, width: 2),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: Text(
                                          'Daftar sekarang',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ] else ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.baseline, 
                                textBaseline: TextBaseline.alphabetic, 
                                children: [
                                  Text(
                                    'Selamat datang, ',
                                    style: TextStyle(
                                      fontFamily: AppFonts.javaneseText,
                                      fontSize: 22, 
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${widget.username}.',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22, 
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Jelajahi keindahan batik Yogyakarta.',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              foreground: Paint()
                                ..shader =
                                    AppColors.bgGradientCoklat.createShader(
                                  const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                                ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: const Color(0xFFDCD2C2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Di mana kreasi dan tradisi berpadu dalam setiap helai.',
                        style: TextStyle(
                          fontFamily: AppFonts.javaneseText,
                          fontSize: 14,
                          color: AppColors.coklat2,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), 
                  child: SizedBox(
                    height: 136, 
                    child: PageView(
                      controller: _pageController,
                      padEnds: false,
                      clipBehavior: Clip.none,
                      children: [
                        _buildCategoryCard(
                          ImageStrings.temukanPria,
                          'Temukan',
                          'Pakaian Pria',
                          context,
                          'pakaian_pria',
                        ),
                        _buildCategoryCard(
                          ImageStrings.temukanWanita,
                          'Temukan',
                          'Pakaian Wanita',
                          context,
                          'pakaian_wanita',
                        ),
                        _buildCategoryCard(
                          ImageStrings.temukanAksesoris,
                          'Temukan',
                          'Aksesoris',
                          context,
                          'aksesoris',
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  height: 180,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: Stack(
                    children: [
                      Image.asset(
                        ImageStrings.bookingWorkshop,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pelajari seni batik langsung dari tempatnya.',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rasakan kekayaan budaya Yogyakarta dalam setiap prosesnya.',
                                style: TextStyle(
                                  fontFamily: AppFonts.javaneseText,
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Booking Workshop',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.coklat1,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Rekomendasi untuk Anda',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              foreground: Paint()
                                ..shader = AppColors.bgGradientCoklat.createShader(
                                  const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                                ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: const Color(0xFFDCD2C2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Batik untuk setiap momen, temukan favoritmu di sini.',
                        style: TextStyle(
                          fontFamily: AppFonts.javaneseText,
                          fontSize: 14,
                          color: AppColors.coklat2,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (isLoadingRecommendations)
                        const Center(child: CircularProgressIndicator())
                      else
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, 
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 12, 
                            mainAxisSpacing: 12,
                          ),
                          itemCount: recommendedProducts.length + 1, 
                          itemBuilder: (context, index) {
                            if (index == recommendedProducts.length) {
                              
                              return Align( 
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center, 
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      shape: const CircleBorder(),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DisplayProduct(initialCategory: 'pakaian_wanita'), // Set default category
                                            ),
                                          );
                                        },
                                        customBorder: const CircleBorder(),
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.coklat1,
                                          ),
                                          child: const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Temukan lebih banyak!',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: AppColors.coklat1,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            final product = recommendedProducts[index];
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DisplayProductDetail(
                                        productId: product.pk,
                                      ),
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
                                          borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(4)
                                          ),
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
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(4)
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color(0xFFDCD2C2),
                                                  width: 1,
                                                ),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                _getCategoryDisplayName(product.fields.category),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 8,
                                                  color: AppColors.coklat3,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),

                                            Text(
                                              product.fields.productName,
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.coklat1,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
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
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).padding.top + 56,
              color: Colors.white,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top), 
              child: Center( 
                child: Text(
                  'Batikin',
                  style: TextStyle(
                    fontFamily: AppFonts.javaneseText,
                    fontSize: 24,
                    color: AppColors.coklat1,
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
              if (index == 2) {
                Navigator.pushNamed(context, '/cart');
              } else {
                setState(() {
                  _currentIndex = index;
                });
              }
              if (index == 3) {
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

  Widget _buildCategoryCard(String imagePath, String title1, String title2,
      BuildContext context, String category) {
    return Container(
      margin: const EdgeInsets.only(right: 4), 
      width: MediaQuery.of(context).size.width * 0.5, 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayProduct(initialCategory: category),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title1,
                        style: TextStyle(
                          fontFamily: AppFonts.javaneseText,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        title2,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
