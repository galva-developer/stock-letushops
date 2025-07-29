import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/exceptions/auth_exceptions.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

/// Provider principal para la gestión del estado de autenticación
///
/// Este provider maneja todo el estado relacionado con autenticación
/// y expone métodos para realizar operaciones de autenticación.
///
/// Utiliza el patrón State Machine para garantizar consistencia
/// en los estados y facilitar el manejo desde la UI.
///
/// Ejemplo de uso:
/// ```dart
/// final authProvider = context.read<AuthProvider>();
/// await authProvider.login('email@ejemplo.com', 'password');
///
/// // En la UI
/// Consumer<AuthProvider>(
///   builder: (context, authProvider, child) {
///     return authProvider.state.when(
///       loading: () => CircularProgressIndicator(),
///       authenticated: (user) => HomePage(user: user),
///       unauthenticated: () => LoginPage(),
///       error: (error) => ErrorWidget(error),
///     );
///   },
/// )
/// ```
class AuthProvider extends ChangeNotifier {
  // Casos de uso
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final AuthRepository _authRepository;

  // Estado interno
  AuthState _state = const AuthInitial();
  StreamSubscription<AuthUser?>? _authStateSubscription;

  /// Constructor que recibe todas las dependencias
  AuthProvider({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required AuthRepository authRepository,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _authRepository = authRepository {
    _init();
  }

  /// Estado actual de autenticación
  AuthState get state => _state;

  /// Getters de conveniencia para la UI
  bool get isAuthenticated => _state.isAuthenticated;
  bool get isLoading => _state.isLoading;
  bool get hasError => _state.hasError;
  AuthUser? get currentUser => _state.user;
  String? get errorMessage => _state.errorMessage;
  String? get successMessage => _state.successMessage;

  /// Inicializa el provider y escucha cambios de autenticación
  void _init() {
    _listenToAuthChanges();
    _checkInitialAuthState();
  }

  /// Escucha los cambios en el estado de autenticación de Firebase
  void _listenToAuthChanges() {
    _authStateSubscription = _authRepository.authStateChanges.listen(
      (user) {
        if (user != null) {
          _setState(AuthAuthenticated(user: user));
        } else {
          // Solo cambiar a unauthenticated si no estamos en loading
          // para evitar parpadeos durante operaciones
          if (!_state.isLoading) {
            _setState(const AuthUnauthenticated());
          }
        }
      },
      onError: (error) {
        _handleError(error, 'Error en el estado de autenticación');
      },
    );
  }

  /// Verifica el estado inicial de autenticación
  Future<void> _checkInitialAuthState() async {
    try {
      final user = await _getCurrentUserUseCase.call();
      if (user != null) {
        _setState(AuthAuthenticated(user: user));
      } else {
        _setState(const AuthUnauthenticated());
      }
    } catch (e) {
      _setState(const AuthUnauthenticated());
    }
  }

  /// Inicia sesión con email y contraseña
  ///
  /// [email] Email del usuario
  /// [password] Contraseña del usuario
  ///
  /// Retorna true si el login fue exitoso, false en caso contrario
  Future<bool> login(String email, String password) async {
    try {
      _setState(const AuthLoading(message: 'Iniciando sesión...'));

      final user = await _loginUseCase.call(email: email, password: password);

      _setState(AuthAuthenticated(user: user));
      return true;
    } catch (e) {
      _handleError(e, 'Error al iniciar sesión');
      return false;
    }
  }

  /// Registra un nuevo usuario
  ///
  /// [email] Email del nuevo usuario
  /// [password] Contraseña del nuevo usuario
  /// [displayName] Nombre para mostrar (opcional)
  ///
  /// Retorna true si el registro fue exitoso, false en caso contrario
  Future<bool> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      _setState(const AuthLoading(message: 'Creando cuenta...'));

      final user = await _registerUseCase.call(
        email: email,
        password: password,
        displayName: displayName,
      );

      _setState(AuthAuthenticated(user: user));
      return true;
    } catch (e) {
      _handleError(e, 'Error al crear la cuenta');
      return false;
    }
  }

