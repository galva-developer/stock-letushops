import 'package:flutter/material.dart';

/// Botón personalizado para autenticación
///
/// Proporciona un botón reutilizable con diseño consistente
/// que sigue la paleta de colores rojo-blanco-negro de la aplicación.
///
/// Características:
/// - Múltiples variantes de estilo (primary, secondary, outlined, text)
/// - Estados de loading con indicador de progreso
/// - Soporte para iconos y diferentes tamaños
/// - Animaciones suaves en hover y press
/// - Diseño responsive y accesible
/// - Ripple effect personalizado
class AuthButton extends StatefulWidget {
  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AuthButtonVariant.primary,
    this.size = AuthButtonSize.large,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.width,
    this.height,
  });

  /// Texto que se muestra en el botón
  final String text;

  /// Callback cuando se presiona el botón
  final VoidCallback? onPressed;

  /// Variante del estilo del botón
  final AuthButtonVariant variant;

  /// Tamaño del botón
  final AuthButtonSize size;

  /// Si el botón está en estado de carga
  final bool isLoading;

  /// Si el botón está habilitado
  final bool isEnabled;

  /// Icono opcional que se muestra antes del texto
  final IconData? icon;

  /// Ancho personalizado del botón
  final double? width;

  /// Alto personalizado del botón
  final double? height;

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  bool get _shouldBeEnabled =>
      widget.isEnabled && widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = _getButtonStyle(theme);
    final textStyle = _getTextStyle(theme);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _shouldBeEnabled ? _onTapDown : null,
            onTapUp: _shouldBeEnabled ? _onTapUp : null,
            onTapCancel: _shouldBeEnabled ? _onTapCancel : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.width ?? _getButtonWidth(),
              height: widget.height ?? _getButtonHeight(),
              decoration: BoxDecoration(
                color: buttonStyle.backgroundColor,
                borderRadius: BorderRadius.circular(_getBorderRadius()),
                border: buttonStyle.border,
                boxShadow: _shouldBeEnabled ? _getBoxShadow() : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _shouldBeEnabled ? widget.onPressed : null,
                  borderRadius: BorderRadius.circular(_getBorderRadius()),
                  splashColor: buttonStyle.splashColor,
                  highlightColor: buttonStyle.highlightColor,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: _getHorizontalPadding(),
                      vertical: _getVerticalPadding(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.isLoading) ...[
                          SizedBox(
                            width: _getIconSize(),
                            height: _getIconSize(),
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                textStyle.color ?? Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ] else if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            size: _getIconSize(),
                            color: textStyle.color,
                          ),
                          const SizedBox(width: 12),
                        ],

                        Flexible(
                          child: Text(
                            widget.isLoading ? 'Cargando...' : widget.text,
                            style: textStyle,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _ButtonStyle _getButtonStyle(ThemeData theme) {
    switch (widget.variant) {
      case AuthButtonVariant.primary:
        return _ButtonStyle(
          backgroundColor:
              _shouldBeEnabled ? Colors.red.shade700 : Colors.grey.shade300,
          splashColor: Colors.red.shade800.withOpacity(0.2),
          highlightColor: Colors.red.shade800.withOpacity(0.1),
        );

      case AuthButtonVariant.secondary:
        return _ButtonStyle(
          backgroundColor:
              _shouldBeEnabled ? Colors.grey.shade100 : Colors.grey.shade50,
          border: Border.all(
            color:
                _shouldBeEnabled ? Colors.grey.shade400 : Colors.grey.shade200,
            width: 1.5,
          ),
          splashColor: Colors.grey.shade200.withOpacity(0.5),
          highlightColor: Colors.grey.shade200.withOpacity(0.3),
        );

      case AuthButtonVariant.outlined:
        return _ButtonStyle(
          backgroundColor: Colors.transparent,
          border: Border.all(
            color:
                _shouldBeEnabled ? Colors.red.shade700 : Colors.grey.shade300,
            width: 2.0,
          ),
          splashColor: Colors.red.shade700.withOpacity(0.1),
          highlightColor: Colors.red.shade700.withOpacity(0.05),
        );

      case AuthButtonVariant.text:
        return _ButtonStyle(
          backgroundColor: Colors.transparent,
          splashColor: Colors.red.shade700.withOpacity(0.1),
          highlightColor: Colors.red.shade700.withOpacity(0.05),
        );
    }
  }

  TextStyle _getTextStyle(ThemeData theme) {
    Color textColor;

    switch (widget.variant) {
      case AuthButtonVariant.primary:
        textColor = _shouldBeEnabled ? Colors.white : Colors.grey.shade500;
        break;
      case AuthButtonVariant.secondary:
        textColor = _shouldBeEnabled ? Colors.black87 : Colors.grey.shade500;
        break;
      case AuthButtonVariant.outlined:
      case AuthButtonVariant.text:
        textColor =
            _shouldBeEnabled ? Colors.red.shade700 : Colors.grey.shade400;
        break;
    }

    double fontSize;
    FontWeight fontWeight;

    switch (widget.size) {
      case AuthButtonSize.small:
        fontSize = 14;
        fontWeight = FontWeight.w600;
        break;
      case AuthButtonSize.medium:
        fontSize = 16;
        fontWeight = FontWeight.w600;
        break;
      case AuthButtonSize.large:
        fontSize = 18;
        fontWeight = FontWeight.w700;
        break;
    }

    return theme.textTheme.bodyLarge?.copyWith(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: 0.5,
        ) ??
        TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: 0.5,
        );
  }

  double _getButtonWidth() {
    switch (widget.size) {
      case AuthButtonSize.small:
        return 120;
      case AuthButtonSize.medium:
        return 200;
      case AuthButtonSize.large:
        return double.infinity;
    }
  }

  double _getButtonHeight() {
    switch (widget.size) {
      case AuthButtonSize.small:
        return 40;
      case AuthButtonSize.medium:
        return 48;
      case AuthButtonSize.large:
        return 56;
    }
  }

  double _getBorderRadius() {
    switch (widget.size) {
      case AuthButtonSize.small:
        return 8;
      case AuthButtonSize.medium:
        return 10;
      case AuthButtonSize.large:
        return 12;
    }
  }

  double _getHorizontalPadding() {
    switch (widget.size) {
      case AuthButtonSize.small:
        return 16;
      case AuthButtonSize.medium:
        return 20;
      case AuthButtonSize.large:
        return 24;
    }
  }

  double _getVerticalPadding() {
    switch (widget.size) {
      case AuthButtonSize.small:
        return 8;
      case AuthButtonSize.medium:
        return 12;
      case AuthButtonSize.large:
        return 16;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case AuthButtonSize.small:
        return 16;
      case AuthButtonSize.medium:
        return 18;
      case AuthButtonSize.large:
        return 20;
    }
  }

  List<BoxShadow> _getBoxShadow() {
    if (widget.variant == AuthButtonVariant.text ||
        widget.variant == AuthButtonVariant.outlined) {
      return [];
    }

    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        offset: const Offset(0, 2),
        blurRadius: 4,
        spreadRadius: 0,
      ),
      if (_isPressed)
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          offset: const Offset(0, 4),
          blurRadius: 8,
          spreadRadius: 0,
        ),
    ];
  }
}

