import '../entities/auth_user.dart';

/// Interfaz del repositorio de autenticación que define los contratos
/// que debe cumplir cualquier implementación de la capa de datos.
///
/// Esta interfaz pertenece a la capa de dominio y es independiente
/// de cualquier implementación específica (Firebase, REST API, etc.).
abstract class AuthRepository {
  /// Stream que emite el estado actual del usuario autenticado
  ///
  /// Emite:
  /// - `AuthUser` cuando hay un usuario autenticado
  /// - `null` cuando no hay usuario autenticado
  ///
  /// Este stream permite a la UI reaccionar automáticamente
  /// a cambios en el estado de autenticación
  Stream<AuthUser?> get authStateChanges;

  /// Obtiene el usuario actualmente autenticado
  ///
  /// Returns:
  /// - `AuthUser` si hay un usuario autenticado
  /// - `null` si no hay usuario autenticado
  ///
  /// Throws:
  /// - `AuthException` si ocurre un error al obtener el usuario
  Future<AuthUser?> getCurrentUser();

  /// Inicia sesión con email y contraseña
  ///
  /// Parameters:
  /// - `email`: Correo electrónico del usuario
  /// - `password`: Contraseña del usuario
  ///
  /// Returns:
  /// - `AuthUser` con los datos del usuario autenticado
  ///
  /// Throws:
  /// - `InvalidCredentialsException` si las credenciales son incorrectas
  /// - `UserNotFoundException` si el usuario no existe
  /// - `UserDisabledException` si la cuenta está deshabilitada
  /// - `TooManyRequestsException` si hay demasiados intentos fallidos
  /// - `NetworkException` si hay problemas de conectividad
  /// - `AuthException` para otros errores de autenticación
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Registra un nuevo usuario con email y contraseña
  ///
  /// Parameters:
  /// - `email`: Correo electrónico del nuevo usuario
  /// - `password`: Contraseña del nuevo usuario
  /// - `displayName`: Nombre completo del usuario (opcional)
  ///
  /// Returns:
  /// - `AuthUser` con los datos del usuario registrado
  ///
  /// Throws:
  /// - `EmailAlreadyInUseException` si el email ya está registrado
  /// - `WeakPasswordException` si la contraseña es muy débil
  /// - `InvalidEmailFormatException` si el formato del email es inválido
  /// - `NetworkException` si hay problemas de conectividad
  /// - `AuthException` para otros errores de autenticación
  Future<AuthUser> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  });

  /// Cierra la sesión del usuario actual
  ///
  /// Throws:
  /// - `AuthException` si ocurre un error al cerrar sesión
  Future<void> signOut();

  /// Envía un email para restablecer la contraseña
  ///
  /// Parameters:
  /// - `email`: Correo electrónico al que enviar el link de reset
  ///
  /// Throws:
  /// - `UserNotFoundException` si el usuario no existe
  /// - `InvalidEmailFormatException` si el formato del email es inválido
  /// - `TooManyRequestsException` si se han enviado demasiados emails
  /// - `NetworkException` si hay problemas de conectividad
  /// - `AuthException` para otros errores
  Future<void> sendPasswordResetEmail({required String email});

  /// Actualiza el perfil del usuario actual
  ///
  /// Parameters:
  /// - `displayName`: Nuevo nombre a mostrar (opcional)
  /// - `photoURL`: Nueva URL de foto de perfil (opcional)
  ///
  /// Returns:
  /// - `AuthUser` con los datos actualizados
  ///
  /// Throws:
  /// - `SessionExpiredException` si la sesión ha expirado
  /// - `NetworkException` si hay problemas de conectividad
  /// - `AuthException` para otros errores
  Future<AuthUser> updateProfile({String? displayName, String? photoURL});

  /// Actualiza la contraseña del usuario actual
  ///
  /// Parameters:
  /// - `newPassword`: Nueva contraseña
  ///
  /// Throws:
  /// - `WeakPasswordException` si la nueva contraseña es muy débil
  /// - `SessionExpiredException` si la sesión ha expirado
  /// - `NetworkException` si hay problemas de conectividad
  /// - `AuthException` para otros errores
  Future<void> updatePassword({required String newPassword});

  /// Reautentica al usuario con sus credenciales actuales
  ///
  /// Requerido antes de operaciones sensibles como cambio de contraseña
  ///
  /// Parameters:
  /// - `password`: Contraseña actual del usuario
  ///
  /// Throws:
  /// - `InvalidCredentialsException` si la contraseña es incorrecta
  /// - `SessionExpiredException` si la sesión ha expirado
  /// - `NetworkException` si hay problemas de conectividad
  /// - `AuthException` para otros errores
  Future<void> reauthenticate({required String password});

  /// Envía un email de verificación al usuario actual
  ///
  /// Throws:
  /// - `SessionExpiredException` si la sesión ha expirado
  /// - `TooManyRequestsException` si se han enviado demasiados emails
  /// - `NetworkException` si hay problemas de conectividad
  /// - `AuthException` para otros errores
  Future<void> sendEmailVerification();

  /// Recarga los datos del usuario actual desde el servidor
  ///
  /// Útil para obtener el estado más reciente de verificación de email
  ///
  /// Returns:
  /// - `AuthUser` con los datos actualizados
  ///
  /// Throws:
  /// - `SessionExpiredException` si la sesión ha expirado
  /// - `NetworkException` si hay problemas de conectividad
  /// - `AuthException` para otros errores
  Future<AuthUser> reloadUser();

  /// Elimina la cuenta del usuario actual
  ///
  /// Operación irreversible que requiere reautenticación previa
  ///
  /// Throws:
  /// - `SessionExpiredException` si la sesión ha expirado
  /// - `InsufficientPermissionsException` si se requiere reautenticación
  /// - `NetworkException` si hay problemas de conectividad
  /// - `AuthException` para otros errores
  Future<void> deleteAccount();

  /// Verifica si el usuario actual tiene permisos para una acción específica
  ///
  /// Parameters:
  /// - `requiredRole`: Rol mínimo requerido para la acción
  ///
  /// Returns:
  /// - `true` si el usuario tiene permisos suficientes
  /// - `false` si no tiene permisos o no está autenticado
  Future<bool> hasPermission(UserRole requiredRole);

  /// Actualiza el rol del usuario (solo para administradores)
  ///
  /// Parameters:
  /// - `userId`: ID del usuario a actualizar
  /// - `newRole`: Nuevo rol a asignar
  ///
  /// Throws:
  /// - `InsufficientPermissionsException` si no tiene permisos de admin
  /// - `UserNotFoundException` si el usuario no existe
  /// - `NetworkException` si hay problemas de conectividad
  /// - `AuthException` para otros errores
  Future<void> updateUserRole({
    required String userId,
    required UserRole newRole,
  });

  /// Actualiza el estado del usuario (solo para administradores)
  ///
  /// Parameters:
  /// - `userId`: ID del usuario a actualizar
  /// - `newStatus`: Nuevo estado a asignar
  ///
  /// Throws:
  /// - `InsufficientPermissionsException` si no tiene permisos de admin
  /// - `UserNotFoundException` si el usuario no existe
  /// - `NetworkException` si hay problemas de conectividad
  /// - `AuthException` para otros errores
  Future<void> updateUserStatus({
    required String userId,
    required UserStatus newStatus,
  });

  /// Obtiene la lista de todos los usuarios (solo para administradores)
  ///
  /// Parameters:
  /// - `limit`: Número máximo de usuarios a obtener (opcional)
  /// - `startAfter`: Último usuario de la página anterior para paginación (opcional)
  ///
  /// Returns:
  /// - Lista de `AuthUser` con todos los usuarios del sistema
  ///
  /// Throws:
  /// - `InsufficientPermissionsException` si no tiene permisos de admin
  /// - `NetworkException` si hay problemas de conectividad
  /// - `AuthException` para otros errores
  Future<List<AuthUser>> getAllUsers({int? limit, String? startAfter});

  /// Busca usuarios por email o nombre (solo para administradores)
  ///
  /// Parameters:
  /// - `query`: Término de búsqueda
  /// - `limit`: Número máximo de resultados (opcional)
  ///
  /// Returns:
  /// - Lista de `AuthUser` que coinciden con la búsqueda
  ///
  /// Throws:
  /// - `InsufficientPermissionsException` si no tiene permisos de admin
  /// - `NetworkException` si hay problemas de conectividad
  /// - `AuthException` para otros errores
  Future<List<AuthUser>> searchUsers({required String query, int? limit});

  /// Obtiene los datos completos de un usuario específico
  ///
  /// Combina datos de Firebase Authentication y Firestore
  ///
  /// Parameters:
  /// - `userId`: ID del usuario a obtener
  ///
  /// Returns:
  /// - `AuthUser` con los datos completos del usuario
  ///
  /// Throws:
  /// - `UserNotFoundException` si el usuario no existe
  /// - `InsufficientPermissionsException` si no tiene permisos para ver el usuario
  /// - `NetworkException` si hay problemas de conectividad
  /// - `AuthException` para otros errores
  Future<AuthUser> getUserById(String userId);

  /// Verifica si un email está disponible para registro
  ///
  /// Parameters:
  /// - `email`: Email a verificar
  ///
  /// Returns:
  /// - `true` si el email está disponible
  /// - `false` si el email ya está en uso
  ///
  /// Throws:
  /// - `InvalidEmailFormatException` si el formato del email es inválido
  /// - `NetworkException` si hay problemas de conectividad
  /// - `AuthException` para otros errores
  Future<bool> isEmailAvailable(String email);
}
