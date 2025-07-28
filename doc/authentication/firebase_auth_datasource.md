# FirebaseAuthDataSource

## Descripción
`FirebaseAuthDataSource` es la implementación concreta de la fuente de datos de autenticación que se conecta directamente con Firebase Authentication y Cloud Firestore. Esta clase es responsable de todas las operaciones de bajo nivel relacionadas con la autenticación y la sincronización de datos de usuario.

## Responsabilidades

### 🔥 Conexión con Firebase
- Gestiona la conexión con Firebase Authentication
- Sincroniza datos con Cloud Firestore
- Maneja el estado de autenticación en tiempo real

### 🔄 Transformación de Datos
- Convierte objetos `User` de Firebase a `UserModel`
- Combina datos de Firebase Auth con datos extendidos de Firestore
- Maneja la serialización/deserialización de documentos

### ⚠️ Manejo de Errores
- Convierte excepciones de Firebase a excepciones del dominio
- Proporciona mensajes de error consistentes
- Maneja diferentes códigos de error de Firebase

## Arquitectura

### Constructor con Dependency Injection
```dart
FirebaseAuthDataSource({
  FirebaseAuth? firebaseAuth,
  FirebaseFirestore? firestore,
});
```
- Permite inyectar instancias para testing
- Usa instancias por defecto en producción

### Stream Reactivo
```dart
Stream<UserModel?> get authStateChanges
```
- Combina `FirebaseAuth.authStateChanges()` con datos de Firestore
- Emite `UserModel` completo o `null`
- Crea documentos de Firestore automáticamente si no existen

## Métodos Principales

### 🔐 Autenticación Básica

#### `signInWithEmailAndPassword()`
```dart
Future<UserModel> signInWithEmailAndPassword({
  required String email,
  required String password,
});
```
- Inicia sesión con Firebase Auth
- Actualiza documento de Firestore con timestamp de último acceso
- Combina datos de Auth y Firestore
- Maneja validación de email y contraseña

#### `registerWithEmailAndPassword()`
```dart
Future<UserModel> registerWithEmailAndPassword({
  required String email,
  required String password,
  String? displayName,
});
```
- Verifica disponibilidad del email antes de registrar
- Crea cuenta en Firebase Auth
- Crea documento inicial en Firestore
- Envía email de verificación automáticamente
- Actualiza perfil si se proporciona displayName

#### `signOut()`
```dart
Future<void> signOut();
```
- Cierra sesión en Firebase Auth
- Limpia estado local

### 🔄 Gestión de Contraseñas

#### `sendPasswordResetEmail()`
```dart
Future<void> sendPasswordResetEmail({
  required String email,
});
```
- Envía email de recuperación de contraseña
- Maneja errores específicos (usuario no encontrado, etc.)

#### `updatePassword()`
```dart
Future<void> updatePassword({
  required String newPassword,
});
```
- Actualiza contraseña del usuario actual
- Requiere sesión activa

#### `reauthenticate()`
```dart
Future<void> reauthenticate({
  required String password,
});
```
- Reautentica para operaciones sensibles
- Usa `EmailAuthProvider.credential()`

### 👤 Gestión de Perfil

#### `updateProfile()`
```dart
Future<UserModel> updateProfile({
  String? displayName,
  String? photoURL,
});
```
- Actualiza perfil en Firebase Auth
- Sincroniza cambios con Firestore
- Recarga datos del usuario
- Retorna `UserModel` actualizado

#### `sendEmailVerification()`
```dart
Future<void> sendEmailVerification();
```
- Envía email de verificación
- Maneja límites de envío

#### `reloadUser()`
```dart
Future<UserModel> reloadUser();
```
- Recarga datos desde el servidor
- Útil para verificar cambios de estado de email
- Combina datos actualizados de Auth y Firestore

### 🗑️ Gestión de Cuenta

#### `deleteAccount()`
```dart
Future<void> deleteAccount();
```
- Elimina documento de Firestore primero
- Elimina cuenta de Firebase Auth
- Operación irreversible

### 🔐 Sistema de Permisos

#### `hasPermission()`
```dart
Future<bool> hasPermission(UserRole requiredRole);
```
- Verifica permisos basados en rol
- Considera estado activo del usuario
- Maneja jerarquía de roles (admin > manager > employee)

#### `updateUserRole()` / `updateUserStatus()`
```dart
Future<void> updateUserRole({
  required String userId,
  required UserRole newRole,
});
```
- Solo para administradores
- Actualiza rol/estado en Firestore
- Incluye timestamp de actualización

### 👥 Gestión de Usuarios (Admin)

