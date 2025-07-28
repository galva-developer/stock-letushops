# AuthRepository Interface

## Descripción
La interfaz `AuthRepository` define el contrato que debe cumplir cualquier implementación del repositorio de autenticación. Esta interfaz pertenece a la capa de dominio y es completamente independiente de las implementaciones específicas como Firebase, REST APIs o cualquier otra tecnología.

## Principios de Clean Architecture

### Inversión de Dependencias
- La capa de dominio define la interfaz
- La capa de datos implementa la interfaz
- Las capas superiores dependen de la abstracción, no de la implementación

### Independencia de Frameworks
- No contiene referencias a Firebase o cualquier framework específico
- Puede ser implementada con cualquier tecnología de autenticación
- Facilita el testing mediante mocks

## Métodos Principales

### 🔄 Estado de Autenticación

#### `authStateChanges`
Stream que emite cambios en el estado de autenticación:
```dart
Stream<AuthUser?> get authStateChanges;
```
- Emite `AuthUser` cuando hay usuario autenticado
- Emite `null` cuando no hay usuario
- Permite reactive programming en la UI

#### `getCurrentUser()`
Obtiene el usuario actual de forma síncrona:
```dart
Future<AuthUser?> getCurrentUser();
```

### 🔐 Operaciones de Autenticación

#### `signInWithEmailAndPassword()`
Inicia sesión con credenciales:
```dart
Future<AuthUser> signInWithEmailAndPassword({
  required String email,
  required String password,
});
```

#### `registerWithEmailAndPassword()`
Registra nuevo usuario:
```dart
Future<AuthUser> registerWithEmailAndPassword({
  required String email,
  required String password,
  String? displayName,
});
```

#### `signOut()`
Cierra la sesión actual:
```dart
Future<void> signOut();
```

### 🔄 Gestión de Contraseñas

#### `sendPasswordResetEmail()`
Envía email de recuperación:
```dart
Future<void> sendPasswordResetEmail({
  required String email,
});
```

#### `updatePassword()`
Actualiza contraseña del usuario:
```dart
Future<void> updatePassword({
  required String newPassword,
});
```

#### `reauthenticate()`
Reautentica para operaciones sensibles:
```dart
Future<void> reauthenticate({
  required String password,
});
```

### 👤 Gestión de Perfil

#### `updateProfile()`
Actualiza datos del perfil:
```dart
Future<AuthUser> updateProfile({
  String? displayName,
  String? photoURL,
});
```

#### `sendEmailVerification()`
Envía email de verificación:
```dart
Future<void> sendEmailVerification();
```

#### `reloadUser()`
Recarga datos del servidor:
```dart
Future<AuthUser> reloadUser();
```

### 🗑️ Gestión de Cuenta

#### `deleteAccount()`
Elimina la cuenta del usuario:
```dart
Future<void> deleteAccount();
```

### 🔐 Permisos y Roles

#### `hasPermission()`
Verifica permisos del usuario:
```dart
Future<bool> hasPermission(UserRole requiredRole);
```

#### `updateUserRole()` (Admin)
Actualiza rol de usuario:
```dart
Future<void> updateUserRole({
  required String userId,
  required UserRole newRole,
});
```

#### `updateUserStatus()` (Admin)
Actualiza estado de usuario:
```dart
Future<void> updateUserStatus({
  required String userId,
  required UserStatus newStatus,
});
```

### 👥 Gestión de Usuarios (Admin)

#### `getAllUsers()`
Obtiene lista de usuarios:
```dart
Future<List<AuthUser>> getAllUsers({
  int? limit,
  String? startAfter,
});
```

#### `searchUsers()`
Busca usuarios:
```dart
Future<List<AuthUser>> searchUsers({
  required String query,
  int? limit,
});
```

#### `getUserById()`
Obtiene usuario específico:
```dart
Future<AuthUser> getUserById(String userId);
```

### ✅ Utilidades

#### `isEmailAvailable()`
Verifica disponibilidad de email:
```dart
Future<bool> isEmailAvailable(String email);
```

## Manejo de Excepciones

Cada método puede lanzar excepciones específicas del dominio:

### Excepciones Comunes
- `InvalidCredentialsException`: Credenciales incorrectas
- `UserNotFoundException`: Usuario no encontrado
- `EmailAlreadyInUseException`: Email ya registrado
- `WeakPasswordException`: Contraseña débil
- `SessionExpiredException`: Sesión expirada
- `NetworkException`: Problemas de conectividad
- `InsufficientPermissionsException`: Falta de permisos

### Ejemplo de Uso
```dart
try {
  final user = await authRepository.signInWithEmailAndPassword(
    email: 'user@example.com',
    password: 'password123',
  );
  print('Usuario autenticado: ${user.email}');
} on InvalidCredentialsException catch (e) {
  print('Credenciales incorrectas: ${e.userMessage}');
} on NetworkException catch (e) {
  print('Error de red: ${e.userMessage}');
} on AuthException catch (e) {
  print('Error de autenticación: ${e.userMessage}');
}
```

## Implementación

Esta interfaz será implementada por:
- `FirebaseAuthRepositoryImpl`: Implementación con Firebase
- `MockAuthRepository`: Mock para testing
- Otras implementaciones futuras (REST API, GraphQL, etc.)

## Testing

La interfaz facilita el testing mediante dependency injection:

```dart
// En tests
final mockRepository = MockAuthRepository();
when(mockRepository.getCurrentUser())
    .thenAnswer((_) async => testUser);

// En producción
final repository = FirebaseAuthRepositoryImpl();
```

## Reactive Programming

El `authStateChanges` stream permite reactive programming:

```dart
// En un Provider o BLoC
authRepository.authStateChanges.listen((user) {
  if (user != null) {
    // Usuario autenticado
    navigateToHome();
  } else {
    // Usuario no autenticado
    navigateToLogin();
  }
});
```

## Características Avanzadas

### Paginación
Los métodos de listado soportan paginación:
```dart
final firstPage = await authRepository.getAllUsers(limit: 10);
final secondPage = await authRepository.getAllUsers(
  limit: 10,
  startAfter: firstPage.last.uid,
);
```

### Búsqueda
Búsqueda flexible de usuarios:
```dart
final results = await authRepository.searchUsers(
  query: 'juan',
  limit: 5,
);
```

### Gestión de Roles
Sistema completo de roles y permisos:
```dart
// Verificar permisos
final canManage = await authRepository.hasPermission(UserRole.manager);

if (canManage) {
  // Realizar acción de manager
}
```

## Beneficios

1. **Testeable**: Fácil mocking para tests unitarios
2. **Flexible**: Puede cambiar implementación sin afectar el dominio
3. **Documentado**: Cada método tiene documentación completa
4. **Tipado**: Fuertemente tipado con excepciones específicas
5. **Escalable**: Soporta funcionalidades avanzadas como roles y búsqueda
6. **Reactivo**: Stream para cambios de estado en tiempo real
