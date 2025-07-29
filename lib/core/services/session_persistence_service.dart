import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

/// Servicio para manejar la persistencia de sesión de usuario
///
/// Gestiona el almacenamiento local de información de sesión,
/// preferencias de usuario y estado de autenticación para
/// proporcionar una experiencia fluida entre sesiones.
///
/// Características:
/// - Persistencia automática de estado de autenticación
/// - Almacenamiento de preferencias de usuario
/// - Gestión de tokens y datos de sesión
/// - Limpieza automática al cerrar sesión
/// - Soporte para múltiples tipos de datos
/// - Integración con Firebase Auth
class SessionPersistenceService {
  SessionPersistenceService._();

  static SessionPersistenceService? _instance;
  SharedPreferences? _prefs;

  /// Singleton instance
  static SessionPersistenceService get instance {
    _instance ??= SessionPersistenceService._();
    return _instance!;
  }

  /// Inicializa el servicio de persistencia
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ==========================================
  // CONSTANTES DE CLAVES
  // ==========================================

  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserName = 'user_name';
  static const String _keyUserData = 'user_data';
  static const String _keyLastLoginTime = 'last_login_time';
  static const String _keyIntendedRoute = 'intended_route';
  static const String _keyRememberMe = 'remember_me';
  static const String _keyAppTheme = 'app_theme';
  static const String _keyLanguageCode = 'language_code';
  static const String _keyFirstLaunch = 'first_launch';
  static const String _keyLastBackupTime = 'last_backup_time';

  // ==========================================
  // MÉTODOS DE AUTENTICACIÓN
  // ==========================================

  /// Guarda el estado de login del usuario
  Future<void> saveLoginState({
    required bool isLoggedIn,
    User? user,
    bool rememberMe = false,
  }) async {
    await _ensureInitialized();

    await _prefs!.setBool(_keyIsLoggedIn, isLoggedIn);
    await _prefs!.setBool(_keyRememberMe, rememberMe);

    if (isLoggedIn && user != null) {
      await _prefs!.setString(_keyUserId, user.uid);
      await _prefs!.setString(_keyUserEmail, user.email ?? '');
      await _prefs!.setString(_keyUserName, user.displayName ?? '');
      await _prefs!.setInt(
        _keyLastLoginTime,
        DateTime.now().millisecondsSinceEpoch,
      );

      // Guardar datos adicionales del usuario
      final userData = {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'emailVerified': user.emailVerified,
        'phoneNumber': user.phoneNumber,
        'creationTime': user.metadata.creationTime?.millisecondsSinceEpoch,
        'lastSignInTime': user.metadata.lastSignInTime?.millisecondsSinceEpoch,
      };

      await _prefs!.setString(_keyUserData, jsonEncode(userData));
    }
  }

