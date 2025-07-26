// 📊 Format Utils
// Utilidades para formateo de datos

import 'package:intl/intl.dart';

class FormatUtils {
  // Formatear precio
  static String formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'es_ES',
      symbol: '€',
      decimalDigits: 2,
    );
    return formatter.format(price);
  }

  // Formatear número con separadores de miles
  static String formatNumber(int number) {
    final formatter = NumberFormat('#,##0', 'es_ES');
    return formatter.format(number);
  }

  // Formatear porcentaje
  static String formatPercentage(double value) {
    final formatter = NumberFormat.percentPattern('es_ES');
    return formatter.format(value / 100);
  }

  // Capitalizar primera letra
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Capitalizar cada palabra
  static String capitalizeWords(String text) {
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  // Formatear tamaño de archivo
  static String formatFileSize(int bytes) {
    const units = ['B', 'KB', 'MB', 'GB'];
    double size = bytes.toDouble();
    int unitIndex = 0;

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.toStringAsFixed(1)} ${units[unitIndex]}';
  }

  // Truncar texto
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Formatear duración
  static String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
