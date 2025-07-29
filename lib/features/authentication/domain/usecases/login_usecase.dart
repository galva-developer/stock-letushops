import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para el inicio de sesión de usuarios
///
/// Este caso de uso encapsula la lógica de negocio para autenticar
/// a un usuario con email y contraseña.
///
/// Ejemplo de uso:
/// ```dart
/// final loginUseCase = LoginUseCase(authRepository);
/// try {
///   final user = await loginUseCase.call(
///     email: 'usuario@ejemplo.com',
///     password: 'miPassword123',
///   );
///   print('Login exitoso: ${user.displayName}');
/// } catch (e) {
///   print('Error en login: ${e.toString()}');
/// }
/// ```
class LoginUseCase {
  final AuthRepository _authRepository;

  const LoginUseCase(this._authRepository);

  /// Ejecuta el caso de uso de login
  ///
  /// [email] Email del usuario que desea iniciar sesión
  /// [password] Contraseña del usuario
  ///
  /// Retorna [AuthUser] si el login es exitoso
  ///
  /// Lanza excepciones del tipo [AuthException] si:
  /// - Las credenciales son inválidas
  /// - El usuario no existe
  /// - Hay problemas de conexión
  /// - El usuario está deshabilitado
  /// - Otros errores de autenticación
  Future<AuthUser> call({
    required String email,
    required String password,
  }) async {
    return await _authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
