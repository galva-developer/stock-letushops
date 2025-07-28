import 'dart:async';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/exceptions/auth_exceptions.dart';
import '../datasources/firebase_auth_datasource.dart';

/// Implementación concreta del repositorio de autenticación.
///
/// Esta clase actúa como un puente entre la capa de dominio y la capa de datos,
/// delegando todas las operaciones a la fuente de datos de Firebase.
///
/// Responsabilidades:
/// - Implementar todos los métodos de la interfaz AuthRepository
/// - Delegar operaciones a FirebaseAuthDataSource
/// - Mantener la independencia del dominio respecto a Firebase
/// - Proporcionar un punto único de acceso para operaciones de autenticación
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _firebaseAuthDataSource;

  /// Constructor que recibe la fuente de datos de Firebase
  ///
  /// [_firebaseAuthDataSource] La fuente de datos que maneja Firebase Auth y Firestore
  const AuthRepositoryImpl(this._firebaseAuthDataSource);

  /// Stream que emite el estado actual del usuario autenticado
  ///
  /// Delega al stream de la fuente de datos y convierte UserModel a AuthUser
  @override
  Stream<AuthUser?> get authStateChanges {
    return _firebaseAuthDataSource.authStateChanges;
  }

  /// Obtiene el usuario actualmente autenticado
  ///
  /// Returns:
  /// - [AuthUser] si hay un usuario autenticado
  /// - [null] si no hay usuario autenticado
  ///
  /// Throws:
  /// - [AuthException] si ocurre un error al obtener el usuario
  @override
  Future<AuthUser?> getCurrentUser() async {
    try {
      return await _firebaseAuthDataSource.getCurrentUser();
    } on AuthException {
      rethrow; // Re-lanzar excepciones del dominio tal como están
    } catch (e) {
      // Convertir cualquier otra excepción a excepción del dominio
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Inicia sesión con email y contraseña
  ///
  /// Parameters:
  /// - [email] Correo electrónico del usuario
  /// - [password] Contraseña del usuario
  ///
  /// Returns:
  /// - [AuthUser] con los datos del usuario autenticado
  ///
  /// Throws:
  /// - [InvalidCredentialsException] si las credenciales son incorrectas
  /// - [UserNotFoundException] si el usuario no existe
  /// - [UserDisabledException] si la cuenta está deshabilitada
  /// - [TooManyRequestsException] si hay demasiados intentos fallidos
  /// - [NetworkException] si hay problemas de conectividad
  /// - [AuthException] para otros errores de autenticación
  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Validaciones básicas antes de delegar
      if (email.trim().isEmpty) {
        throw const RequiredFieldException(fieldName: 'email');
      }
      if (password.isEmpty) {
        throw const RequiredFieldException(fieldName: 'password');
      }

      // Validar formato de email
      if (!_isValidEmail(email)) {
        throw const InvalidEmailFormatException();
      }

      return await _firebaseAuthDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Registra un nuevo usuario con email y contraseña
  ///
  /// Parameters:
  /// - [email] Correo electrónico del nuevo usuario
  /// - [password] Contraseña del nuevo usuario
  /// - [displayName] Nombre completo del usuario (opcional)
  ///
  /// Returns:
  /// - [AuthUser] con los datos del usuario registrado
  ///
  /// Throws:
  /// - [EmailAlreadyInUseException] si el email ya está registrado
  /// - [WeakPasswordException] si la contraseña es muy débil
  /// - [InvalidEmailFormatException] si el formato del email es inválido
  /// - [NetworkException] si hay problemas de conectividad
  /// - [AuthException] para otros errores de autenticación
  @override
  Future<AuthUser> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      // Validaciones básicas
      if (email.trim().isEmpty) {
        throw const RequiredFieldException(fieldName: 'email');
      }
      if (password.isEmpty) {
        throw const RequiredFieldException(fieldName: 'password');
      }

      // Validar formato de email
      if (!_isValidEmail(email)) {
        throw const InvalidEmailFormatException();
      }

      // Validar longitud de contraseña
      if (password.length < 6) {
        throw const PasswordTooShortException();
      }

      // Validar displayName si se proporciona
      if (displayName != null && displayName.trim().isEmpty) {
        displayName = null; // Convertir string vacío a null
      }

      return await _firebaseAuthDataSource.registerWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Cierra la sesión del usuario actual
  ///
  /// Throws:
  /// - [AuthException] si ocurre un error al cerrar sesión
  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuthDataSource.signOut();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Envía un email para restablecer la contraseña
  ///
  /// Parameters:
  /// - [email] Correo electrónico al que enviar el link de reset
  ///
  /// Throws:
  /// - [UserNotFoundException] si el usuario no existe
  /// - [InvalidEmailFormatException] si el formato del email es inválido
  /// - [TooManyRequestsException] si se han enviado demasiados emails
  /// - [NetworkException] si hay problemas de conectividad
  /// - [AuthException] para otros errores
  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      // Validaciones básicas
      if (email.trim().isEmpty) {
        throw const RequiredFieldException(fieldName: 'email');
      }

      // Validar formato de email
      if (!_isValidEmail(email)) {
        throw const InvalidEmailFormatException();
      }

      await _firebaseAuthDataSource.sendPasswordResetEmail(email: email);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Actualiza el perfil del usuario actual
  ///
  /// Parameters:
  /// - [displayName] Nuevo nombre a mostrar (opcional)
  /// - [photoURL] Nueva URL de foto de perfil (opcional)
  ///
  /// Returns:
  /// - [AuthUser] con los datos actualizados
  ///
  /// Throws:
  /// - [SessionExpiredException] si la sesión ha expirado
  /// - [NetworkException] si hay problemas de conectividad
  /// - [AuthException] para otros errores
  @override
  Future<AuthUser> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      // Validar que al menos un campo se va a actualizar
      if (displayName == null && photoURL == null) {
        throw const UnknownAuthException(
          message: 'At least one field must be provided for update',
          userMessage: 'Debe proporcionar al menos un campo para actualizar',
        );
      }

      // Limpiar displayName si está vacío
      if (displayName != null && displayName.trim().isEmpty) {
        displayName = null;
      }

      return await _firebaseAuthDataSource.updateProfile(
        displayName: displayName,
        photoURL: photoURL,
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Actualiza la contraseña del usuario actual
  ///
  /// Parameters:
  /// - [newPassword] Nueva contraseña
  ///
  /// Throws:
  /// - [WeakPasswordException] si la nueva contraseña es muy débil
  /// - [SessionExpiredException] si la sesión ha expirado
  /// - [NetworkException] si hay problemas de conectividad
  /// - [AuthException] para otros errores
  @override
  Future<void> updatePassword({required String newPassword}) async {
    try {
      // Validaciones básicas
      if (newPassword.isEmpty) {
        throw const RequiredFieldException(fieldName: 'newPassword');
      }

      // Validar longitud de contraseña
      if (newPassword.length < 6) {
        throw const PasswordTooShortException();
      }

      await _firebaseAuthDataSource.updatePassword(newPassword: newPassword);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Reautentica al usuario con sus credenciales actuales
  ///
  /// Parameters:
  /// - [password] Contraseña actual del usuario
  ///
  /// Throws:
  /// - [InvalidCredentialsException] si la contraseña es incorrecta
  /// - [SessionExpiredException] si la sesión ha expirado
  /// - [NetworkException] si hay problemas de conectividad
  /// - [AuthException] para otros errores
  @override
  Future<void> reauthenticate({required String password}) async {
    try {
      // Validaciones básicas
      if (password.isEmpty) {
        throw const RequiredFieldException(fieldName: 'password');
      }

      await _firebaseAuthDataSource.reauthenticate(password: password);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Envía un email de verificación al usuario actual
  ///
  /// Throws:
  /// - [SessionExpiredException] si la sesión ha expirado
  /// - [TooManyRequestsException] si se han enviado demasiados emails
  /// - [NetworkException] si hay problemas de conectividad
  /// - [AuthException] para otros errores
  @override
  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuthDataSource.sendEmailVerification();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Recarga los datos del usuario actual desde el servidor
  ///
  /// Returns:
  /// - [AuthUser] con los datos actualizados
  ///
  /// Throws:
  /// - [SessionExpiredException] si la sesión ha expirado
  /// - [NetworkException] si hay problemas de conectividad
  /// - [AuthException] para otros errores
  @override
  Future<AuthUser> reloadUser() async {
    try {
      return await _firebaseAuthDataSource.reloadUser();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Elimina la cuenta del usuario actual
  ///
  /// Throws:
  /// - [SessionExpiredException] si la sesión ha expirado
  /// - [InsufficientPermissionsException] si se requiere reautenticación
  /// - [NetworkException] si hay problemas de conectividad
  /// - [AuthException] para otros errores
  @override
  Future<void> deleteAccount() async {
    try {
      await _firebaseAuthDataSource.deleteAccount();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Verifica si el usuario actual tiene permisos para una acción específica
  ///
  /// Parameters:
  /// - [requiredRole] Rol mínimo requerido para la acción
  ///
  /// Returns:
  /// - [true] si el usuario tiene permisos suficientes
  /// - [false] si no tiene permisos o no está autenticado
  @override
  Future<bool> hasPermission(UserRole requiredRole) async {
    try {
      return await _firebaseAuthDataSource.hasPermission(requiredRole);
    } catch (e) {
      // En caso de error, denegar permisos por seguridad
      return false;
    }
  }

  /// Actualiza el rol del usuario (solo para administradores)
  ///
  /// Parameters:
  /// - [userId] ID del usuario a actualizar
  /// - [newRole] Nuevo rol a asignar
  ///
  /// Throws:
  /// - [InsufficientPermissionsException] si no tiene permisos de admin
  /// - [UserNotFoundException] si el usuario no existe
  /// - [NetworkException] si hay problemas de conectividad
  /// - [AuthException] para otros errores
  @override
  Future<void> updateUserRole({
    required String userId,
    required UserRole newRole,
  }) async {
    try {
      // Validaciones básicas
      if (userId.trim().isEmpty) {
        throw const RequiredFieldException(fieldName: 'userId');
      }

      await _firebaseAuthDataSource.updateUserRole(
        userId: userId,
        newRole: newRole,
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Actualiza el estado del usuario (solo para administradores)
  ///
  /// Parameters:
  /// - [userId] ID del usuario a actualizar
  /// - [newStatus] Nuevo estado a asignar
  ///
  /// Throws:
  /// - [InsufficientPermissionsException] si no tiene permisos de admin
  /// - [UserNotFoundException] si el usuario no existe
  /// - [NetworkException] si hay problemas de conectividad
  /// - [AuthException] para otros errores
  @override
  Future<void> updateUserStatus({
    required String userId,
    required UserStatus newStatus,
  }) async {
    try {
      // Validaciones básicas
      if (userId.trim().isEmpty) {
        throw const RequiredFieldException(fieldName: 'userId');
      }

      await _firebaseAuthDataSource.updateUserStatus(
        userId: userId,
        newStatus: newStatus,
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Obtiene la lista de todos los usuarios (solo para administradores)
  ///
  /// Parameters:
  /// - [limit] Número máximo de usuarios a obtener (opcional)
  /// - [startAfter] Último usuario de la página anterior para paginación (opcional)
  ///
  /// Returns:
  /// - Lista de [AuthUser] con todos los usuarios del sistema
  ///
  /// Throws:
  /// - [InsufficientPermissionsException] si no tiene permisos de admin
  /// - [NetworkException] si hay problemas de conectividad
  /// - [AuthException] para otros errores
  @override
  Future<List<AuthUser>> getAllUsers({int? limit, String? startAfter}) async {
    try {
      // Validar límite si se proporciona
      if (limit != null && limit <= 0) {
        throw const UnknownAuthException(
          message: 'Limit must be greater than 0',
          userMessage: 'El límite debe ser mayor a 0',
        );
      }

      final users = await _firebaseAuthDataSource.getAllUsers(
        limit: limit,
        startAfter: startAfter,
      );

      // Convertir List<UserModel> a List<AuthUser>
      return users.cast<AuthUser>();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Busca usuarios por email o nombre (solo para administradores)
  ///
  /// Parameters:
  /// - [query] Término de búsqueda
  /// - [limit] Número máximo de resultados (opcional)
  ///
  /// Returns:
  /// - Lista de [AuthUser] que coinciden con la búsqueda
  ///
  /// Throws:
  /// - [InsufficientPermissionsException] si no tiene permisos de admin
  /// - [NetworkException] si hay problemas de conectividad
  /// - [AuthException] para otros errores
  @override
  Future<List<AuthUser>> searchUsers({
    required String query,
    int? limit,
  }) async {
    try {
      // Validaciones básicas
      if (query.trim().isEmpty) {
        throw const RequiredFieldException(fieldName: 'query');
      }

      // Validar límite si se proporciona
      if (limit != null && limit <= 0) {
        throw const UnknownAuthException(
          message: 'Limit must be greater than 0',
          userMessage: 'El límite debe ser mayor a 0',
        );
      }

      final users = await _firebaseAuthDataSource.searchUsers(
        query: query,
        limit: limit,
      );

      // Convertir List<UserModel> a List<AuthUser>
      return users.cast<AuthUser>();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Obtiene los datos completos de un usuario específico
  ///
  /// Parameters:
  /// - [userId] ID del usuario a obtener
  ///
  /// Returns:
  /// - [AuthUser] con los datos completos del usuario
  ///
  /// Throws:
  /// - [UserNotFoundException] si el usuario no existe
  /// - [InsufficientPermissionsException] si no tiene permisos para ver el usuario
  /// - [NetworkException] si hay problemas de conectividad
  /// - [AuthException] para otros errores
  @override
  Future<AuthUser> getUserById(String userId) async {
    try {
      // Validaciones básicas
      if (userId.trim().isEmpty) {
        throw const RequiredFieldException(fieldName: 'userId');
      }

      return await _firebaseAuthDataSource.getUserById(userId);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Verifica si un email está disponible para registro
  ///
  /// Parameters:
  /// - [email] Email a verificar
  ///
  /// Returns:
  /// - [true] si el email está disponible
  /// - [false] si el email ya está en uso
  ///
  /// Throws:
  /// - [InvalidEmailFormatException] si el formato del email es inválido
  /// - [NetworkException] si hay problemas de conectividad
  /// - [AuthException] para otros errores
  @override
  Future<bool> isEmailAvailable(String email) async {
    try {
      // Validaciones básicas
      if (email.trim().isEmpty) {
        throw const RequiredFieldException(fieldName: 'email');
      }

      // Validar formato de email
      if (!_isValidEmail(email)) {
        throw const InvalidEmailFormatException();
      }

      return await _firebaseAuthDataSource.isEmailAvailable(email);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthExceptionMapper.fromException(e);
    }
  }

  /// Métodos auxiliares privados

  /// Valida el formato de un email usando expresión regular
  ///
  /// Parameters:
  /// - [email] Email a validar
  ///
  /// Returns:
  /// - [true] si el formato es válido
  /// - [false] si el formato es inválido
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email.trim());
  }
}
