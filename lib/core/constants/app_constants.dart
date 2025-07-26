// 🚀 App Constants
// Constantes generales de la aplicación LETUSHOPS Stock

class AppConstants {
  // Información de la App
  static const String appName = 'Stock LetuShops';
  static const String appVersion = '1.0.0';
  static const String companyName = 'LETUSHOPS';

  // Configuraciones
  static const int splashDuration = 3; // segundos
  static const int animationDuration = 300; // milisegundos
  static const int debounceDelay = 500; // milisegundos para búsquedas

  // Límites de la aplicación
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxProductsPerPage = 20;
  static const int maxSearchResults = 100;

  // Tiempo de caché
  static const Duration cacheExpiration = Duration(hours: 24);
  static const Duration sessionTimeout = Duration(hours: 8);

  // 📱 Responsive Design - Breakpoints
  static const double mobileBreakpoint = 480.0;
  static const double tabletBreakpoint = 768.0;
  static const double desktopBreakpoint = 1024.0;
  static const double largeDesktopBreakpoint = 1440.0;

  // Grid System - Columnas responsive
  static const int mobileColumns = 1;
  static const int tabletColumns = 2;
  static const int desktopColumns = 3;
  static const int largeDesktopColumns = 4;

  // Tamaños de productos por pantalla
  static const int mobileProductsPerRow = 2;
  static const int tabletProductsPerRow = 3;
  static const int desktopProductsPerRow = 4;
  static const int largeDesktopProductsPerRow = 5;

  // Márgenes responsive
  static const double mobileMargin = 16.0;
  static const double tabletMargin = 24.0;
  static const double desktopMargin = 32.0;

  // Tamaños de fuente base para escalado
  static const double baseFontSize = 14.0;
  static const double fontScaleMobile = 1.0;
  static const double fontScaleTablet = 1.1;
  static const double fontScaleDesktop = 1.2;
}
