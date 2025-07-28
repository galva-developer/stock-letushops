# AuthRepositoryImpl

## Descripción
`AuthRepositoryImpl` es la implementación concreta del repositorio de autenticación que actúa como puente entre la capa de dominio y la capa de datos. Esta clase implementa la interfaz `AuthRepository` y delega todas las operaciones a `FirebaseAuthDataSource`.

## Responsabilidades

### 🌉 Puente Arquitectural
- **Implementa** la interfaz `AuthRepository` del dominio
- **Delega** operaciones a `FirebaseAuthDataSource`
- **Mantiene** la independencia del dominio respecto a Firebase
- **Proporciona** un punto único de acceso para operaciones de autenticación

### ✅ Validación de Entrada
- **Valida** parámetros antes de delegar a la fuente de datos
- **Sanitiza** datos de entrada (trim de emails, etc.)
- **Verifica** formatos (email válido, longitud de contraseña)
- **Lanza** excepciones específicas para errores de validación

### ⚠️ Manejo de Errores
- **Re-lanza** excepciones del dominio sin modificar
- **Convierte** errores inesperados a excepciones del dominio
- **Proporciona** mensajes de error consistentes
- **Maneja** fallos gracefully

## Arquitectura

### Constructor con Dependency Injection
```dart
const AuthRepositoryImpl(this._firebaseAuthDataSource);
```
- Recibe `FirebaseAuthDataSource` como dependencia
- Permite testear con mocks fácilmente
- Sigue principio de inversión de dependencias

### Patrón Repository
```dart
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _firebaseAuthDataSource;
  // Implementación de todos los métodos...
}
```

## Métodos Implementados

### 🔄 Estado de Autenticación

#### `authStateChanges`
```dart
Stream<AuthUser?> get authStateChanges {
  return _firebaseAuthDataSource.authStateChanges;
}
```
- **Función**: Expone el stream de cambios de autenticación
- **Delegación**: Directa a la fuente de datos
- **Conversión**: `UserModel` se trata como `AuthUser` (herencia)

#### `getCurrentUser()`
```dart
Future<AuthUser?> getCurrentUser() async {
  // Manejo de errores + delegación
}
```
- **Validación**: Ninguna (operación de lectura)
- **Delegación**: A `_firebaseAuthDataSource.getCurrentUser()`
- **Conversión**: Automática por herencia

### 🔐 Operaciones de Autenticación

#### `signInWithEmailAndPassword()`
```dart
Future<AuthUser> signInWithEmailAndPassword({
  required String email,
  required String password,
}) async {
  // Validaciones de entrada
  if (email.trim().isEmpty) {
    throw const RequiredFieldException(fieldName: 'email');
  }
  if (password.isEmpty) {
    throw const RequiredFieldException(fieldName: 'password');
  }
  if (!_isValidEmail(email)) {
    throw const InvalidEmailFormatException();
  }
  
  // Delegación
  return await _firebaseAuthDataSource.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}
```

**Validaciones Implementadas:**
- ✅ Email no vacío
- ✅ Password no vacío  
- ✅ Formato de email válido
- ✅ Trim automático de email

#### `registerWithEmailAndPassword()`
```dart
Future<AuthUser> registerWithEmailAndPassword({
  required String email,
  required String password,
  String? displayName,
}) async {
  // Validaciones adicionales para registro
}
```

**Validaciones Adicionales:**
- ✅ Longitud mínima de contraseña (6 caracteres)
- ✅ DisplayName vacío convertido a null
- ✅ Todas las validaciones de login

### 🔄 Gestión de Contraseñas

#### `sendPasswordResetEmail()`
```dart
Future<void> sendPasswordResetEmail({
  required String email,
}) async {
  // Validaciones + delegación
}
```

**Validaciones:**
- ✅ Email no vacío
- ✅ Formato de email válido

#### `updatePassword()`
```dart
Future<void> updatePassword({
  required String newPassword,
}) async {
  // Validaciones de contraseña + delegación
}
```

