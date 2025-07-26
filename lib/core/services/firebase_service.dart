// 🔥 Firebase Service
// Servicio base para integración con Firebase

abstract class FirebaseService {
  // Inicializar Firebase
  Future<void> initialize();

  // Verificar estado de conexión
  bool get isInitialized;

  // Obtener ID de usuario actual
  String? get currentUserId;

  // Verificar si el usuario está autenticado
  bool get isAuthenticated;
}
