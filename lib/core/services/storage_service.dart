// 💾 Storage Service
// Servicio base para almacenamiento local y en la nube

import 'dart:io';

abstract class StorageService {
  // Subir imagen
  Future<String> uploadImage(File image, String path);

  // Descargar imagen
  Future<File?> downloadImage(String url);

  // Eliminar imagen
  Future<bool> deleteImage(String path);

  // Obtener URL de imagen
  Future<String> getImageUrl(String path);

  // Verificar si existe
  Future<bool> exists(String path);
}
