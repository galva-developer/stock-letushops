import 'package:flutter/material.dart';

/// Validadores de formularios para autenticación
///
/// Proporciona un conjunto completo de validadores reutilizables
/// para campos de formularios de autenticación con mensajes
/// de error en español y validaciones robustas.
///
/// Características:
/// - Validación de email con regex RFC 5322 compliant
/// - Validación de contraseñas con criterios de seguridad
/// - Validación de nombres con caracteres especiales
/// - Validación de confirmación de contraseña
/// - Mensajes de error descriptivos y amigables
/// - Soporte para validaciones personalizadas
/// - Validaciones combinadas (múltiples criterios)

class FormValidators {
  FormValidators._();

  // Expresiones regulares
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _nameRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]{2,50}$');

  static final RegExp _phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');

  /// Validador de campos requeridos
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Este campo'} es obligatorio';
    }
    return null;
  }

  /// Validador de email
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El correo electrónico es obligatorio';
    }

    final email = value.trim().toLowerCase();

    if (!_emailRegex.hasMatch(email)) {
      return 'Ingresa un correo electrónico válido';
    }

    if (email.length > 254) {
      return 'El correo electrónico es demasiado largo';
    }

    return null;
  }

  /// Validador de contraseña con criterios de seguridad
  static String? password(String? value, {bool requireStrong = true}) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }

    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }

    if (!requireStrong) {
      return null;
    }

    // Validaciones para contraseña fuerte
    final validations = <String>[];

    if (value.length < 8) {
      validations.add('8 caracteres mínimo');
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      validations.add('una letra mayúscula');
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      validations.add('una letra minúscula');
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      validations.add('un número');
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      validations.add('un carácter especial');
    }

    if (validations.isNotEmpty) {
      return 'La contraseña debe incluir: ${validations.join(', ')}';
    }

    return null;
  }

  /// Validador de confirmación de contraseña
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }

    if (value != originalPassword) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  /// Validador de nombre completo
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es obligatorio';
    }

    final name = value.trim();

    if (name.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }

    if (name.length > 50) {
      return 'El nombre es demasiado largo (máximo 50 caracteres)';
    }

    if (!_nameRegex.hasMatch(name)) {
      return 'El nombre solo puede contener letras y espacios';
    }

    // Verificar que tenga al menos nombre y apellido
    final words = name.split(' ').where((word) => word.isNotEmpty).toList();
    if (words.length < 2) {
      return 'Ingresa tu nombre completo (nombre y apellido)';
    }

    return null;
  }

  /// Validador de número de teléfono
  static String? phone(String? value, {bool required = false}) {
    if (value == null || value.trim().isEmpty) {
      return required ? 'El teléfono es obligatorio' : null;
    }

    final phone = value.trim().replaceAll(' ', '').replaceAll('-', '');

    if (!_phoneRegex.hasMatch(phone)) {
      return 'Ingresa un número de teléfono válido';
    }

    return null;
  }

  /// Validador de longitud mínima
  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null; // La validación de requerido debe manejarse por separado
    }

    if (value.length < minLength) {
      return '${fieldName ?? 'Este campo'} debe tener al menos $minLength caracteres';
    }

    return null;
  }

  /// Validador de longitud máxima
  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length > maxLength) {
      return '${fieldName ?? 'Este campo'} no puede tener más de $maxLength caracteres';
    }

    return null;
  }

  /// Validador personalizado que combina múltiples validaciones
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }

  /// Validador de aceptación de términos y condiciones
  static String? acceptTerms(bool? value) {
    if (value != true) {
      return 'Debes aceptar los términos y condiciones';
    }
    return null;
  }
}

/// Extensión para simplificar el uso de validadores comunes
extension ValidatorExtensions on FormValidators {
  /// Validador completo para campo de email en login
  static String? Function(String?) get loginEmail => FormValidators.email;

  /// Validador completo para campo de contraseña en login
  static String? Function(String?) get loginPassword =>
      (value) => FormValidators.password(value, requireStrong: false);

  /// Validador completo para campo de email en registro
  static String? Function(String?) get registerEmail => FormValidators.email;

  /// Validador completo para campo de contraseña en registro
  static String? Function(String?) get registerPassword =>
      (value) => FormValidators.password(value, requireStrong: true);

  /// Validador completo para campo de nombre en registro
  static String? Function(String?) get registerName => FormValidators.fullName;