  /// Cierra la sesión del usuario actual
  ///
  /// Retorna true si el logout fue exitoso, false en caso contrario
  Future<bool> logout() async {
    try {
      _setState(const AuthLoading(message: 'Cerrando sesión...'));

      await _logoutUseCase.call();

      _setState(
        const AuthUnauthenticated(message: 'Sesión cerrada exitosamente'),
      );
      return true;
    } catch (e) {
      _handleError(e, 'Error al cerrar sesión');
      return false;
    }
  }

  /// Envía un email para restablecer la contraseña
  ///
  /// [email] Email del usuario que quiere restablecer su contraseña
  ///
  /// Retorna true si el email fue enviado exitosamente, false en caso contrario
  Future<bool> resetPassword(String email) async {
    try {
      _setState(
        const AuthLoading(message: 'Enviando email de recuperación...'),
      );

      await _resetPasswordUseCase.call(email: email);

      // Mantener el estado anterior pero mostrar mensaje de éxito
      final currentUser = _state.user;
      _setState(
        AuthSuccess(
          message:
              'Te hemos enviado un email con instrucciones para restablecer tu contraseña',
          user: currentUser,
        ),
      );

      // Después de 3 segundos, volver al estado anterior
      Timer(const Duration(seconds: 3), () {
        if (currentUser != null) {
          _setState(AuthAuthenticated(user: currentUser));
        } else {
          _setState(const AuthUnauthenticated());
        }
      });

      return true;
    } catch (e) {
      _handleError(e, 'Error al enviar email de recuperación');
      return false;
    }
  }

  /// Actualiza la información del usuario actual
  ///
  /// Útil después de operaciones que modifican el perfil del usuario
  Future<void> refreshUser() async {
    if (!isAuthenticated) return;

    try {
      final user = await _getCurrentUserUseCase.call();
      if (user != null) {
        _setState(AuthAuthenticated(user: user));
      } else {
        _setState(const AuthUnauthenticated());
      }
    } catch (e) {
      // En caso de error al refrescar, mantener el estado actual
      debugPrint('Error al refrescar usuario: $e');
    }
  }

  /// Limpia cualquier mensaje de error o éxito
  ///
  /// Útil para limpiar mensajes después de mostrarlos en la UI
  void clearMessages() {
    if (_state is AuthError || _state is AuthSuccess) {
      final user = _state.user;
      if (user != null) {
        _setState(AuthAuthenticated(user: user));
      } else {
        _setState(const AuthUnauthenticated());
      }
    }
  }

  /// Verifica si el usuario actual tiene un rol específico
  ///
  /// [requiredRole] Rol requerido para la verificación
  ///
  /// Retorna true si el usuario tiene el rol, false en caso contrario
  Future<bool> hasPermission(UserRole requiredRole) async {
    if (!isAuthenticated) return false;

    try {
      return await _authRepository.hasPermission(requiredRole);
    } catch (e) {
      debugPrint('Error al verificar permisos: $e');
      return false;
    }
  }

  /// Maneja errores y los convierte al estado apropiado
  void _handleError(dynamic error, String fallbackMessage) {
    String userMessage = fallbackMessage;
    String? errorCode;

    if (error is AuthException) {
      userMessage = error.userMessage;
      errorCode = error.runtimeType.toString();
    }

    _setState(
      AuthError(
        message: error.toString(),
        userMessage: userMessage,
        errorCode: errorCode,
      ),
    );
  }

  /// Actualiza el estado y notifica a los listeners
  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}

/// Factory para crear instancias de AuthProvider con dependencias
///
/// Facilita la configuración del provider en el main.dart o en tests
class AuthProviderFactory {
  /// Crea una instancia de AuthProvider con todas las dependencias configuradas
  static AuthProvider create({required AuthRepository authRepository}) {
    // Crear casos de uso
    final loginUseCase = LoginUseCase(authRepository);
    final registerUseCase = RegisterUseCase(authRepository);
    final logoutUseCase = LogoutUseCase(authRepository);
    final resetPasswordUseCase = ResetPasswordUseCase(authRepository);
    final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);

    // Crear y retornar el provider
    return AuthProvider(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
      logoutUseCase: logoutUseCase,
      resetPasswordUseCase: resetPasswordUseCase,
      getCurrentUserUseCase: getCurrentUserUseCase,
      authRepository: authRepository,
    );
  }
}