#### `getAllUsers()`
```dart
Future<List<UserModel>> getAllUsers({
  int? limit,
  String? startAfter,
});
```
- Lista todos los usuarios (solo admin)
- Soporta paginación con `startAfter`
- Ordenado por email

#### `searchUsers()`
```dart
Future<List<UserModel>> searchUsers({
  required String query,
  int? limit,
});
```
- Búsqueda por prefijo de email
- Limitación: Firestore no soporta búsqueda de texto completo nativa
- Usa `isGreaterThanOrEqualTo` y `isLessThanOrEqualTo`

#### `getUserById()`
```dart
Future<UserModel> getUserById(String userId);
```
- Obtiene usuario específico por ID
- Maneja usuario no encontrado

### ✅ Utilidades

#### `isEmailAvailable()`
```dart
Future<bool> isEmailAvailable(String email);
```
- Verifica disponibilidad usando `fetchSignInMethodsForEmail()`
- Retorna `true` si el email está disponible

## Integración con Firestore

### Estructura de Documentos
```javascript
/users/{userId} {
  email: string,
  displayName: string?,
  photoURL: string?,
  emailVerified: boolean,
  creationTime: timestamp,
  lastSignInTime: timestamp,
  role: string, // 'employee', 'manager', 'admin'
  status: string, // 'active', 'suspended', 'inactive'
  updatedAt: timestamp
}
```

### Operaciones Automáticas
- **Creación**: Documento se crea automáticamente en registro
- **Actualización**: Se actualiza en cada login
- **Sincronización**: Combina datos de Auth y Firestore
- **Timestamps**: Se manejan automáticamente con `FieldValue.serverTimestamp()`

## Manejo de Errores

### Conversión de Excepciones
```dart
} on FirebaseAuthException catch (e) {
  throw AuthExceptionMapper.fromFirebaseAuthCode(e.code, e.message);
} on FirebaseException catch (e) {
  throw ServerException(message: e.message ?? 'Firestore error');
} catch (e) {
  throw AuthExceptionMapper.fromException(e);
}
```

### Códigos de Error Comunes
- `invalid-email`: Email malformado
- `user-not-found`: Usuario no existe
- `wrong-password`: Contraseña incorrecta
- `email-already-in-use`: Email ya registrado
- `weak-password`: Contraseña débil
- `too-many-requests`: Demasiados intentos
- `user-disabled`: Cuenta deshabilitada

## Características Avanzadas

### Stream Híbrido
```dart
Stream<UserModel?> get authStateChanges {
  return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
    // Combina Firebase Auth + Firestore
  });
}
```
- Combina datos de autenticación con datos extendidos
- Crea documentos faltantes automáticamente
- Maneja errores gracefully

### Sincronización de Datos
- **Login**: Actualiza timestamp de último acceso
- **Registro**: Crea documento inicial
- **Actualización de Perfil**: Sincroniza Auth y Firestore
- **Gestión de Roles**: Solo en Firestore (datos extendidos)

### Optimizaciones
- Trim automático de emails
- Validación previa de disponibilidad de email
- Manejo graceful de errores de Firestore (no afectan Auth)
- Reutilización de datos cacheados cuando es posible

## Testing

### Dependency Injection
```dart
// Para testing
final mockAuth = MockFirebaseAuth();
final mockFirestore = MockFirebaseFirestore();
final dataSource = FirebaseAuthDataSource(
  firebaseAuth: mockAuth,
  firestore: mockFirestore,
);
```

### Casos de Prueba Importantes
1. **Autenticación exitosa y fallida**
2. **Sincronización Auth + Firestore**
3. **Creación automática de documentos**
4. **Manejo de errores específicos**
5. **Permisos y roles**
6. **Paginación de usuarios**

## Limitaciones y Consideraciones

### Firestore Limitations
- No búsqueda de texto completo nativa
- Límites de consultas complejas
- Costos por operación

### Manejo de Errores
- Errores de Firestore no afectan operaciones de Auth
- Logs de errores para debugging
- Fallbacks graceful

### Seguridad
- Reglas de Firestore deben complementar la lógica de permisos
- Validación del lado del cliente y servidor
- Sanitización de datos de entrada

## Integración con Clean Architecture

1. **Capa de Datos**: Esta clase ES la fuente de datos
2. **Independencia**: No conoce casos de uso ni presentación
3. **Contratos**: Implementará la interfaz del repositorio
4. **Excepciones**: Convierte errores externos a excepciones del dominio
5. **Modelos**: Usa `UserModel` para serialización/deserialización

Esta implementación proporciona una base sólida y completa para todas las operaciones de autenticación necesarias en la aplicación Stock LetuShops.