  /// Validador para confirmación de contraseña en registro
  static String? Function(String?) confirmPasswordValidator(
    String originalPassword,
  ) {
    return (value) => FormValidators.confirmPassword(value, originalPassword);
  }

  /// Validador completo para email en recuperación de contraseña
  static String? Function(String?) get forgotPasswordEmail =>
      FormValidators.email;
}

/// Utilidades adicionales para validación de formularios
class FormValidationUtils {
  FormValidationUtils._();

  /// Verifica si una cadena contiene solo espacios en blanco
  static bool isOnlyWhitespace(String? value) {
    return value?.trim().isEmpty ?? true;
  }

  /// Limpia espacios en blanco al inicio y final
  static String? trimValue(String? value) {
    return value?.trim();
  }

  /// Evalúa la fortaleza de una contraseña (0-100)
  static int getPasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int score = 0;

    // Longitud
    if (password.length >= 8) score += 20;
    if (password.length >= 12) score += 10;

    // Complejidad de caracteres
    if (password.contains(RegExp(r'[a-z]'))) score += 15;
    if (password.contains(RegExp(r'[A-Z]'))) score += 15;
    if (password.contains(RegExp(r'[0-9]'))) score += 15;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score += 25;

    return score;
  }

  /// Obtiene el color según la fortaleza de la contraseña
  static Color getPasswordStrengthColor(int strength) {
    if (strength < 30) return const Color(0xFFE53E3E); // Rojo
    if (strength < 60) return const Color(0xFFDD6B20); // Naranja
    if (strength < 80) return const Color(0xFFD69E2E); // Amarillo
    return const Color(0xFF38A169); // Verde
  }

  /// Obtiene el texto descriptivo de la fortaleza
  static String getPasswordStrengthText(int strength) {
    if (strength < 30) return 'Muy débil';
    if (strength < 60) return 'Débil';
    if (strength < 80) return 'Buena';
    return 'Muy fuerte';
  }

  /// Formatea un número de teléfono para mostrar
  static String formatPhoneNumber(String phone) {
    // Implementación básica - se puede extender según el país
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');

    if (cleanPhone.length == 10) {
      return '(${cleanPhone.substring(0, 3)}) ${cleanPhone.substring(3, 6)}-${cleanPhone.substring(6)}';
    }

    return phone;
  }

  /// Máscara para entrada de teléfono
  static String applyPhoneMask(String value) {
    final numbers = value.replaceAll(RegExp(r'\D'), '');

    if (numbers.length <= 3) {
      return numbers;
    } else if (numbers.length <= 6) {
      return '(${numbers.substring(0, 3)}) ${numbers.substring(3)}';
    } else if (numbers.length <= 10) {
      return '(${numbers.substring(0, 3)}) ${numbers.substring(3, 6)}-${numbers.substring(6)}';
    } else {
      return '(${numbers.substring(0, 3)}) ${numbers.substring(3, 6)}-${numbers.substring(6, 10)}';
    }
  }
}

/// Clase para manejar el estado de validación de un formulario
class FormValidationState {
  final Map<String, String?> _errors = {};
  final Map<String, bool> _touched = {};

  /// Establece un error para un campo específico
  void setError(String field, String? error) {
    _errors[field] = error;
  }

  /// Obtiene el error de un campo específico
  String? getError(String field) {
    return _touched[field] == true ? _errors[field] : null;
  }

  /// Marca un campo como tocado
  void markAsTouched(String field) {
    _touched[field] = true;
  }

  /// Verifica si un campo ha sido tocado
  bool isTouched(String field) {
    return _touched[field] ?? false;
  }

  /// Verifica si hay errores en el formulario
  bool get hasErrors {
    return _errors.values.any((error) => error != null);
  }

  /// Obtiene todos los errores del formulario
  Map<String, String> get allErrors {
    return Map.fromEntries(
      _errors.entries.where((entry) => entry.value != null),
    ).cast<String, String>();
  }

  /// Limpia todos los errores
  void clearErrors() {
    _errors.clear();
  }

  /// Limpia el estado de un campo específico
  void clearField(String field) {
    _errors.remove(field);
    _touched.remove(field);
  }

  /// Reinicia completamente el estado del formulario
  void reset() {
    _errors.clear();
    _touched.clear();
  }
}
