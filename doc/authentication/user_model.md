# UserModel

## Descripción
El `UserModel` es la implementación en la capa de datos de la entidad `AuthUser`. Se encarga de la serialización/deserialización con Firebase y actúa como adaptador entre la capa de datos y el dominio.

## Características Principales

### Factory Constructors
- `fromFirebaseUser()`: Crea un UserModel desde Firebase User
- `fromFirestore()`: Crea un UserModel desde Firestore Document
- `fromMap()`: Crea un UserModel desde un Map
- `fromJson()`: Crea un UserModel desde JSON
- `empty()`: Crea un UserModel vacío para testing
- `test()`: Crea un UserModel de prueba para testing

### Métodos de Serialización
- `toFirestore()`: Convierte a Map para guardar en Firestore
- `toMap()`: Convierte a Map genérico
- `toJson()`: Convierte a JSON

### Métodos de Fusión
- `mergeWithFirebaseUser()`: Combina datos de Firebase User
- `mergeWithFirestoreData()`: Combina datos de Firestore

## Integración con Firebase

### Firebase Authentication
```dart
// Crear desde Firebase User
final firebaseUser = FirebaseAuth.instance.currentUser!;
final userModel = UserModel.fromFirebaseUser(firebaseUser);
```

### Firestore
```dart
// Guardar en Firestore
await FirebaseFirestore.instance
    .collection('users')
    .doc(userModel.uid)
    .set(userModel.toFirestore());

// Leer desde Firestore
final doc = await FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .get();
final userModel = UserModel.fromFirestore(doc);
```

## Manejo de Timestamps

El modelo maneja automáticamente la conversión entre:
- `DateTime` de Dart ↔ `Timestamp` de Firestore
- `DateTime` de Dart ↔ `millisecondsSinceEpoch` para JSON

## Testing

Incluye métodos específicos para facilitar el testing:

```dart
// Usuario vacío
final emptyUser = UserModel.empty();

// Usuario de prueba
final testUser = UserModel.test(
  uid: 'test123',
  email: 'test@example.com',
  role: UserRole.admin,
);
```

## Campos Automáticos

- `updatedAt`: Se actualiza automáticamente en Firestore usando `FieldValue.serverTimestamp()`
- Timestamps se convierten automáticamente según el contexto

## Principios de Clean Architecture

1. **Hereda de AuthUser**: Mantiene la compatibilidad con el dominio
2. **Responsabilidad Única**: Solo se encarga de la serialización/deserialización
3. **Adaptador**: Traduce entre formatos de datos externos e internos

## Uso Típico

```dart
// Registro de usuario
final firebaseUser = await FirebaseAuth.instance
    .createUserWithEmailAndPassword(email: email, password: password);

final userModel = UserModel.fromFirebaseUser(firebaseUser.user!)
    .copyWith(role: UserRole.employee);

await FirebaseFirestore.instance
    .collection('users')
    .doc(userModel.uid)
    .set(userModel.toFirestore());
```
