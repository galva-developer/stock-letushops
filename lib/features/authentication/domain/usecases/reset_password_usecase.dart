import '../repositories/auth_repository.dart';

/// Caso de uso para el restablecimiento de contraseña
///
/// Este caso de uso encapsula la lógica de negocio para enviar
/// un email de restablecimiento de contraseña a un usuario.
///
/// Ejemplo de uso:
/// ```dart
/// final resetPasswordUseCase = ResetPasswordUseCase(authRepository);
/// try {
///   await resetPasswordUseCase.call(email: 'usuario@ejemplo.com');
///   print('Email de recuperación enviado');
/// } catch (e) {
///   print('Error al enviar email: ${e.toString()}');
/// }
/// ```
class ResetPasswordUseCase {
  final AuthRepository _authRepository;

  const ResetPasswordUseCase(this._authRepository);

  /// Ejecuta el caso de uso de restablecimiento de contraseña
  ///
  /// [email] Email del usuario que desea restablecer su contraseña
  ///
  /// Envía un email con un enlace para restablecer la contraseña.
  /// El usuario recibirá un email con instrucciones para crear
  /// una nueva contraseña.
  ///
  /// No retorna ningún valor si es exitoso
  ///
  /// Lanza excepciones del tipo [AuthException] si:
  /// - El email no está registrado en el sistema
  /// - El email tiene formato inválido
  /// - Hay problemas de conexión
  /// - El servicio de email está temporalmente no disponible
  /// - Otros errores de autenticación
  ///
  /// Nota: Incluso si el email no existe, Firebase puede no lanzar
  /// error por motivos de seguridad (para no revelar qué emails
  /// están registrados).
  Future<void> call({required String email}) async {
    return await _authRepository.sendPasswordResetEmail(email: email);
  }
}