**Validaciones:**
- ✅ Nueva contraseña no vacía
- ✅ Longitud mínima (6 caracteres)

### 👤 Gestión de Perfil

#### `updateProfile()`
```dart
Future<AuthUser> updateProfile({
  String? displayName,
  String? photoURL,
}) async {
  // Validación de que se proporciona al menos un campo
}
```

**Validaciones Especiales:**
- ✅ Al menos un campo debe proporcionarse
- ✅ DisplayName vacío se convierte a null
- ✅ Sanitización de datos

### 🔐 Sistema de Permisos

#### `hasPermission()`
```dart
Future<bool> hasPermission(UserRole requiredRole) async {
  try {
    return await _firebaseAuthDataSource.hasPermission(requiredRole);
  } catch (e) {
    return false; // Denegar por seguridad en caso de error
  }
}
```

**Características:**
- 🔒 **Seguridad First**: Retorna `false` en caso de error
- 🔄 **Sin Validaciones**: Los roles son enum, no requieren validación
- ⚡ **Delegación Directa**: A la fuente de datos

#### `updateUserRole()` / `updateUserStatus()`
```dart
Future<void> updateUserRole({
  required String userId,
  required UserRole newRole,
}) async {
  // Validación de userId + delegación
}
```

**Validaciones:**
- ✅ UserId no vacío después de trim

### 👥 Gestión de Usuarios

#### `getAllUsers()`
```dart
Future<List<AuthUser>> getAllUsers({
  int? limit,
  String? startAfter,
}) async {
  // Validación de límite + delegación + conversión de tipos
}
```

**Validaciones:**
- ✅ Límite debe ser mayor a 0 si se proporciona
- 🔄 **Conversión**: `List<UserModel>` a `List<AuthUser>` vía cast

#### `searchUsers()`
```dart
Future<List<AuthUser>> searchUsers({
  required String query,
  int? limit,
}) async {
  // Validaciones + delegación + conversión
}
```

**Validaciones:**
- ✅ Query no vacío después de trim
- ✅ Límite debe ser mayor a 0 si se proporciona

## Validaciones Implementadas

### 📧 Validación de Email
```dart
bool _isValidEmail(String email) {
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email.trim());
}
```

**Características:**
- ✅ Expresión regular estándar
- ✅ Trim automático
- ✅ Validación completa de formato

### 🔒 Validación de Contraseña
- **Longitud mínima**: 6 caracteres
- **Campo requerido**: No puede estar vacío
- **Aplicada en**: Registro, cambio de contraseña

### 📝 Validación de Campos Requeridos
```dart
if (email.trim().isEmpty) {
  throw const RequiredFieldException(fieldName: 'email');
}
```

**Campos Validados:**
- `email`, `password`, `newPassword`
- `userId`, `query`
- Mensajes específicos por campo

### 📊 Validación de Parámetros Numéricos
```dart
if (limit != null && limit <= 0) {
  throw const UnknownAuthException(
    message: 'Limit must be greater than 0',
    userMessage: 'El límite debe ser mayor a 0',
  );
}
```

## Manejo de Errores

### Patrón de Manejo Estándar
```dart
try {
  // Validaciones locales
  // Delegación a fuente de datos
  return result;
} on AuthException {
  rethrow; // Re-lanzar excepciones del dominio
} catch (e) {
  throw AuthExceptionMapper.fromException(e);
}
```

### Tipos de Errores Manejados

#### 🔄 Re-lanzamiento
- **AuthException**: Se re-lanzan tal como están
- **Mantiene**: Información original del error
- **Preserva**: Stack trace y contexto

#### 🔄 Conversión
- **Errores Inesperados**: Se convierten a `AuthException`
- **Usa**: `AuthExceptionMapper.fromException()`
- **Consistencia**: Todos los errores salen como `AuthException`