/// Clase auxiliar para definir el estilo del botón
class _ButtonStyle {
  final Color backgroundColor;
  final Border? border;
  final Color splashColor;
  final Color highlightColor;

  const _ButtonStyle({
    required this.backgroundColor,
    this.border,
    required this.splashColor,
    required this.highlightColor,
  });
}

/// Variantes de estilo disponibles para el AuthButton
enum AuthButtonVariant {
  /// Botón principal con fondo rojo
  primary,

  /// Botón secundario con fondo gris claro
  secondary,

  /// Botón con borde rojo y fondo transparente
  outlined,

  /// Botón de solo texto sin fondo ni borde
  text,
}

/// Tamaños disponibles para el AuthButton
enum AuthButtonSize {
  /// Botón pequeño (40px altura)
  small,

  /// Botón mediano (48px altura)
  medium,

  /// Botón grande (56px altura, ancho completo)
  large,
}

/// Extensión para crear botones específicos comunes
extension AuthButtonExtensions on AuthButton {
  /// Crea un botón de inicio de sesión
  static AuthButton login({
    Key? key,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return AuthButton(
      key: key,
      text: 'Iniciar Sesión',
      onPressed: onPressed,
      variant: AuthButtonVariant.primary,
      size: AuthButtonSize.large,
      isLoading: isLoading,
      icon: Icons.login,
    );
  }

  /// Crea un botón de registro
  static AuthButton register({
    Key? key,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return AuthButton(
      key: key,
      text: 'Crear Cuenta',
      onPressed: onPressed,
      variant: AuthButtonVariant.primary,
      size: AuthButtonSize.large,
      isLoading: isLoading,
      icon: Icons.person_add,
    );
  }

  /// Crea un botón de Google Sign-In
  static AuthButton google({
    Key? key,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return AuthButton(
      key: key,
      text: 'Continuar con Google',
      onPressed: onPressed,
      variant: AuthButtonVariant.secondary,
      size: AuthButtonSize.large,
      isLoading: isLoading,
      icon: Icons.g_mobiledata,
    );
  }

  /// Crea un botón de envío de enlace de recuperación
  static AuthButton sendResetLink({
    Key? key,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return AuthButton(
      key: key,
      text: 'Enviar Enlace',
      onPressed: onPressed,
      variant: AuthButtonVariant.primary,
      size: AuthButtonSize.large,
      isLoading: isLoading,
      icon: Icons.email_outlined,
    );
  }

  /// Crea un botón de volver/cancelar
  static AuthButton back({
    Key? key,
    required VoidCallback? onPressed,
    String text = 'Volver',
  }) {
    return AuthButton(
      key: key,
      text: text,
      onPressed: onPressed,
      variant: AuthButtonVariant.text,
      size: AuthButtonSize.medium,
      icon: Icons.arrow_back,
    );
  }
}
