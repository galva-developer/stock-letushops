# Auth Exceptions

## Descripción
Sistema completo de excepciones para el manejo de errores de autenticación en la aplicación. Proporciona una estructura consistente y mensajes de error amigables para el usuario.

## Jerarquía de Excepciones

### AuthException (Clase Base)
Clase abstracta que define la estructura común:
- `message`: Mensaje técnico para desarrolladores
- `code`: Código único para identificación programática
- `userMessage`: Mensaje amigable para mostrar al usuario

### Excepciones de Autenticación

#### InvalidCredentialsException
- **Cuándo**: Email o contraseña incorrectos
- **Código**: `invalid-credentials`
- **Mensaje Usuario**: "Email o contraseña incorrectos"

#### UserNotFoundException
- **Cuándo**: Usuario no existe en el sistema
- **Código**: `user-not-found`
- **Mensaje Usuario**: "No se encontró un usuario con este email"

#### EmailAlreadyInUseException
- **Cuándo**: Email ya registrado en el sistema
- **Código**: `email-already-in-use`
- **Mensaje Usuario**: "Este email ya está registrado"

#### WeakPasswordException
- **Cuándo**: Contraseña no cumple requisitos mínimos
- **Código**: `weak-password`
- **Mensaje Usuario**: "La contraseña debe tener al menos 6 caracteres"

#### TooManyRequestsException
- **Cuándo**: Demasiados intentos fallidos
- **Código**: `too-many-requests`
- **Mensaje Usuario**: "Demasiados intentos. Intenta de nuevo más tarde"

#### UserDisabledException
- **Cuándo**: Cuenta de usuario deshabilitada
- **Código**: `user-disabled`
- **Mensaje Usuario**: "Esta cuenta ha sido deshabilitada"

### Excepciones de Validación

#### InvalidEmailFormatException
- **Cuándo**: Formato de email inválido
- **Código**: `invalid-email-format`
- **Mensaje Usuario**: "Por favor ingresa un email válido"

#### PasswordTooShortException
- **Cuándo**: Contraseña muy corta
- **Código**: `password-too-short`
- **Mensaje Usuario**: "La contraseña debe tener al menos 6 caracteres"

#### RequiredFieldException
- **Cuándo**: Campo requerido vacío
- **Código**: `required-field`
- **Mensaje Usuario**: "El campo {fieldName} es requerido"

### Excepciones de Sistema

#### NetworkException
- **Cuándo**: Problemas de conectividad
- **Código**: `network-error`
- **Mensaje Usuario**: "Error de conexión. Verifica tu internet"

#### ServerException
- **Cuándo**: Errores del servidor
- **Código**: `server-error`
- **Mensaje Usuario**: "Error del servidor. Intenta más tarde"

#### SessionExpiredException
- **Cuándo**: Sesión expirada
- **Código**: `session-expired`
- **Mensaje Usuario**: "Tu sesión ha expirado. Inicia sesión nuevamente"

## AuthExceptionMapper

Utilidad para convertir errores de Firebase a excepciones personalizadas.

### Métodos

#### fromFirebaseAuthCode()
Convierte códigos de error de Firebase Auth:
```dart
try {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email, 
    password: password
  );
} on FirebaseAuthException catch (e) {
  throw AuthExceptionMapper.fromFirebaseAuthCode(e.code, e.message);
}
```

#### fromException()
Convierte excepciones genéricas:
```dart
try {
  // Alguna operación
} catch (e) {
  throw AuthExceptionMapper.fromException(e);
}
```

## Uso en la Aplicación

### En la Capa de Datos
```dart
try {
  final credential = await _firebaseAuth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
  return UserModel.fromFirebaseUser(credential.user!);
} on FirebaseAuthException catch (e) {
  throw AuthExceptionMapper.fromFirebaseAuthCode(e.code, e.message);
} catch (e) {
  throw AuthExceptionMapper.fromException(e);
}
```

### En la Capa de Presentación
```dart
try {
  await authRepository.signIn(email, password);
} on AuthException catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.userMessage)),
  );
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Error inesperado')),
  );
}
```

## Mapeo de Códigos Firebase

| Código Firebase | Excepción Custom |
|----------------|------------------|
| `invalid-email` | `InvalidCredentialsException` |
| `wrong-password` | `InvalidCredentialsException` |
| `user-not-found` | `UserNotFoundException` |
| `email-already-in-use` | `EmailAlreadyInUseException` |
| `weak-password` | `WeakPasswordException` |
| `too-many-requests` | `TooManyRequestsException` |
| `user-disabled` | `UserDisabledException` |
| `network-request-failed` | `NetworkException` |
| `internal-error` | `ServerException` |

## Beneficios

1. **Consistencia**: Estructura uniforme para todos los errores
2. **UX Mejorada**: Mensajes amigables para usuarios
3. **Debugging**: Códigos únicos para identificar errores
4. **Mantenibilidad**: Centralización del manejo de errores
5. **Testeable**: Excepciones específicas para testing
6. **Localización**: Mensajes en español preparados para i18n
