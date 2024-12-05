// lib/utils/utils.dart
String formatPrice(double price) {
  // Format the price with thousand separators
  String priceString = price.toStringAsFixed(0);
  RegExp reg = RegExp(r'(\d+)(\d{3})');
  String result = priceString;
  while (reg.hasMatch(result)) {
    result = result.replaceAllMapped(reg, (Match match) {
      return '${match[1]}.${match[2]}';
    });
  }
  return result;
}

String formatDate(DateTime date) {
  // Format the date as "DD/MM/YYYY HH:MM"
  return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
}
