import 'package:flutter/material.dart';

/// Widget de campo de texto personalizado para autenticación
///
/// Proporciona un campo de texto reutilizable con diseño consistente
/// que sigue la paleta de colores rojo-blanco-negro de la aplicación.
///
/// Características:
/// - Diseño profesional con bordes redondeados
/// - Soporte para validación con mensajes de error
/// - Iconos prefijo y sufijo opcionales
/// - Modo de contraseña con toggle de visibilidad
/// - Estados de error, focus y disabled
/// - Animaciones suaves en las transiciones
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.labelText,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.autofocus = false,
    this.showPasswordToggle = false,
  });

  /// Texto de placeholder que se muestra cuando el campo está vacío
  final String hintText;

  /// Etiqueta que se muestra arriba del campo
  final String? labelText;

  /// Controlador para manejar el texto del campo
  final TextEditingController? controller;

  /// Función de validación que retorna mensaje de error o null
  final String? Function(String?)? validator;

  /// Icono que se muestra al inicio del campo
  final IconData? prefixIcon;

  /// Widget personalizado que se muestra al final del campo
  final Widget? suffixIcon;

  /// Si true, oculta el texto (para contraseñas)
  final bool obscureText;

  /// Tipo de teclado a mostrar
  final TextInputType keyboardType;

  /// Acción del botón de acción del teclado
  final TextInputAction textInputAction;

  /// Callback cuando el texto cambia
  final Function(String)? onChanged;

  /// Callback cuando se presiona el botón de acción del teclado
  final Function(String)? onSubmitted;

  /// Si el campo está habilitado para edición
  final bool enabled;

  /// Número máximo de líneas
  final int maxLines;

  /// Si el campo debe tener foco automáticamente
  final bool autofocus;

  /// Si debe mostrar el toggle de visibilidad para contraseñas
  final bool showPasswordToggle;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late bool _obscureText;
  bool _isFocused = false;
  late AnimationController _animationController;
  late Animation<double> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _borderAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _onFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
    });

    if (hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: _isFocused ? Colors.red.shade700 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
        ],

        Focus(
          onFocusChange: _onFocusChange,
          child: AnimatedBuilder(
            animation: _borderAnimation,
            builder: (context, child) {
              return TextFormField(
                controller: widget.controller,
                validator: widget.validator,
                obscureText: _obscureText,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                onChanged: widget.onChanged,
                onFieldSubmitted: widget.onSubmitted,
                enabled: widget.enabled,
                maxLines: widget.maxLines,
                autofocus: widget.autofocus,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: widget.enabled ? Colors.black87 : Colors.grey.shade500,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade400,
                  ),

                  // Prefix Icon
                  prefixIcon:
                      widget.prefixIcon != null
                          ? Icon(
                            widget.prefixIcon,
                            color:
                                _isFocused
                                    ? Colors.red.shade700
                                    : Colors.grey.shade500,
                            size: 20,
                          )
                          : null,

                  // Suffix Icon (con toggle de contraseña si es necesario)
                  suffixIcon:
                      widget.showPasswordToggle && widget.obscureText
                          ? IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey.shade500,
                              size: 20,
                            ),
                            onPressed: _togglePasswordVisibility,
                          )
                          : widget.suffixIcon,

                  // Bordes y styling
                  filled: true,
                  fillColor:
                      widget.enabled
                          ? Colors.grey.shade50
                          : Colors.grey.shade100,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.red.shade700,
                      width: _borderAnimation.value,
                    ),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.red.shade400,
                      width: 1.0,
                    ),
                  ),

                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.red.shade600,
                      width: 2.0,
                    ),
                  ),

                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1.0,
                    ),
                  ),

                  // Padding interno
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),

                  // Styling de mensajes de error
                  errorStyle: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.red.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Extensión para crear campos de texto específicos comunes
extension CustomTextFieldExtensions on CustomTextField {
  /// Crea un campo de email con validación y estilo predefinido
  static CustomTextField email({
    Key? key,
    String? labelText,
    TextEditingController? controller,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    bool autofocus = false,
  }) {
    return CustomTextField(
      key: key,
      hintText: 'ejemplo@correo.com',
      labelText: labelText ?? 'Correo electrónico',
      controller: controller,
      validator: validator,
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      autofocus: autofocus,
    );
  }

  /// Crea un campo de contraseña con toggle de visibilidad
  static CustomTextField password({
    Key? key,
    String? labelText,
    String? hintText,
    TextEditingController? controller,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    Function(String)? onSubmitted,
    TextInputAction textInputAction = TextInputAction.done,
  }) {
    return CustomTextField(
      key: key,
      hintText: hintText ?? '••••••••',
      labelText: labelText ?? 'Contraseña',
      controller: controller,
      validator: validator,
      prefixIcon: Icons.lock_outline,
      obscureText: true,
      showPasswordToggle: true,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  /// Crea un campo de nombre con estilo predefinido
  static CustomTextField name({
    Key? key,
    String? labelText,
    String? hintText,
    TextEditingController? controller,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    bool autofocus = false,
  }) {
    return CustomTextField(
      key: key,
      hintText: hintText ?? 'Tu nombre completo',
      labelText: labelText ?? 'Nombre completo',
      controller: controller,
      validator: validator,
      prefixIcon: Icons.person_outline,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      autofocus: autofocus,
    );
  }
}
