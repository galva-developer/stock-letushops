import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para obtener el usuario actualmente autenticado
///
/// Este caso de uso encapsula la lógica de negocio para obtener
/// la información del usuario que está actualmente autenticado.
///
/// Ejemplo de uso:
/// ```dart
/// final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);
/// try {
///   final user = await getCurrentUserUseCase.call();
///   if (user != null) {
///     print('Usuario actual: ${user.displayName}');
///   } else {
///     print('No hay usuario autenticado');
///   }
/// } catch (e) {
///   print('Error al obtener usuario: ${e.toString()}');
/// }
/// ```
class GetCurrentUserUseCase {
  final AuthRepository _authRepository;

  const GetCurrentUserUseCase(this._authRepository);

  /// Ejecuta el caso de uso para obtener el usuario actual
  ///
  /// Obtiene la información completa del usuario que está
  /// actualmente autenticado, incluyendo sus datos de perfil
  /// y información de roles desde Firestore.
  ///
  /// Retorna [AuthUser?] con la información del usuario o null
  /// si no hay ningún usuario autenticado
  ///
  /// Lanza excepciones del tipo [AuthException] si:
  /// - Hay problemas de conexión
  /// - Error al acceder a los datos del usuario
  /// - El token de autenticación ha expirado
  /// - Otros errores de autenticación
  ///
  /// Nota: Este método combina información de Firebase Auth
  /// con datos adicionales almacenados en Firestore.
  Future<AuthUser?> call() async {
    return await _authRepository.getCurrentUser();
  }
}
