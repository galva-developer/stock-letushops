// ✅ Validation Utils
// Utilidades para validación de datos

class ValidationUtils {
  // Validar email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Validar contraseña
  static bool isValidPassword(String password) {
    // Al menos 8 caracteres, una mayúscula, una minúscula y un número
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  // Validar nombre de producto
  static bool isValidProductName(String name) {
    return name.trim().isNotEmpty && name.trim().length >= 2;
  }

  // Validar precio
  static bool isValidPrice(String price) {
    final priceValue = double.tryParse(price);
    return priceValue != null && priceValue > 0;
  }

  // Validar stock
  static bool isValidStock(String stock) {
    final stockValue = int.tryParse(stock);
    return stockValue != null && stockValue >= 0;
  }

  // Validar que no esté vacío
  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }

  // Validar longitud mínima
  static bool hasMinLength(String value, int minLength) {
    return value.trim().length >= minLength;
  }

  // Validar longitud máxima
  static bool hasMaxLength(String value, int maxLength) {
    return value.trim().length <= maxLength;
  }

  // Validar solo números
  static bool isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  // Validar código de barras
  static bool isValidBarcode(String barcode) {
    final barcodeRegex = RegExp(r'^\d{8,13}$');
    return barcodeRegex.hasMatch(barcode);
  }
}
