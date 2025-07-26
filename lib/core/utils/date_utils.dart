// 📅 Date Utils
// Utilidades para manejo de fechas y tiempo

class DateUtils {
  // Formatear fecha para mostrar
  static String formatDateForDisplay(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Formatear fecha y hora para mostrar
  static String formatDateTimeForDisplay(DateTime dateTime) {
    return '${formatDateForDisplay(dateTime)} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Obtener fecha de hoy
  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  // Verificar si es hoy
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Calcular días transcurridos
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}
