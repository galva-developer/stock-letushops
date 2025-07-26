// 🤖 AI Service
// Servicio base para integración con servicios de IA

import 'dart:io';

abstract class AIService {
  // Analizar imagen para extraer características
  Future<Map<String, dynamic>> analyzeImage(File image);

  // Extraer texto de imagen (OCR)
  Future<List<String>> extractTextFromImage(File image);

  // Detectar objetos en imagen
  Future<List<String>> detectObjects(File image);

  // Clasificar producto
  Future<String> classifyProduct(File image);

  // Obtener características del producto
  Future<Map<String, String>> getProductCharacteristics(File image);

  // Verificar si el servicio está disponible
  Future<bool> isServiceAvailable();
}
