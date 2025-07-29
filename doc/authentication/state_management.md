# Authentication State Management

## Descripción General
El sistema de gestión de estado de autenticación implementa el patrón **State Machine** usando **Provider** para manejar todos los estados posibles del sistema de autenticación de manera consistente y predecible.

## Arquitectura del Estado

### 🏗️ **Patrón State Machine**
```dart
AuthState
├── AuthInitial          // Estado inicial
├── AuthLoading          // Operaciones en progreso
├── AuthAuthenticated    // Usuario autenticado
├── AuthUnauthenticated  // Sin usuario
├── AuthError           // Errores
└── AuthSuccess         // Operaciones exitosas
```

### 📊 **Flujo de Estados**
```
AuthInitial
    ↓
AuthLoading (verificando estado)
    ↓
AuthAuthenticated / AuthUnauthenticated
    ↓
[Operaciones de usuario]
    ↓
AuthLoading → AuthAuthenticated/Error/Success
```

## Componentes Principales

### 1. **AuthState** 📋

#### **Estados Implementados**

##### `AuthInitial`
```dart
const AuthInitial();
```
- **Propósito**: Estado inicial al arrancar la aplicación
- **Duración**: Muy breve, solo hasta verificar el estado de autenticación
- **UI**: Pantalla de splash o loading inicial

##### `AuthLoading`
```dart
const AuthLoading({String? message});
```
- **Propósito**: Indica operación en progreso
- **Casos de uso**: Login, registro, logout, reset password
- **UI**: Indicadores de carga, deshabilitar controles
- **Mensaje opcional**: Para mostrar información específica al usuario

##### `AuthAuthenticated`
```dart
const AuthAuthenticated({required AuthUser user});
```
- **Propósito**: Usuario exitosamente autenticado
- **Datos**: Contiene información completa del usuario
- **UI**: Pantallas protegidas, información del perfil
- **Método `copyWith()`**: Para actualizar información del usuario

##### `AuthUnauthenticated`
```dart
const AuthUnauthenticated({String? message});
```
- **Propósito**: No hay usuario autenticado
- **Casos**: Logout exitoso, sesión expirada, estado inicial sin usuario
- **UI**: Pantallas de login/registro
- **Mensaje opcional**: Para mostrar información de logout

##### `AuthError`
```dart
const AuthError({
  required String message,
  required String userMessage,
  String? errorCode,
});
```
- **Propósito**: Error en operaciones de autenticación
- **Datos**: Mensaje técnico, mensaje de usuario, código de error
- **UI**: Mostrar alertas, mensajes de error
- **Recuperación**: Permite reintentar operaciones

##### `AuthSuccess`
```dart
const AuthSuccess({
  required String message,
  AuthUser? user,
});
```
- **Propósito**: Operaciones exitosas que no cambian autenticación
- **Casos**: Reset password enviado, perfil actualizado
- **UI**: Mostrar mensajes de confirmación
- **Temporal**: Se limpia automáticamente después de un tiempo

#### **Extensiones Útiles**
```dart
extension AuthStateExtensions on AuthState {
  bool get isAuthenticated;    // ¿Usuario autenticado?
  bool get isLoading;          // ¿Operación en progreso?
  bool get hasError;           // ¿Hay error?
  bool get hasSuccess;         // ¿Operación exitosa?
  AuthUser? get user;          // Usuario actual o null
  String? get errorMessage;    // Mensaje de error
  String? get successMessage;  // Mensaje de éxito
  String? get displayMessage;  // Cualquier mensaje para mostrar
}
```

### 2. **AuthProvider** 🔄

#### **Responsabilidades**

##### **Gestión de Estado**
- Mantiene el estado actual de autenticación
- Notifica cambios a los widgets suscritos
- Garantiza transiciones de estado consistentes
- Maneja timers para limpiar mensajes temporales

##### **Operaciones de Autenticación**
```dart
// Login
Future<bool> login(String email, String password);

// Registro
Future<bool> register({
  required String email,
  required String password,
  String? displayName,
});

// Logout
Future<bool> logout();

// Reset Password
Future<bool> resetPassword(String email);

// Actualizar usuario
Future<void> refreshUser();
```

##### **Escucha de Cambios Automáticos**
```dart
// Stream de Firebase Auth
_authRepository.authStateChanges.listen((user) {
  if (user != null) {
    _setState(AuthAuthenticated(user: user));
  } else {
    _setState(const AuthUnauthenticated());
  }
});
```

#### **Características Avanzadas**

