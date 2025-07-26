// 👤 User Model
// Modelo de datos para usuarios

class User {
  final String id;
  final String email;
  final String displayName;
  final String? photoURL;
  final String role;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final bool isActive;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoURL,
    required this.role,
    required this.createdAt,
    required this.lastLoginAt,
    this.isActive = true,
  });

  // Crear desde JSON (Firebase)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? '',
      photoURL: json['photoURL'],
      role: json['role'] ?? 'user',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] ?? 0),
      lastLoginAt: DateTime.fromMillisecondsSinceEpoch(
        json['lastLoginAt'] ?? 0,
      ),
      isActive: json['isActive'] ?? true,
    );
  }

  // Convertir a JSON (Firebase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'role': role,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastLoginAt': lastLoginAt.millisecondsSinceEpoch,
      'isActive': isActive,
    };
  }

  // Copiar con modificaciones
  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    String? role,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isActive: isActive ?? this.isActive,
    );
  }

  // Verificar si es administrador
  bool get isAdmin => role == 'admin';

  // Verificar si es manager
  bool get isManager => role == 'manager' || isAdmin;

  // Obtener iniciales del nombre
  String get initials {
    final names = displayName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';
  }
}
