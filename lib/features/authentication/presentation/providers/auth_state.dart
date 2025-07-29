import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_user.dart';

/// Estados posibles del sistema de autenticación
///
/// Esta clase representa todos los posibles estados que puede tener
/// el sistema de autenticación de la aplicación.
///
/// Usando el patrón State Machine para garantizar consistencia
/// y facilitar el manejo de la UI.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial del sistema de autenticación
///
/// Se usa al inicializar la aplicación antes de verificar
/// si hay un usuario autenticado.
class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  String toString() => 'AuthInitial';
}

/// Estado de carga durante operaciones de autenticación
///
/// Se activa durante:
/// - Login
/// - Registro
/// - Logout
/// - Verificación de estado inicial
/// - Reset de contraseña
class AuthLoading extends AuthState {
  /// Mensaje opcional para mostrar al usuario
  final String? message;

  const AuthLoading({this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'AuthLoading(message: $message)';
}

/// Estado cuando el usuario está autenticado exitosamente
///
/// Contiene toda la información del usuario actual
class AuthAuthenticated extends AuthState {
  /// Usuario actualmente autenticado
  final AuthUser user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];

  @override
  String toString() => 'AuthAuthenticated(user: ${user.email})';

  /// Crea una copia del estado con un usuario actualizado
  AuthAuthenticated copyWith({AuthUser? user}) {
    return AuthAuthenticated(user: user ?? this.user);
  }
}

/// Estado cuando no hay usuario autenticado
///
/// Se activa después de:
/// - Logout exitoso
/// - Verificación inicial sin usuario
/// - Sesión expirada
class AuthUnauthenticated extends AuthState {
  /// Mensaje opcional para mostrar al usuario
  final String? message;

  const AuthUnauthenticated({this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'AuthUnauthenticated(message: $message)';
}

/// Estado de error en operaciones de autenticación
///
/// Se activa cuando:
/// - Falla el login
/// - Falla el registro
/// - Error en reset de contraseña
/// - Error al verificar estado
class AuthError extends AuthState {
  /// Mensaje de error técnico
  final String message;

  /// Mensaje amigable para mostrar al usuario
  final String userMessage;

  /// Código de error opcional para identificar el tipo
  final String? errorCode;

  const AuthError({
    required this.message,
    required this.userMessage,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, userMessage, errorCode];

  @override
  String toString() =>
      'AuthError(message: $message, userMessage: $userMessage, errorCode: $errorCode)';
}

/// Estado de éxito para operaciones que no cambian el estado de autenticación
///
/// Se usa para:
/// - Reset de contraseña enviado
/// - Actualización de perfil
/// - Operaciones administrativas
class AuthSuccess extends AuthState {
  /// Mensaje de éxito para mostrar al usuario
  final String message;

  /// Usuario actual (mantiene el estado de autenticación)
  final AuthUser? user;

  const AuthSuccess({required this.message, this.user});

  @override
  List<Object?> get props => [message, user];

  @override
  String toString() => 'AuthSuccess(message: $message, user: ${user?.email})';
}

/// Extensiones útiles para trabajar con estados
extension AuthStateExtensions on AuthState {
  /// Verifica si el estado actual representa un usuario autenticado
  bool get isAuthenticated => this is AuthAuthenticated;

  /// Verifica si hay una operación en progreso
  bool get isLoading => this is AuthLoading;

  /// Verifica si hay un error
  bool get hasError => this is AuthError;

  /// Verifica si hay un mensaje de éxito
  bool get hasSuccess => this is AuthSuccess;

  /// Obtiene el usuario si está autenticado, null en caso contrario
  AuthUser? get user {
    if (this is AuthAuthenticated) {
      return (this as AuthAuthenticated).user;
    }
    if (this is AuthSuccess) {
      return (this as AuthSuccess).user;
    }
    return null;
  }

  /// Obtiene el mensaje de error si existe
  String? get errorMessage {
    if (this is AuthError) {
      return (this as AuthError).userMessage;
    }
    return null;
  }

  /// Obtiene el mensaje de éxito si existe
  String? get successMessage {
    if (this is AuthSuccess) {
      return (this as AuthSuccess).message;
    }
    return null;
  }

  /// Obtiene cualquier mensaje informativo
  String? get displayMessage {
    return errorMessage ?? successMessage ?? _getLoadingMessage();
  }

  String? _getLoadingMessage() {
    if (this is AuthLoading) {
      return (this as AuthLoading).message;
    }
    if (this is AuthUnauthenticated) {
      return (this as AuthUnauthenticated).message;
    }
    return null;
  }
}
