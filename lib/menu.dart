import 'package:flutter/material.dart';
import 'package:batikin_mobile/constant/colors.dart';
import 'package:batikin_mobile/constant/fonts.dart';
import 'package:batikin_mobile/constant/image_strings.dart';
import 'package:batikin_mobile/screens/shopping/display_product.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  final String username;

  const MyHomePage({super.key, required this.username});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.8);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selamat datang, ${widget.username}!'),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Spacing untuk header
                SizedBox(height: MediaQuery.of(context).padding.top + 56),
                
                // Welcome Section dengan Image
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
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
                            Text(
                              'Selamat datang,',
                              style: TextStyle(
                                fontFamily: AppFonts.javaneseText,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              widget.username,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Description Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Jelajahi keindahan batik Yogyakarta.',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                foreground: Paint()..shader = AppColors.bgGradientCoklat.createShader(
                                  const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 1,
                            color: const Color(0xFFDCD2C2),
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

                // Product Categories Slider
                SizedBox(
                  height: 160,
                  child: PageView(
                    controller: _pageController,
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

                // Workshop Section
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
              ],
            ),
          ),

          // App Header (on top of everything)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).padding.top + 56,
              color: Colors.white,
              child: Align(
                alignment: Alignment.center,
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
              setState(() {
                _currentIndex = index;
              });
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

  Widget _buildCategoryCard(String imagePath, String title1, String title2, BuildContext context, String category) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: MediaQuery.of(context).size.width * 0.7,
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