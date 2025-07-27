import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/auth_user.dart';

/// Modelo de datos que implementa la entidad AuthUser
///
/// Esta clase se encarga de la serialización/deserialización con Firebase
/// y actúa como adaptador entre la capa de datos y el dominio.
class UserModel extends AuthUser {
  const UserModel({
    required super.uid,
    required super.email,
    super.displayName,
    super.photoURL,
    required super.emailVerified,
    super.creationTime,
    super.lastSignInTime,
    super.role,
    super.status,
  });

  /// Factory constructor para crear un UserModel desde Firebase User
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
      creationTime: user.metadata.creationTime,
      lastSignInTime: user.metadata.lastSignInTime,
      role:
          UserRole.employee, // Rol por defecto, se actualizará desde Firestore
      status: UserStatus.active,
    );
  }

  /// Factory constructor para crear un UserModel desde Firestore Document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      emailVerified: data['emailVerified'] ?? false,
      creationTime: data['creationTime']?.toDate(),
      lastSignInTime: data['lastSignInTime']?.toDate(),
      role: UserRole.fromString(data['role'] ?? 'employee'),
      status: UserStatus.fromString(data['status'] ?? 'active'),
    );
  }

  /// Factory constructor para crear un UserModel desde un Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      photoURL: map['photoURL'],
      emailVerified: map['emailVerified'] ?? false,
      creationTime:
          map['creationTime'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['creationTime'])
              : null,
      lastSignInTime:
          map['lastSignInTime'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['lastSignInTime'])
              : null,
      role: UserRole.fromString(map['role'] ?? 'employee'),
      status: UserStatus.fromString(map['status'] ?? 'active'),
    );
  }

  /// Convierte el UserModel a un Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'emailVerified': emailVerified,
      'creationTime':
          creationTime != null ? Timestamp.fromDate(creationTime!) : null,
      'lastSignInTime':
          lastSignInTime != null ? Timestamp.fromDate(lastSignInTime!) : null,
      'role': role.value,
      'status': status.value,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Convierte el UserModel a un Map genérico
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'emailVerified': emailVerified,
      'creationTime': creationTime?.millisecondsSinceEpoch,
      'lastSignInTime': lastSignInTime?.millisecondsSinceEpoch,
      'role': role.value,
      'status': status.value,
    };
  }

  /// Convierte el UserModel a JSON
  Map<String, dynamic> toJson() => toMap();

  /// Factory constructor para crear desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel.fromMap(json);

  /// Crea una copia del UserModel con algunos campos modificados
  @override
  UserModel copyWith({
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
    return UserModel(
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

  /// Combina datos de Firebase User y Firestore Document
  UserModel mergeWithFirebaseUser(User firebaseUser) {
    return copyWith(
      email: firebaseUser.email ?? email,
      displayName: firebaseUser.displayName ?? displayName,
      photoURL: firebaseUser.photoURL ?? photoURL,
      emailVerified: firebaseUser.emailVerified,
      creationTime: firebaseUser.metadata.creationTime ?? creationTime,
      lastSignInTime: firebaseUser.metadata.lastSignInTime ?? lastSignInTime,
    );
  }

  /// Combina datos de Firestore Document
  UserModel mergeWithFirestoreData(Map<String, dynamic> firestoreData) {
    return copyWith(
      displayName: firestoreData['displayName'] ?? displayName,
      photoURL: firestoreData['photoURL'] ?? photoURL,
      role:
          firestoreData['role'] != null
              ? UserRole.fromString(firestoreData['role'])
              : role,
      status:
          firestoreData['status'] != null
              ? UserStatus.fromString(firestoreData['status'])
              : status,
    );
  }

  /// Crea un UserModel vacío para uso en testing
  factory UserModel.empty() {
    return const UserModel(uid: '', email: '', emailVerified: false);
  }

  /// Crea un UserModel de prueba para testing
  factory UserModel.test({
    String uid = 'test-uid',
    String email = 'test@example.com',
    String? displayName = 'Test User',
    UserRole role = UserRole.employee,
    UserStatus status = UserStatus.active,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName,
      emailVerified: true,
      role: role,
      status: status,
      creationTime: DateTime.now(),
    );
  }
}
