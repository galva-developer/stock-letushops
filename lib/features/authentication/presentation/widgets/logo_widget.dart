import 'package:flutter/material.dart';

/// Widget del logo de LetuShops
///
/// Proporciona el logo de la aplicación con diferentes variantes y tamaños.
/// Incluye animaciones opcionales y soporte para temas claro/oscuro.
///
/// Características:
/// - Múltiples variantes de diseño (completo, solo icono, horizontal)
/// - Diferentes tamaños predefinidos
/// - Animaciones opcionales (fade, scale, bounce)
/// - Adaptación automática al tema de la aplicación
/// - Versión responsiva para diferentes pantallas
/// - Soporte para modo claro y oscuro
class LogoWidget extends StatefulWidget {
  const LogoWidget({
    super.key,
    this.variant = LogoVariant.complete,
    this.size = LogoSize.medium,
    this.animation = LogoAnimation.none,
    this.customHeight,
    this.customWidth,
    this.showTagline = false,
    this.color,
  });

  /// Variante del logo a mostrar
  final LogoVariant variant;

  /// Tamaño predefinido del logo
  final LogoSize size;

  /// Tipo de animación a aplicar
  final LogoAnimation animation;

  /// Altura personalizada del logo
  final double? customHeight;

  /// Ancho personalizado del logo
  final double? customWidth;

  /// Si debe mostrar el tagline debajo del logo
  final bool showTagline;

  /// Color personalizado para el logo
  final Color? color;

  @override
  State<LogoWidget> createState() => _LogoWidgetState();
}

