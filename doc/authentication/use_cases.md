# Authentication Use Cases

## Descripción General
Los casos de uso (Use Cases) representan la lógica de negocio específica de la aplicación en la capa de dominio. Cada caso de uso encapsula una acción específica que el usuario puede realizar en el sistema de autenticación.

## Principios de Clean Architecture

### 🎯 **Responsabilidad Única**
- Cada caso de uso tiene **una sola responsabilidad** específica
- **LoginUseCase**: Solo maneja el inicio de sesión
- **RegisterUseCase**: Solo maneja el registro de usuarios
- **LogoutUseCase**: Solo maneja el cierre de sesión
- **ResetPasswordUseCase**: Solo maneja el restablecimiento de contraseñas
- **GetCurrentUserUseCase**: Solo obtiene el usuario actual

### 🏗️ **Independencia de Frameworks**
- No dependen de Firebase directamente
- Usan la abstracción `AuthRepository`
- Pueden cambiar de proveedor sin modificar la lógica
- Fácilmente testeable con mocks

### 🔄 **Inversión de Dependencias**
```dart
class LoginUseCase {
  final AuthRepository _authRepository; // Depende de abstracción
  
  const LoginUseCase(this._authRepository); // Dependency Injection
}
```

## Casos de Uso Implementados

### 1. **LoginUseCase** 🔐

**Propósito**: Autenticar usuario con email y contraseña

**Parámetros de Entrada**:
- `email` (String, requerido): Email del usuario
- `password` (String, requerido): Contraseña del usuario

**Salida**:
- `Future<AuthUser>`: Usuario autenticado exitosamente

**Excepciones Posibles**:
- `InvalidCredentialsException`: Credenciales incorrectas
- `UserNotFoundException`: Usuario no existe
- `UserDisabledException`: Usuario deshabilitado
- `RequiredFieldException`: Campos obligatorios vacíos
- `InvalidEmailFormatException`: Email con formato inválido

**Ejemplo de Uso**:
```dart
final loginUseCase = LoginUseCase(authRepository);
try {
  final user = await loginUseCase.call(
    email: 'usuario@ejemplo.com',
    password: 'miPassword123',
  );
  // Login exitoso, redirigir a pantalla principal
  Navigator.pushReplacementNamed(context, '/home');
} on InvalidCredentialsException {
  // Mostrar error de credenciales
  showError('Email o contraseña incorrectos');
} on UserDisabledException {
  // Mostrar error de usuario deshabilitado
  showError('Tu cuenta ha sido deshabilitada');
} catch (e) {
  // Error genérico
  showError('Error al iniciar sesión');
}
```

### 2. **RegisterUseCase** 📝

**Propósito**: Registrar nuevo usuario en el sistema

**Parámetros de Entrada**:
- `email` (String, requerido): Email único del nuevo usuario
- `password` (String, requerido): Contraseña (mínimo 6 caracteres)
- `displayName` (String?, opcional): Nombre para mostrar

**Salida**:
- `Future<AuthUser>`: Usuario registrado exitosamente

**Excepciones Posibles**:
- `EmailAlreadyInUseException`: Email ya registrado
- `WeakPasswordException`: Contraseña muy débil
- `RequiredFieldException`: Campos obligatorios vacíos
- `InvalidEmailFormatException`: Email con formato inválido

**Ejemplo de Uso**:
```dart
final registerUseCase = RegisterUseCase(authRepository);
try {
  final user = await registerUseCase.call(
    email: formData.email,
    password: formData.password,
    displayName: formData.name,
  );
  // Registro exitoso, mostrar bienvenida
  showSuccess('¡Bienvenido ${user.displayName}!');
} on EmailAlreadyInUseException {
  showError('Este email ya está registrado');
} on WeakPasswordException {
  showError('La contraseña debe tener al menos 6 caracteres');
} catch (e) {
  showError('Error al registrar usuario');
}
```

### 3. **LogoutUseCase** 🚪

**Propósito**: Cerrar sesión del usuario actual

**Parámetros de Entrada**: Ninguno

**Salida**:
- `Future<void>`: Operación completada

**Excepciones Posibles**:
- `NoUserSignedInException`: No hay usuario autenticado
- `UnknownAuthException`: Error genérico al cerrar sesión

**Ejemplo de Uso**:
```dart
final logoutUseCase = LogoutUseCase(authRepository);
try {
  await logoutUseCase.call();
  // Logout exitoso, redirigir a login
  Navigator.pushNamedAndRemoveUntil(
    context,
    '/login',
    (route) => false,
  );
} catch (e) {
  showError('Error al cerrar sesión');
}
```

### 4. **ResetPasswordUseCase** 🔑

**Propósito**: Enviar email de restablecimiento de contraseña

**Parámetros de Entrada**:
- `email` (String, requerido): Email del usuario

**Salida**:
- `Future<void>`: Email enviado exitosamente

**Excepciones Posibles**:
- `UserNotFoundException`: Email no registrado (puede no lanzarse por seguridad)
- `RequiredFieldException`: Email vacío
- `InvalidEmailFormatException`: Email con formato inválido

