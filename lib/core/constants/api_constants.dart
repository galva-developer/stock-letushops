// 🌐 API Constants
// URLs y endpoints para Firebase y servicios externos

class ApiConstants {
  // Firebase Collections
  static const String productsCollection = 'products';
  static const String usersCollection = 'users';
  static const String inventoryCollection = 'inventory';
  static const String categoriesCollection = 'categories';
  static const String reportsCollection = 'reports';

  // Firebase Storage Paths
  static const String productImagesPath = 'products/images';
  static const String userAvatarsPath = 'users/avatars';
  static const String tempImagesPath = 'temp/images';

  // External APIs (para servicios de IA)
  static const String googleVisionApiUrl = 'https://vision.googleapis.com/v1';
  static const String mlKitApiUrl = 'https://ml.googleapis.com/v1';

  // Endpoints específicos
  static const String textDetectionEndpoint = '/images:annotate';
  static const String labelDetectionEndpoint = '/images:annotate';
  static const String objectDetectionEndpoint = '/images:annotate';

  // Headers comunes
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
