// 🖼️ Image Utils
// Utilidades para manejo de imágenes

import 'dart:io';
import 'dart:typed_data';

class ImageUtils {
  // Validar si el archivo es una imagen válida
  static bool isValidImageFile(File file) {
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];
    final extension = file.path.toLowerCase().split('.').last;
    return validExtensions.contains('.$extension');
  }

  // Validar tamaño de imagen
  static bool isValidImageSize(
    File file, {
    int maxSizeInBytes = 5 * 1024 * 1024,
  }) {
    return file.lengthSync() <= maxSizeInBytes;
  }

  // Obtener extensión de archivo
  static String getFileExtension(String filePath) {
    return filePath.split('.').last.toLowerCase();
  }

  // Generar nombre único para imagen
  static String generateUniqueImageName(String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${prefix}_$timestamp.jpg';
  }

  // Convertir File a Uint8List
  static Future<Uint8List> fileToUint8List(File file) async {
    return await file.readAsBytes();
  }

  // Validar formato de imagen para IA
  static bool isValidForAIProcessing(File file) {
    final validFormats = ['.jpg', '.jpeg', '.png'];
    final extension = getFileExtension(file.path);
    return validFormats.contains('.$extension') && isValidImageSize(file);
  }
}