#### 🔒 Seguridad
- **hasPermission()**: Retorna `false` en caso de error
- **Principio**: Denegar por defecto ante errores
- **Logging**: Implícito en la fuente de datos

## Principios de Clean Architecture

### 1. **Inversión de Dependencias** ✅
```dart
// Dominio define la interfaz
abstract class AuthRepository { ... }

// Datos implementa la interfaz
class AuthRepositoryImpl implements AuthRepository { ... }
```

### 2. **Independencia de Frameworks** ✅
- No depende directamente de Firebase
- Toda la lógica de Firebase está en la fuente de datos
- Puede cambiar implementación sin afectar el dominio

### 3. **Testeable** ✅
```dart
// Testing
final mockDataSource = MockFirebaseAuthDataSource();
final repository = AuthRepositoryImpl(mockDataSource);
```

### 4. **Responsabilidad Única** ✅
- **Solo** implementa la interfaz del repositorio
- **Solo** valida entrada y maneja errores
- **Solo** delega a la fuente de datos

### 5. **Abierto/Cerrado** ✅
- Abierto para extensión (nuevos métodos en interfaz)
- Cerrado para modificación (lógica de Firebase encapsulada)

## Características Avanzadas

### 🔄 Conversión de Tipos Automática
```dart
// UserModel hereda de AuthUser, cast es seguro
return users.cast<AuthUser>();
```

### 🧹 Sanitización de Datos
```dart
// Trim automático de emails
email: email.trim()

// DisplayName vacío a null
if (displayName != null && displayName.trim().isEmpty) {
  displayName = null;
}
```

### 📊 Validación de Parámetros Opcionales
```dart
// Validar límite solo si se proporciona
if (limit != null && limit <= 0) {
  throw const UnknownAuthException(...);
}
```

### 🔒 Seguridad en Permisos
```dart
// Fallar seguro en verificación de permisos
Future<bool> hasPermission(UserRole requiredRole) async {
  try {
    return await _firebaseAuthDataSource.hasPermission(requiredRole);
  } catch (e) {
    return false; // Denegar por seguridad
  }
}
```

## Testing

### Unit Testing
```dart
void main() {
  group('AuthRepositoryImpl', () {
    late MockFirebaseAuthDataSource mockDataSource;
    late AuthRepositoryImpl repository;

    setUp(() {
      mockDataSource = MockFirebaseAuthDataSource();
      repository = AuthRepositoryImpl(mockDataSource);
    });

    test('signInWithEmailAndPassword validates email format', () async {
      // Test validación de email
      expect(
        () => repository.signInWithEmailAndPassword(
          email: 'invalid-email',
          password: 'password',
        ),
        throwsA(isA<InvalidEmailFormatException>()),
      );
    });

    test('signInWithEmailAndPassword delegates to data source', () async {
      // Test delegación exitosa
      when(mockDataSource.signInWithEmailAndPassword(
        email: any,
        password: any,
      )).thenAnswer((_) async => testUser);

      final result = await repository.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password',
      );

      expect(result, equals(testUser));
      verify(mockDataSource.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password',
      )).called(1);
    });
  });
}
```

## Beneficios

1. **🔍 Validación Temprana**: Errores detectados antes de llegar a Firebase
2. **🏗️ Arquitectura Limpia**: Separación clara de responsabilidades
3. **🧪 Testeable**: Fácil mocking y testing unitario
4. **🔄 Reutilizable**: Interfaz estable independiente de implementación
5. **📊 Consistente**: Manejo uniforme de errores y validaciones
6. **🔒 Seguro**: Validaciones de seguridad y fail-safe en permisos
7. **📝 Documentado**: Cada método completamente documentado
8. **🧹 Limpio**: Sanitización automática de datos de entrada

Esta implementación proporciona una capa robusta y bien validada entre el dominio y los datos, cumpliendo todos los principios de Clean Architecture mientras añade valor mediante validaciones y manejo de errores consistente.