##### **Factory Pattern**
```dart
class AuthProviderFactory {
  static AuthProvider create({
    required AuthRepository authRepository,
  }) {
    // Configuración automática de todas las dependencias
    return AuthProvider(/* dependencias */);
  }
}
```

##### **Manejo de Errores Inteligente**
```dart
void _handleError(dynamic error, String fallbackMessage) {
  String userMessage = fallbackMessage;
  String? errorCode;

  if (error is AuthException) {
    userMessage = error.userMessage;
    errorCode = error.runtimeType.toString();
  }

  _setState(AuthError(
    message: error.toString(),
    userMessage: userMessage,
    errorCode: errorCode,
  ));
}
```

##### **Gestión de Permisos**
```dart
Future<bool> hasPermission(UserRole requiredRole) async {
  if (!isAuthenticated) return false;
  
  try {
    return await _authRepository.hasPermission(requiredRole);
  } catch (e) {
    return false; // Fallar seguro
  }
}
```

##### **Auto-limpieza de Mensajes**
```dart
// Los mensajes de éxito se limpian automáticamente
Timer(const Duration(seconds: 3), () {
  if (currentUser != null) {
    _setState(AuthAuthenticated(user: currentUser));
  } else {
    _setState(const AuthUnauthenticated());
  }
});
```

## Integración con la UI

### 1. **Configuración en main.dart**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Configurar dependencias
        Provider<AuthRepository>(
          create: (_) => AuthRepositoryImpl(FirebaseAuthDataSource()),
        ),
        
        // Configurar AuthProvider
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProviderFactory.create(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        home: AuthWrapper(),
      ),
    );
  }
}
```

### 2. **AuthWrapper para Navegación Automática**
```dart
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final state = authProvider.state;
        
        if (state is AuthInitial || state is AuthLoading) {
          return const SplashPage();
        }
        
        if (state is AuthAuthenticated) {
          return const HomePage();
        }
        
        return const LoginPage();
      },
    );
  }
}
```

### 3. **Uso en Páginas Específicas**

#### **LoginPage**
```dart
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Mostrar mensaje de error si existe
          if (authProvider.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(authProvider.errorMessage ?? 'Error desconocido'),
                  backgroundColor: Colors.red,
                ),
              );
              authProvider.clearMessages();
            });
          }

          return Column(
            children: [
              // Campos de entrada
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                enabled: !authProvider.isLoading,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                enabled: !authProvider.isLoading,
              ),
              
              // Botón de login
              ElevatedButton(
                onPressed: authProvider.isLoading ? null : _handleLogin,
                child: authProvider.isLoading
                    ? CircularProgressIndicator()
                    : Text('Iniciar Sesión'),
              ),
              
              // Botón de reset password
              TextButton(
                onPressed: authProvider.isLoading ? null : _handleResetPassword,
                child: Text('¿Olvidaste tu contraseña?'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleLogin() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _emailController.text,
      _passwordController.text,
    );
    
    if (success) {
      // Navegación se maneja automáticamente por AuthWrapper
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _handleResetPassword() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.resetPassword(_emailController.text);
  }
}
```

#### **Páginas Protegidas**
```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        
        if (user == null) {
          // Redireccionar a login si no hay usuario
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return SplashPage();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Bienvenido ${user.displayName ?? user.email}'),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () => _handleLogout(context),
              ),
            ],
          ),
          body: Column(
            children: [
              // Información del usuario
              UserInfo(user: user),
              
              // Contenido específico según rol
              if (user.isAdmin) 
                AdminPanel()
              else if (user.isManager)
                ManagerPanel()
              else
                EmployeePanel(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.logout();
    
    if (success) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }
  }
}
```

### 4. **Widgets Reutilizables**

#### **AuthStateBuilder**
```dart
class AuthStateBuilder extends StatelessWidget {
  final Widget Function() onInitial;
  final Widget Function(String? message) onLoading;
  final Widget Function(AuthUser user) onAuthenticated;
  final Widget Function(String? message) onUnauthenticated;
  final Widget Function(String message) onError;
  final Widget Function(String message, AuthUser? user) onSuccess;