**Ejemplo de Uso**:
```dart
final resetPasswordUseCase = ResetPasswordUseCase(authRepository);
try {
  await resetPasswordUseCase.call(email: emailController.text);
  showSuccess(
    'Te hemos enviado un email con instrucciones para restablecer tu contraseña'
  );
} on UserNotFoundException {
  showError('No existe una cuenta con este email');
} catch (e) {
  showError('Error al enviar email de recuperación');
}
```

### 5. **GetCurrentUserUseCase** 👤

**Propósito**: Obtener información del usuario autenticado

**Parámetros de Entrada**: Ninguno

**Salida**:
- `Future<AuthUser?>`: Usuario actual o null si no está autenticado

**Excepciones Posibles**:
- `UnknownAuthException`: Error al acceder a datos del usuario

**Ejemplo de Uso**:
```dart
final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);
try {
  final user = await getCurrentUserUseCase.call();
  if (user != null) {
    // Usuario autenticado, mostrar información
    setState(() {
      currentUser = user;
      isAuthenticated = true;
    });
  } else {
    // No hay usuario, redirigir a login
    Navigator.pushReplacementNamed(context, '/login');
  }
} catch (e) {
  showError('Error al obtener información del usuario');
}
```

## Patrones de Uso

### 1. **Patrón Call Method**
```dart
// Todos los casos de uso usan el método call()
final result = await useCase.call(parameters);

// Equivalente a:
final result = await useCase(parameters);
```

### 2. **Dependency Injection**
```dart
// En la configuración de dependencias (main.dart o provider)
final authRepository = AuthRepositoryImpl(firebaseDataSource);
final loginUseCase = LoginUseCase(authRepository);
final registerUseCase = RegisterUseCase(authRepository);

// En providers o widgets
Provider<LoginUseCase>(
  create: (_) => LoginUseCase(context.read<AuthRepository>()),
)
```

### 3. **Manejo de Errores Consistente**
```dart
try {
  final result = await useCase.call(parameters);
  // Manejar éxito
} on SpecificAuthException catch (e) {
  // Manejar error específico
  showError(e.userMessage);
} on AuthException catch (e) {
  // Manejar error genérico de auth
  showError(e.userMessage);
} catch (e) {
  // Error inesperado
  showError('Ha ocurrido un error inesperado');
}
```

## Testing de Casos de Uso

### Unit Testing Ejemplo
```dart
void main() {
  group('LoginUseCase', () {
    late MockAuthRepository mockRepository;
    late LoginUseCase loginUseCase;

    setUp(() {
      mockRepository = MockAuthRepository();
      loginUseCase = LoginUseCase(mockRepository);
    });

    test('should return AuthUser when login is successful', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final expectedUser = AuthUser(
        uid: '123',
        email: email,
        displayName: 'Test User',
      );

      when(mockRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => expectedUser);

      // Act
      final result = await loginUseCase.call(
        email: email,
        password: password,
      );

      // Assert
      expect(result, equals(expectedUser));
      verify(mockRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).called(1);
    });

    test('should throw InvalidCredentialsException when credentials are wrong', () async {
      // Arrange
      when(mockRepository.signInWithEmailAndPassword(
        email: any,
        password: any,
      )).thenThrow(const InvalidCredentialsException());

      // Act & Assert
      expect(
        () => loginUseCase.call(
          email: 'test@example.com',
          password: 'wrongpassword',
        ),
        throwsA(isA<InvalidCredentialsException>()),
      );
    });
  });
}
```

## Integración con Presentación

### Provider Pattern
```dart
class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthProvider(
    this._loginUseCase,
    this._logoutUseCase,
    this._getCurrentUserUseCase,
  );

  AuthUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  AuthUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get errorMessage => _errorMessage;

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      _currentUser = await _loginUseCase.call(
        email: email,
        password: password,
      );
      _errorMessage = null;
    } on AuthException catch (e) {
      _errorMessage = e.userMessage;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      await _logoutUseCase.call();
      _currentUser = null;
      _errorMessage = null;
    } on AuthException catch (e) {
      _errorMessage = e.userMessage;
    }
  }

  Future<void> checkAuthState() async {
    try {
      _currentUser = await _getCurrentUserUseCase.call();
    } catch (e) {
      _currentUser = null;
    }
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
```

## Beneficios de esta Arquitectura

### 1. **Testabilidad** 🧪
- Cada caso de uso es independiente y fácil de testear
- Mocking simple del repository
- Tests rápidos sin dependencias externas

### 2. **Reutilización** 🔄
- Los casos de uso pueden ser reutilizados en diferentes pantallas
- Lógica de negocio centralizada
- Fácil compartir entre diferentes interfaces

### 3. **Mantenibilidad** 🛠️
- Cambios en lógica de negocio centralizados
- Fácil agregar nuevos casos de uso
- Separación clara de responsabilidades

### 4. **Flexibilidad** 🚀
- Fácil cambiar implementación del repository
- Casos de uso independientes del framework UI
- Escalabilidad para nuevas funcionalidades

### 5. **Claridad** 📖
- Cada caso de uso representa una acción específica del usuario
- Documentación clara de entrada y salida
- Fácil entender el flujo de la aplicación

Esta implementación de casos de uso proporciona una base sólida y flexible para el sistema de autenticación, siguiendo todos los principios de Clean Architecture.
