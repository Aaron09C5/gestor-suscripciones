import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyFormatter {
  static String _symbol = '\$';

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _symbol = prefs.getString('currency_symbol') ?? '\$';
  }

  static Future<void> updateSymbol(String symbol) async {
    _symbol = symbol;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency_symbol', symbol);
  }

  static String format(double amount) {
    return NumberFormat.currency(
      symbol: _symbol,
      decimalDigits: 2,
      // Forzamos el patrón básico para que el símbolo dinámico se vea bien,
      // ej. \$100.00, €100.00
      customPattern: '$_symbol#,##0.00',
    ).format(amount);
  }
}
