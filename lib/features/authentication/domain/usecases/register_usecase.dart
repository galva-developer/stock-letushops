import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para el registro de nuevos usuarios
///
/// Este caso de uso encapsula la lógica de negocio para registrar
/// un nuevo usuario en el sistema con email, contraseña y nombre opcional.
///
/// Ejemplo de uso:
/// ```dart
/// final registerUseCase = RegisterUseCase(authRepository);
/// try {
///   final user = await registerUseCase.call(
///     email: 'nuevo@ejemplo.com',
///     password: 'miPassword123',
///     displayName: 'Juan Pérez',
///   );
///   print('Registro exitoso: ${user.displayName}');
/// } catch (e) {
///   print('Error en registro: ${e.toString()}');
/// }
/// ```
class RegisterUseCase {
  final AuthRepository _authRepository;

  const RegisterUseCase(this._authRepository);

  /// Ejecuta el caso de uso de registro
  ///
  /// [email] Email del nuevo usuario (debe ser único)
  /// [password] Contraseña del nuevo usuario (mínimo 6 caracteres)
  /// [displayName] Nombre para mostrar del usuario (opcional)
  ///
  /// Retorna [AuthUser] si el registro es exitoso
  ///
  /// Lanza excepciones del tipo [AuthException] si:
  /// - El email ya está registrado
  /// - El email tiene formato inválido
  /// - La contraseña es muy débil
  /// - Hay problemas de conexión
  /// - Otros errores de autenticación
  Future<AuthUser> call({
    required String email,
    required String password,
    String? displayName,
  }) async {
    return await _authRepository.registerWithEmailAndPassword(
      email: email,
      password: password,
      displayName: displayName,
    );
  }
}