  /// Obtiene el estado de login actual
  Future<bool> isLoggedIn() async {
    await _ensureInitialized();
    return _prefs!.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Obtiene si el usuario activó "Recordarme"
  Future<bool> shouldRememberUser() async {
    await _ensureInitialized();
    return _prefs!.getBool(_keyRememberMe) ?? false;
  }

  /// Obtiene los datos básicos del usuario guardados
  Future<Map<String, dynamic>?> getUserData() async {
    await _ensureInitialized();
    final userDataJson = _prefs!.getString(_keyUserData);

    if (userDataJson != null) {
      try {
        return jsonDecode(userDataJson) as Map<String, dynamic>;
      } catch (e) {
        // Si hay error al decodificar, limpiar datos corruptos
        await clearUserData();
        return null;
      }
    }

    return null;
  }

  /// Obtiene el ID del usuario
  Future<String?> getUserId() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyUserId);
  }

  /// Obtiene el email del usuario
  Future<String?> getUserEmail() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyUserEmail);
  }

  /// Obtiene el nombre del usuario
  Future<String?> getUserName() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyUserName);
  }

  /// Obtiene la última vez que se logueó el usuario
  Future<DateTime?> getLastLoginTime() async {
    await _ensureInitialized();
    final timestamp = _prefs!.getInt(_keyLastLoginTime);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  // ==========================================
  // MÉTODOS DE NAVEGACIÓN
  // ==========================================

  /// Guarda la ruta destinada para redirección post-login
  Future<void> saveIntendedRoute(String route) async {
    await _ensureInitialized();
    await _prefs!.setString(_keyIntendedRoute, route);
  }

  /// Obtiene la ruta destinada guardada
  Future<String?> getIntendedRoute() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyIntendedRoute);
  }

  /// Limpia la ruta destinada
  Future<void> clearIntendedRoute() async {
    await _ensureInitialized();
    await _prefs!.remove(_keyIntendedRoute);
  }

  /// Obtiene y limpia la ruta destinada (operación atómica)
  Future<String?> getAndClearIntendedRoute() async {
    final route = await getIntendedRoute();
    if (route != null) {
      await clearIntendedRoute();
    }
    return route;
  }

  // ==========================================
  // MÉTODOS DE PREFERENCIAS DE APLICACIÓN
  // ==========================================

  /// Guarda el tema preferido de la aplicación
  Future<void> saveAppTheme(String themeMode) async {
    await _ensureInitialized();
    await _prefs!.setString(_keyAppTheme, themeMode);
  }

  /// Obtiene el tema preferido de la aplicación
  Future<String?> getAppTheme() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyAppTheme);
  }

  /// Guarda el código de idioma preferido
  Future<void> saveLanguageCode(String languageCode) async {
    await _ensureInitialized();
    await _prefs!.setString(_keyLanguageCode, languageCode);
  }

  /// Obtiene el código de idioma preferido
  Future<String?> getLanguageCode() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyLanguageCode);
  }

  /// Marca si es el primer lanzamiento de la aplicación
  Future<void> markFirstLaunchComplete() async {
    await _ensureInitialized();
    await _prefs!.setBool(_keyFirstLaunch, false);
  }

  /// Verifica si es el primer lanzamiento
  Future<bool> isFirstLaunch() async {
    await _ensureInitialized();
    return _prefs!.getBool(_keyFirstLaunch) ?? true;
  }

  /// Guarda la última vez que se hizo backup
  Future<void> saveLastBackupTime() async {
    await _ensureInitialized();
    await _prefs!.setInt(
      _keyLastBackupTime,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Obtiene la última vez que se hizo backup
  Future<DateTime?> getLastBackupTime() async {
    await _ensureInitialized();
    final timestamp = _prefs!.getInt(_keyLastBackupTime);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  // ==========================================
  // MÉTODOS DE DATOS PERSONALIZADOS
  // ==========================================

  /// Guarda un valor string personalizado
  Future<void> saveString(String key, String value) async {
    await _ensureInitialized();
    await _prefs!.setString(key, value);
  }

  /// Obtiene un valor string personalizado
  Future<String?> getString(String key) async {
    await _ensureInitialized();
    return _prefs!.getString(key);
  }

  /// Guarda un valor int personalizado
  Future<void> saveInt(String key, int value) async {
    await _ensureInitialized();
    await _prefs!.setInt(key, value);
  }

  /// Obtiene un valor int personalizado
  Future<int?> getInt(String key) async {
    await _ensureInitialized();
    return _prefs!.getInt(key);
  }

  /// Guarda un valor bool personalizado
  Future<void> saveBool(String key, bool value) async {
    await _ensureInitialized();
    await _prefs!.setBool(key, value);
  }

  /// Obtiene un valor bool personalizado
  Future<bool?> getBool(String key) async {
    await _ensureInitialized();
    return _prefs!.getBool(key);
  }

  /// Guarda un objeto JSON personalizado
  Future<void> saveJson(String key, Map<String, dynamic> json) async {
    await _ensureInitialized();
    await _prefs!.setString(key, jsonEncode(json));
  }

  /// Obtiene un objeto JSON personalizado
  Future<Map<String, dynamic>?> getJson(String key) async {
    await _ensureInitialized();
    final jsonString = _prefs!.getString(key);

    if (jsonString != null) {
      try {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        // Si hay error al decodificar, remover datos corruptos
        await remove(key);
        return null;
      }
    }

    return null;
  }

  /// Remueve una clave específica
  Future<void> remove(String key) async {
    await _ensureInitialized();
    await _prefs!.remove(key);
  }

  /// Verifica si existe una clave
  Future<bool> containsKey(String key) async {
    await _ensureInitialized();
    return _prefs!.containsKey(key);
  }

  // ==========================================
  // MÉTODOS DE LIMPIEZA
  // ==========================================

  /// Limpia todos los datos de usuario (mantiene preferencias de app)
  Future<void> clearUserData() async {
    await _ensureInitialized();

    // Lista de claves relacionadas con datos de usuario
    const userKeys = [
      _keyIsLoggedIn,
      _keyUserId,
      _keyUserEmail,
      _keyUserName,
      _keyUserData,
      _keyLastLoginTime,
      _keyIntendedRoute,
      _keyRememberMe,
    ];

    for (final key in userKeys) {
      await _prefs!.remove(key);
    }
  }

  /// Limpia todas las preferencias de la aplicación
  Future<void> clearAppPreferences() async {
    await _ensureInitialized();

    const appKeys = [
      _keyAppTheme,
      _keyLanguageCode,
      _keyFirstLaunch,
      _keyLastBackupTime,
    ];

    for (final key in appKeys) {
      await _prefs!.remove(key);
    }
  }

  /// Limpia todos los datos almacenados
  Future<void> clearAll() async {
    await _ensureInitialized();
    await _prefs!.clear();
  }

  /// Reinicia completamente la aplicación (logout completo)
  Future<void> reset() async {
    await clearUserData();
    await clearIntendedRoute();
    // Mantener algunas preferencias como idioma y tema
  }

  // ==========================================
  // MÉTODOS DE UTILIDAD
  // ==========================================

  /// Asegura que el servicio esté inicializado
  Future<void> _ensureInitialized() async {
    if (_prefs == null) {
      await initialize();
    }
  }

  /// Obtiene todas las claves almacenadas
  Future<Set<String>> getAllKeys() async {
    await _ensureInitialized();
    return _prefs!.getKeys();
  }

  /// Obtiene estadísticas de almacenamiento
  Future<Map<String, dynamic>> getStorageStats() async {
    await _ensureInitialized();
    final keys = await getAllKeys();

    int stringCount = 0;
    int intCount = 0;
    int boolCount = 0;

    for (final key in keys) {
      final value = _prefs!.get(key);
      if (value is String) stringCount++;
      if (value is int) intCount++;
      if (value is bool) boolCount++;
    }

    return {
      'totalKeys': keys.length,
      'stringKeys': stringCount,
      'intKeys': intCount,
      'boolKeys': boolCount,
      'isLoggedIn': await isLoggedIn(),
      'lastLoginTime': await getLastLoginTime(),
    };
  }

  /// Valida la integridad de los datos almacenados
  Future<bool> validateStorageIntegrity() async {
    try {
      await _ensureInitialized();

      // Verificar que los datos críticos sean válidos
      final userData = await getUserData();
      final userIsLoggedIn = await isLoggedIn();

      // Si dice que está logueado pero no hay datos de usuario, hay inconsistencia
      if (userIsLoggedIn && userData == null) {
        await clearUserData();
        return false;
      }

      return true;
    } catch (e) {
      // Si hay cualquier error, limpiar todo por seguridad
      await clearAll();
      return false;
    }
  }

  /// Migra datos de versiones anteriores si es necesario
  Future<void> migrateDataIfNeeded() async {
    await _ensureInitialized();

    // Verificar si hay datos de versiones anteriores que necesiten migración
    // Este método se puede expandir según sea necesario

    // Por ejemplo, migrar formato de datos de usuario
    final oldUserData = _prefs!.getString('old_user_data_key');
    if (oldUserData != null) {
      // Migrar a nuevo formato
      await _prefs!.remove('old_user_data_key');
    }
  }
}

/// Extensión para facilitar el uso común del servicio
extension SessionPersistenceExtension on SessionPersistenceService {
  /// Método de conveniencia para logout completo
  Future<void> performLogout() async {
    await clearUserData();
    await clearIntendedRoute();
  }

  /// Método de conveniencia para verificar sesión válida
  Future<bool> hasValidSession() async {
    final loggedIn = await isLoggedIn();
    final userData = await getUserData();
    return loggedIn && userData != null;
  }

  /// Método de conveniencia para obtener info básica de usuario
  Future<Map<String, String?>> getBasicUserInfo() async {
    return {
      'id': await getUserId(),
      'email': await getUserEmail(),
      'name': await getUserName(),
    };
  }
}
