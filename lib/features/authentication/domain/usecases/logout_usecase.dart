import '../repositories/auth_repository.dart';

/// Caso de uso para el cierre de sesión de usuarios
///
/// Este caso de uso encapsula la lógica de negocio para cerrar
/// la sesión del usuario actualmente autenticado.
///
/// Ejemplo de uso:
/// ```dart
/// final logoutUseCase = LogoutUseCase(authRepository);
/// try {
///   await logoutUseCase.call();
///   print('Logout exitoso');
/// } catch (e) {
///   print('Error en logout: ${e.toString()}');
/// }
/// ```
class LogoutUseCase {
  final AuthRepository _authRepository;

  const LogoutUseCase(this._authRepository);

  /// Ejecuta el caso de uso de logout
  ///
  /// Cierra la sesión del usuario actualmente autenticado.
  /// Limpia el estado de autenticación y tokens locales.
  ///
  /// No retorna ningún valor si es exitoso
  ///
  /// Lanza excepciones del tipo [AuthException] si:
  /// - No hay usuario autenticado
  /// - Hay problemas de conexión al cerrar sesión
  /// - Error al limpiar datos locales
  /// - Otros errores de autenticación
  Future<void> call() async {
    return await _authRepository.signOut();
  }
}
