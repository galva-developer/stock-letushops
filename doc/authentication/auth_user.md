# AuthUser Entity

## Descripción
La entidad `AuthUser` representa un usuario autenticado en el dominio de la aplicación. Esta clase define la estructura básica de un usuario desde la perspectiva del dominio, sin depender de implementaciones específicas de Firebase o cualquier otra tecnología externa.

## Características Principales

### Propiedades
- **uid**: Identificador único del usuario
- **email**: Correo electrónico del usuario
- **displayName**: Nombre completo del usuario (opcional)
- **photoURL**: URL de la foto de perfil (opcional)
- **emailVerified**: Indica si el email ha sido verificado
- **creationTime**: Fecha de creación de la cuenta
- **lastSignInTime**: Fecha del último inicio de sesión
- **role**: Rol del usuario en el sistema (UserRole)
- **status**: Estado del usuario (UserStatus)

### Enums

#### UserRole
- `employee`: Usuario empleado básico
- `manager`: Usuario manager con permisos extendidos
- `admin`: Usuario administrador con todos los permisos

#### UserStatus
- `active`: Usuario activo
- `suspended`: Usuario suspendido temporalmente
- `inactive`: Usuario inactivo/eliminado

### Métodos Útiles
- `isAdmin`: Verifica si el usuario tiene permisos de administrador
- `isManager`: Verifica si el usuario tiene permisos de manager o admin
- `isActive`: Verifica si el usuario está activo
- `displayTitle`: Obtiene el nombre a mostrar (displayName o email)
- `copyWith()`: Crea una copia con algunos campos modificados

## Principios de Clean Architecture

Esta entidad sigue los principios de Clean Architecture:

1. **Independencia de Frameworks**: No depende de Firebase, Flutter o cualquier framework específico
2. **Testeable**: Puede ser probada sin dependencias externas
3. **Independiente de UI**: No contiene lógica de presentación
4. **Independiente de Base de Datos**: No sabe cómo se persiste la información

## Uso

```dart
const user = AuthUser(
  uid: 'user123',
  email: 'usuario@example.com',
  displayName: 'Juan Pérez',
  emailVerified: true,
  role: UserRole.employee,
  status: UserStatus.active,
);

// Verificar permisos
if (user.isManager) {
  // Permitir acceso a funciones de manager
}

// Crear copia modificada
final updatedUser = user.copyWith(
  role: UserRole.manager,
);
```

## Relaciones

- **UserModel**: La implementación en la capa de datos que extiende esta entidad
- **AuthExceptions**: Las excepciones que pueden ocurrir al trabajar con usuarios
- **AuthRepository**: El repositorio que maneja las operaciones de usuarios