  const AuthStateBuilder({
    Key? key,
    required this.onInitial,
    required this.onLoading,
    required this.onAuthenticated,
    required this.onUnauthenticated,
    required this.onError,
    required this.onSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final state = authProvider.state;

        if (state is AuthInitial) {
          return onInitial();
        } else if (state is AuthLoading) {
          return onLoading(state.message);
        } else if (state is AuthAuthenticated) {
          return onAuthenticated(state.user);
        } else if (state is AuthUnauthenticated) {
          return onUnauthenticated(state.message);
        } else if (state is AuthError) {
          return onError(state.userMessage);
        } else if (state is AuthSuccess) {
          return onSuccess(state.message, state.user);
        }

        return onInitial(); // Fallback
      },
    );
  }
}
```

#### **ProtectedRoute**
```dart
class ProtectedRoute extends StatelessWidget {
  final Widget child;
  final UserRole? requiredRole;
  final Widget? fallback;

  const ProtectedRoute({
    Key? key,
    required this.child,
    this.requiredRole,
    this.fallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (!authProvider.isAuthenticated) {
          return fallback ?? LoginPage();
        }

        if (requiredRole != null) {
          return FutureBuilder<bool>(
            future: authProvider.hasPermission(requiredRole!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.data == true) {
                return child;
              }

              return fallback ?? UnauthorizedPage();
            },
          );
        }

        return child;
      },
    );
  }
}
```

## Testing

### 1. **Unit Testing del AuthProvider**
```dart
void main() {
  group('AuthProvider', () {
    late MockAuthRepository mockRepository;
    late AuthProvider authProvider;

    setUp(() {
      mockRepository = MockAuthRepository();
      authProvider = AuthProviderFactory.create(
        authRepository: mockRepository,
      );
    });

    test('initial state should be AuthInitial', () {
      expect(authProvider.state, isA<AuthInitial>());
    });

    test('login should update state to AuthAuthenticated on success', () async {
      // Arrange
      final testUser = AuthUser(uid: '123', email: 'test@example.com');
      when(mockRepository.signInWithEmailAndPassword(
        email: any,
        password: any,
      )).thenAnswer((_) async => testUser);

      // Act
      final result = await authProvider.login('test@example.com', 'password');

      // Assert
      expect(result, true);
      expect(authProvider.state, isA<AuthAuthenticated>());
      expect(authProvider.currentUser, equals(testUser));
    });

    test('login should update state to AuthError on failure', () async {
      // Arrange
      when(mockRepository.signInWithEmailAndPassword(
        email: any,
        password: any,
      )).thenThrow(const InvalidCredentialsException());

      // Act
      final result = await authProvider.login('test@example.com', 'wrong');

      // Assert
      expect(result, false);
      expect(authProvider.state, isA<AuthError>());
      expect(authProvider.errorMessage, isNotNull);
    });
  });
}
```

### 2. **Widget Testing**
```dart
void main() {
  group('AuthWrapper Widget Tests', () {
    testWidgets('shows SplashPage when state is AuthInitial', (tester) async {
      // Arrange
      final mockProvider = MockAuthProvider();
      when(mockProvider.state).thenReturn(const AuthInitial());

      // Act
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: mockProvider,
          child: MaterialApp(home: AuthWrapper()),
        ),
      );

      // Assert
      expect(find.byType(SplashPage), findsOneWidget);
    });

    testWidgets('shows HomePage when state is AuthAuthenticated', (tester) async {
      // Arrange
      final mockProvider = MockAuthProvider();
      final testUser = AuthUser(uid: '123', email: 'test@example.com');
      when(mockProvider.state).thenReturn(AuthAuthenticated(user: testUser));

      // Act
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: mockProvider,
          child: MaterialApp(home: AuthWrapper()),
        ),
      );

      // Assert
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
```

## Beneficios de esta Arquitectura

### 1. **Predictibilidad** 🎯
- Estados claramente definidos
- Transiciones controladas
- Behavior consistente

### 2. **Testabilidad** 🧪
- Estados fáciles de mockear
- Casos de uso bien definidos
- Separación clara de responsabilidades

### 3. **Mantenibilidad** 🛠️
- Código organizado y legible
- Fácil agregar nuevos estados
- Cambios localizados

### 4. **Performance** ⚡
- Actualizaciones eficientes de UI
- Streams optimizados
- Limpieza automática de recursos

### 5. **Developer Experience** 👩‍💻
- API clara y consistente
- Extensiones útiles
- Widgets reutilizables
- Factory pattern para setup fácil

### 6. **Error Handling** ⚠️
- Manejo robusto de errores
- Mensajes de usuario amigables
- Recuperación graceful

Esta implementación proporciona una base sólida y escalable para manejar todo el estado de autenticación en la aplicación, garantizando una experiencia de usuario fluida y un código mantenible.
