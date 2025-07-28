/// Clase base para todas las excepciones de autenticación
///
/// Proporciona una estructura común para manejar errores relacionados
/// con la autenticación en la aplicación.
abstract class AuthException implements Exception {
  /// Mensaje de error técnico
  final String message;

  /// Código de error para identificación programática
  final String code;

  /// Mensaje de error amigable para el usuario
  final String userMessage;

  const AuthException({
    required this.message,
    required this.code,
    required this.userMessage,
  });

  @override
  String toString() => 'AuthException(code: $code, message: $message)';
}

/// Excepción para credenciales inválidas
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException({
    String message = 'Invalid email or password',
    String code = 'invalid-credentials',
    String userMessage = 'Email o contraseña incorrectos',
  }) : super(message: message, code: code, userMessage: userMessage);
}

/// Excepción para email no verificado
class EmailNotVerifiedException extends AuthException {
  const EmailNotVerifiedException({
    String message = 'Email not verified',
    String code = 'email-not-verified',
    String userMessage = 'Por favor verifica tu email antes de continuar',
  }) : super(message: message, code: code, userMessage: userMessage);
}

/// Excepción para usuario no encontrado
class UserNotFoundException extends AuthException {
  const UserNotFoundException({
    String message = 'User not found',
    String code = 'user-not-found',
    String userMessage = 'No se encontró un usuario con este email',
  }) : super(message: message, code: code, userMessage: userMessage);
}

/// Excepción para email ya en uso
class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException({
    String message = 'Email already in use',
    String code = 'email-already-in-use',
    String userMessage = 'Este email ya está registrado',
  }) : super(message: message, code: code, userMessage: userMessage);
}

/// Excepción para contraseña débil
class WeakPasswordException extends AuthException {
  const WeakPasswordException({
    String message = 'Weak password',
    String code = 'weak-password',
    String userMessage = 'La contraseña debe tener al menos 6 caracteres',
  }) : super(message: message, code: code, userMessage: userMessage);
}

/// Excepción para demasiados intentos
class TooManyRequestsException extends AuthException {
  const TooManyRequestsException({
    String message = 'Too many requests',
    String code = 'too-many-requests',
    String userMessage = 'Demasiados intentos. Intenta de nuevo más tarde',
  }) : super(message: message, code: code, userMessage: userMessage);
}

/// Excepción para cuenta deshabilitada
class UserDisabledException extends AuthException {
  const UserDisabledException({
    String message = 'User account disabled',
    String code = 'user-disabled',
    String userMessage = 'Esta cuenta ha sido deshabilitada',
  }) : super(message: message, code: code, userMessage: userMessage);
}

/// Excepción para operación no permitida
class OperationNotAllowedException extends AuthException {
  const OperationNotAllowedException({
    String message = 'Operation not allowed',
    String code = 'operation-not-allowed',
    String userMessage = 'Esta operación no está permitida',
  }) : super(message: message, code: code, userMessage: userMessage);
}

/// Excepción para falta de permisos
class InsufficientPermissionsException extends AuthException {
  const InsufficientPermissionsException({
    String message = 'Insufficient permissions',
    String code = 'insufficient-permissions',
    String userMessage = 'No tienes permisos para realizar esta acción',
  }) : super(message: message, code: code, userMessage: userMessage);
}

/// Excepción para sesión expirada
class SessionExpiredException extends AuthException {
  const SessionExpiredException({
    String message = 'Session expired',
    String code = 'session-expired',
    String userMessage = 'Tu sesión ha expirado. Inicia sesión nuevamente',
  }) : super(message: message, code: code, userMessage: userMessage);
}

/// Excepción para errores de red
class NetworkException extends AuthException {
  const NetworkException({
    String message = 'Network error',
    String code = 'network-error',
    String userMessage = 'Error de conexión. Verifica tu internet',
  }) : super(message: message, code: code, userMessage: userMessage);
}

/// Excepción para errores del servidor
class ServerException extends AuthException {
  const ServerException({
    String message = 'Server error',
    String code = 'server-error',
    String userMessage = 'Error del servidor. Intenta más tarde',
  }) : super(message: message, code: code, userMessage: userMessage);
}

/// Excepción genérica para errores desconocidos
class UnknownAuthException extends AuthException {
  const UnknownAuthException({
    String message = 'Unknown authentication error',
    String code = 'unknown-error',
    String userMessage = 'Ocurrió un error inesperado',
  }) : super(message: message, code: code, userMessage: userMessage);
}

/// Utilidad para convertir códigos de error de Firebase a excepciones personalizadas
class AuthExceptionMapper {
  static AuthException fromFirebaseAuthCode(String code, [String? message]) {
    switch (code) {
      case 'invalid-email':
      case 'wrong-password':
      case 'invalid-credential':
        return InvalidCredentialsException(message: message ?? code);

      case 'user-not-found':
        return UserNotFoundException(message: message ?? code);

      case 'email-already-in-use':
        return EmailAlreadyInUseException(message: message ?? code);

      case 'weak-password':
        return WeakPasswordException(message: message ?? code);

      case 'too-many-requests':
        return TooManyRequestsException(message: message ?? code);

      case 'user-disabled':
        return UserDisabledException(message: message ?? code);

      case 'operation-not-allowed':
        return OperationNotAllowedException(message: message ?? code);

      case 'network-request-failed':
        return NetworkException(message: message ?? code);

      case 'internal-error':
        return ServerException(message: message ?? code);

      default:
        return UnknownAuthException(
          message: message ?? 'Unknown error: $code',
          code: code,
        );
    }
  }

  /// Convierte una excepción genérica a AuthException
  static AuthException fromException(Object error) {
    if (error is AuthException) {
      return error;
    }

    if (error is Exception) {
      return UnknownAuthException(message: error.toString());
    }

    return UnknownAuthException(message: 'Unknown error: $error');
  }
}

/// Excepciones específicas para validación de entrada
class ValidationException extends AuthException {
  const ValidationException({
    required super.message,
    required super.code,
    required super.userMessage,
  });
}

/// Excepción para email inválido
class InvalidEmailFormatException extends ValidationException {
  const InvalidEmailFormatException({
    String message = 'Invalid email format',
    String code = 'invalid-email-format',
    String userMessage = 'Por favor ingresa un email válido',
  }) : super(message: message, code: code, userMessage: userMessage);
}

/// Excepción para contraseña muy corta
class PasswordTooShortException extends ValidationException {
  const PasswordTooShortException({
    String message = 'Password too short',
    String code = 'password-too-short',
    String userMessage = 'La contraseña debe tener al menos 6 caracteres',
  }) : super(message: message, code: code, userMessage: userMessage);
}

/// Excepción para campos requeridos
class RequiredFieldException extends ValidationException {
  final String fieldName;

  const RequiredFieldException({
    required this.fieldName,
    String? message,
    String code = 'required-field',
    String? userMessage,
  }) : super(
         message: message ?? 'Field $fieldName is required',
         code: code,
         userMessage: userMessage ?? 'El campo $fieldName es requerido',
       );
}
