// 📱 Device Utils
// Utilidades para información del dispositivo

import 'dart:io';

class DeviceUtils {
  // Verificar si es Android
  static bool get isAndroid => Platform.isAndroid;

  // Verificar si es iOS
  static bool get isIOS => Platform.isIOS;

  // Verificar si es Web
  static bool get isWeb => false; // Se actualizará con kIsWeb en web

  // Verificar si es móvil
  static bool get isMobile => Platform.isAndroid || Platform.isIOS;

  // Verificar si es desktop
  static bool get isDesktop =>
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  // Obtener nombre del platform
  static String get platformName {
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    return 'Unknown';
  }

  // Verificar conexión a internet (básico)
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
