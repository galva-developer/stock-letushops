import 'package:equatable/equatable.dart';

/// Entidad que representa un usuario autenticado en el dominio
///
/// Esta clase define la estructura básica de un usuario desde la perspectiva
/// del dominio, sin depender de implementaciones específicas de Firebase o
/// cualquier otra tecnología externa.
class AuthUser extends Equatable {
  /// Identificador único del usuario
  final String uid;

  /// Correo electrónico del usuario
  final String email;

  /// Nombre completo del usuario
  final String? displayName;

  /// URL de la foto de perfil
  final String? photoURL;

  /// Indica si el email ha sido verificado
  final bool emailVerified;

  /// Fecha de creación de la cuenta
  final DateTime? creationTime;

  /// Fecha del último inicio de sesión
  final DateTime? lastSignInTime;

  /// Rol del usuario en el sistema
  final UserRole role;

  /// Estado del usuario (activo, suspendido, etc.)
  final UserStatus status;

  const AuthUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.emailVerified,
    this.creationTime,
    this.lastSignInTime,
    this.role = UserRole.employee,
    this.status = UserStatus.active,
  });

  /// Crea una copia del usuario con algunos campos modificados
  AuthUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    bool? emailVerified,
    DateTime? creationTime,
    DateTime? lastSignInTime,
    UserRole? role,
    UserStatus? status,
  }) {
    return AuthUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
      creationTime: creationTime ?? this.creationTime,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
      role: role ?? this.role,
      status: status ?? this.status,
    );
  }

  /// Verifica si el usuario tiene permisos de administrador
  bool get isAdmin => role == UserRole.admin;

  /// Verifica si el usuario tiene permisos de manager
  bool get isManager => role == UserRole.manager || isAdmin;

  /// Verifica si el usuario está activo
  bool get isActive => status == UserStatus.active;

  /// Obtiene el nombre a mostrar (displayName o email)
  String get displayTitle => displayName ?? email;

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    photoURL,
    emailVerified,
    creationTime,
    lastSignInTime,
    role,
    status,
  ];

  @override
  String toString() {
    return 'AuthUser(uid: $uid, email: $email, displayName: $displayName, '
        'role: $role, status: $status, emailVerified: $emailVerified)';
  }
}

/// Enum que define los roles de usuario en el sistema
enum UserRole {
  /// Usuario empleado básico
  employee('employee', 'Empleado'),

  /// Usuario manager con permisos extendidos
  manager('manager', 'Manager'),

  /// Usuario administrador con todos los permisos
  admin('admin', 'Administrador');

  const UserRole(this.value, this.displayName);

  /// Valor string del rol
  final String value;

  /// Nombre a mostrar del rol
  final String displayName;

  /// Convierte un string a UserRole
  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'manager':
        return UserRole.manager;
      case 'employee':
      default:
        return UserRole.employee;
    }
  }

  @override
  String toString() => value;
}

/// Enum que define los estados de usuario en el sistema
enum UserStatus {
  /// Usuario activo
  active('active', 'Activo'),

  /// Usuario suspendido temporalmente
  suspended('suspended', 'Suspendido'),

  /// Usuario inactivo/eliminado
  inactive('inactive', 'Inactivo');

  const UserStatus(this.value, this.displayName);

  /// Valor string del estado
  final String value;

  /// Nombre a mostrar del estado
  final String displayName;

  /// Convierte un string a UserStatus
  static UserStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'suspended':
        return UserStatus.suspended;
      case 'inactive':
        return UserStatus.inactive;
      case 'active':
      default:
        return UserStatus.active;
    }
  }

  @override
  String toString() => value;
}