class _LogoWidgetState extends State<LogoWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimation();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: _getAnimationDuration(),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  void _startAnimation() {
    if (widget.animation != LogoAnimation.none) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }
  }

  Duration _getAnimationDuration() {
    switch (widget.animation) {
      case LogoAnimation.fade:
        return const Duration(milliseconds: 800);
      case LogoAnimation.scale:
        return const Duration(milliseconds: 1200);
      case LogoAnimation.bounce:
        return const Duration(milliseconds: 1500);
      case LogoAnimation.slide:
        return const Duration(milliseconds: 1000);
      case LogoAnimation.none:
        return Duration.zero;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildAnimatedLogo();
  }

  Widget _buildAnimatedLogo() {
    Widget logo = _buildLogo();

    switch (widget.animation) {
      case LogoAnimation.fade:
        return FadeTransition(opacity: _fadeAnimation, child: logo);

      case LogoAnimation.scale:
        return ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(opacity: _fadeAnimation, child: logo),
        );

      case LogoAnimation.bounce:
        return ScaleTransition(scale: _scaleAnimation, child: logo);

      case LogoAnimation.slide:
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(opacity: _fadeAnimation, child: logo),
        );

      case LogoAnimation.none:
        return logo;
    }
  }

  Widget _buildLogo() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLogoContent(isDarkMode),
        if (widget.showTagline) ...[
          SizedBox(height: _getTaglineSpacing()),
          _buildTagline(theme, isDarkMode),
        ],
      ],
    );
  }

  Widget _buildLogoContent(bool isDarkMode) {
    switch (widget.variant) {
      case LogoVariant.complete:
        return _buildCompleteLogo(isDarkMode);
      case LogoVariant.iconOnly:
        return _buildIconOnly(isDarkMode);
      case LogoVariant.textOnly:
        return _buildTextOnly(isDarkMode);
      case LogoVariant.horizontal:
        return _buildHorizontalLogo(isDarkMode);
    }
  }

  Widget _buildCompleteLogo(bool isDarkMode) {
    return SizedBox(
      height: widget.customHeight ?? _getLogoHeight(),
      width: widget.customWidth ?? _getLogoWidth(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStockIcon(isDarkMode),
          SizedBox(height: _getIconTextSpacing()),
          _buildBrandText(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildIconOnly(bool isDarkMode) {
    return SizedBox(
      height: widget.customHeight ?? _getIconSize(),
      width: widget.customWidth ?? _getIconSize(),
      child: _buildStockIcon(isDarkMode),
    );
  }

  Widget _buildTextOnly(bool isDarkMode) {
    return SizedBox(
      height: widget.customHeight ?? _getTextHeight(),
      child: _buildBrandText(isDarkMode),
    );
  }

  Widget _buildHorizontalLogo(bool isDarkMode) {
    return SizedBox(
      height: widget.customHeight ?? _getHorizontalHeight(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStockIcon(isDarkMode),
          SizedBox(width: _getIconTextSpacing()),
          _buildBrandText(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildStockIcon(bool isDarkMode) {
    final iconColor =
        widget.color ??
        (isDarkMode ? Colors.red.shade400 : Colors.red.shade700);

    return Container(
      padding: EdgeInsets.all(_getIconPadding()),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(_getIconBorderRadius()),
        border: Border.all(color: iconColor.withOpacity(0.3), width: 2),
      ),
      child: Icon(
        Icons.inventory_2_outlined,
        size: _getInnerIconSize(),
        color: iconColor,
      ),
    );
  }

  Widget _buildBrandText(bool isDarkMode) {
    final textColor =
        widget.color ?? (isDarkMode ? Colors.white : Colors.black87);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Stock',
          style: TextStyle(
            fontSize: _getPrimaryTextSize(),
            fontWeight: FontWeight.w800,
            color: textColor,
            letterSpacing: 1.5,
            height: 1.0,
          ),
        ),
        Text(
          'LetuShops',
          style: TextStyle(
            fontSize: _getSecondaryTextSize(),
            fontWeight: FontWeight.w600,
            color:
                widget.color ??
                (isDarkMode ? Colors.red.shade400 : Colors.red.shade700),
            letterSpacing: 2.0,
            height: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildTagline(ThemeData theme, bool isDarkMode) {
    return Text(
      'Gestión inteligente de inventario',
      style: theme.textTheme.bodySmall?.copyWith(
        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  // Métodos para obtener tamaños según LogoSize
  double _getLogoHeight() {
    switch (widget.size) {
      case LogoSize.small:
        return 80;
      case LogoSize.medium:
        return 120;
      case LogoSize.large:
        return 180;
      case LogoSize.extraLarge:
        return 240;
    }
  }

  double _getLogoWidth() {
    switch (widget.size) {
      case LogoSize.small:
        return 120;
      case LogoSize.medium:
        return 160;
      case LogoSize.large:
        return 220;
      case LogoSize.extraLarge:
        return 280;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case LogoSize.small:
        return 40;
      case LogoSize.medium:
        return 60;
      case LogoSize.large:
        return 80;
      case LogoSize.extraLarge:
        return 100;
    }
  }

  double _getInnerIconSize() {
    switch (widget.size) {
      case LogoSize.small:
        return 20;
      case LogoSize.medium:
        return 30;
      case LogoSize.large:
        return 40;
      case LogoSize.extraLarge:
        return 50;
    }
  }

  double _getIconPadding() {
    switch (widget.size) {
      case LogoSize.small:
        return 8;
      case LogoSize.medium:
        return 12;
      case LogoSize.large:
        return 16;
      case LogoSize.extraLarge:
        return 20;
    }
  }

  double _getIconBorderRadius() {
    switch (widget.size) {
      case LogoSize.small:
        return 8;
      case LogoSize.medium:
        return 12;
      case LogoSize.large:
        return 16;
      case LogoSize.extraLarge:
        return 20;
    }
  }

  double _getPrimaryTextSize() {
    switch (widget.size) {
      case LogoSize.small:
        return 18;
      case LogoSize.medium:
        return 24;
      case LogoSize.large:
        return 32;
      case LogoSize.extraLarge:
        return 40;
    }
  }

  double _getSecondaryTextSize() {
    switch (widget.size) {
      case LogoSize.small:
        return 12;
      case LogoSize.medium:
        return 16;
      case LogoSize.large:
        return 20;
      case LogoSize.extraLarge:
        return 24;
    }
  }

  double _getTextHeight() {
    switch (widget.size) {
      case LogoSize.small:
        return 40;
      case LogoSize.medium:
        return 60;
      case LogoSize.large:
        return 80;
      case LogoSize.extraLarge:
        return 100;
    }
  }

  double _getHorizontalHeight() {
    switch (widget.size) {
      case LogoSize.small:
        return 50;
      case LogoSize.medium:
        return 70;
      case LogoSize.large:
        return 90;
      case LogoSize.extraLarge:
        return 110;
    }
  }

  double _getIconTextSpacing() {
    switch (widget.size) {
      case LogoSize.small:
        return 8;
      case LogoSize.medium:
        return 12;
      case LogoSize.large:
        return 16;
      case LogoSize.extraLarge:
        return 20;
    }
  }

  double _getTaglineSpacing() {
    switch (widget.size) {
      case LogoSize.small:
        return 8;
      case LogoSize.medium:
        return 12;
      case LogoSize.large:
        return 16;
      case LogoSize.extraLarge:
        return 20;
    }
  }
}

/// Variantes de presentación del logo
enum LogoVariant {
  /// Logo completo con icono y texto en columna
  complete,

  /// Solo el icono del logo
  iconOnly,

  /// Solo el texto del logo
  textOnly,

  /// Logo con icono y texto en fila horizontal
  horizontal,
}

/// Tamaños predefinidos para el logo
enum LogoSize {
  /// Tamaño pequeño (para app bars, botones)
  small,

  /// Tamaño mediano (para páginas normales)
  medium,

  /// Tamaño grande (para splash screens)
  large,

  /// Tamaño extra grande (para pantallas de bienvenida)
  extraLarge,
}

/// Tipos de animación para el logo
enum LogoAnimation {
  /// Sin animación
  none,

  /// Fade in suave
  fade,

  /// Scale in con fade
  scale,

  /// Bounce effect elástico
  bounce,

  /// Slide from top con fade
  slide,
}

/// Extensión para crear logos específicos comunes
extension LogoWidgetExtensions on LogoWidget {
  /// Logo para splash screen con animación
  static LogoWidget splash({Key? key}) {
    return LogoWidget(
      key: key,
      variant: LogoVariant.complete,
      size: LogoSize.large,
      animation: LogoAnimation.scale,
      showTagline: true,
    );
  }

  /// Logo para app bar
  static LogoWidget appBar({Key? key}) {
    return LogoWidget(
      key: key,
      variant: LogoVariant.horizontal,
      size: LogoSize.small,
      animation: LogoAnimation.none,
    );
  }

  /// Logo para formularios de autenticación
  static LogoWidget auth({Key? key}) {
    return LogoWidget(
      key: key,
      variant: LogoVariant.complete,
      size: LogoSize.medium,
      animation: LogoAnimation.fade,
    );
  }

  /// Solo icono para uso como favicon o icono pequeño
  static LogoWidget icon({
    Key? key,
    LogoSize size = LogoSize.small,
    Color? color,
  }) {
    return LogoWidget(
      key: key,
      variant: LogoVariant.iconOnly,
      size: size,
      animation: LogoAnimation.none,
      color: color,
    );
  }
}
