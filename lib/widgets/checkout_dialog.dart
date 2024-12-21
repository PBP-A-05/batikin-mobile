import 'package:flutter/material.dart';
import 'package:batikin_mobile/constants/colors.dart';
import 'package:batikin_mobile/models/view_cart.dart';
import 'package:batikin_mobile/services/cart_service.dart';
import 'package:batikin_mobile/models/address.dart'; 
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:batikin_mobile/utils/toast_util.dart';

class CheckoutDialog extends StatefulWidget {
  final List<CartItem> selectedItems;
  final double totalPrice;

  const CheckoutDialog({
    Key? key,
    required this.selectedItems,
    required this.totalPrice,
  }) : super(key: key);

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  int? selectedAddressId;
  List<AddressElement> addresses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    final request = context.read<CookieRequest>();
    try {
      final addressData = await CartService(request).getAddresses();
      setState(() {
        addresses = addressData.addresses;
        isLoading = false;
      });
    } catch (e) {
      if (!context.mounted) return;
      showToast(
        context,
        'Gagal memuat alamat: $e',
        type: ToastType.alert,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> createOrder() async {
    if (selectedAddressId == null) return;

    final request = context.read<CookieRequest>();
    final items = widget.selectedItems.map((item) => {
      'product_id': item.productId,
      'quantity': item.quantity,
      'price': item.price.replaceAll(RegExp(r'[^0-9]'), ''),
    }).toList();

    try {
      final response = await CartService(request).createOrder(selectedAddressId!, items);
      
      if (!context.mounted) return;
      if (response.status == 'success') {
        Navigator.of(context).pop(true);
        showToast(
          context,
          'Pesanan berhasil dibuat!',
          type: ToastType.success,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      showToast(
        context,
        'Error creating order: $e',
        type: ToastType.alert,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 3500), 
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2), 
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.elasticOut, 
                reverseCurve: Curves.easeInBack,
              ),
            ),
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            ),
          );
        },
        child: SingleChildScrollView(
          key: const ValueKey<String>('dialog_content'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ringkasan Pemesanan',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.coklat2,
                  ),
                ),
                const Divider(),
                ...widget.selectedItems.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(item.imageUrls[0], width: 50, height: 50),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productName,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.coklat3,
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
                            Text(
                              '${item.quantity} item',
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Rp${_formatNumber(item.price)}', 
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: AppColors.coklat1, 
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rp${_formatNumber(widget.totalPrice.toStringAsFixed(0))}',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.coklat2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Pilih Alamat Pengiriman',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (addresses.isEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Anda belum memiliki alamat.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.coklat3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/profile');
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.bgGradientCoklat,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Tambah alamat',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Column(
                      children: addresses.map((address) => Theme(
                        data: Theme.of(context).copyWith(
                          radioTheme: RadioThemeData(
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        child: RadioListTile<int>(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            address.title,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            address.address,
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                          value: address.id,
                          groupValue: selectedAddressId,
                          onChanged: (value) {
                            setState(() {
                              selectedAddressId = value;
                            });
                          },
                        ),
                      )).toList(),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Batal',
                        style: GoogleFonts.poppins(color: AppColors.coklat1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: addresses.isEmpty || selectedAddressId == null
                          ? null
                          : createOrder,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero, 
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: addresses.isEmpty || selectedAddressId == null
                              ? null
                              : AppColors.bgGradientCoklat,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16, 
                            vertical: 8,    
                          ),
                          child: Text(
                            'Buat Pesanan',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,    
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
        ),
      ),
    );
  }
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
  return number.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
}