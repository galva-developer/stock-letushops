import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/constants/responsive_constants.dart';

/// 🎨 EXTENSIONES DEL TEMA - FUNCIONALIDADES ADICIONALES
/// Contiene tema oscuro, tipografías responsivas y utilities
class ThemeExtensions {
  // 🌙 TEMA OSCURO
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: ColorConstants.red400,
        onPrimary: ColorConstants.grey900,
        secondary: ColorConstants.red300,
        onSecondary: ColorConstants.grey900,
        surface: ColorConstants.grey900,
        onSurface: ColorConstants.grey100,
        background: ColorConstants.grey900,
        onBackground: ColorConstants.grey100,
        error: ColorConstants.red400,
        onError: ColorConstants.grey900,
      ),

      textTheme: buildTextTheme(Brightness.dark),

      appBarTheme: AppBarTheme(
        backgroundColor: ColorConstants.grey900,
        foregroundColor: ColorConstants.grey100,
        elevation: DimensionConstants.elevationMedium,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: ColorConstants.grey100,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.red400,
          foregroundColor: ColorConstants.grey900,
          elevation: DimensionConstants.elevationMedium,
          padding: const EdgeInsets.symmetric(
            horizontal: DimensionConstants.paddingLarge,
            vertical: DimensionConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              DimensionConstants.radiusMedium,
            ),
          ),
        ),
      ),

      cardTheme: CardTheme(
        color: ColorConstants.grey800,
        elevation: DimensionConstants.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
        ),
        margin: const EdgeInsets.all(DimensionConstants.marginSmall),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorConstants.grey800,
        contentPadding: const EdgeInsets.all(DimensionConstants.paddingMedium),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
          borderSide: const BorderSide(color: ColorConstants.grey600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
          borderSide: const BorderSide(color: ColorConstants.red400, width: 2),
        ),
      ),

      iconTheme: const IconThemeData(
        color: ColorConstants.grey400,
        size: DimensionConstants.iconSize,
      ),

      dividerTheme: const DividerThemeData(
        color: ColorConstants.grey700,
        thickness: 1,
        space: 1,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ColorConstants.grey800,
        selectedItemColor: ColorConstants.red400,
        unselectedItemColor: ColorConstants.grey400,
        type: BottomNavigationBarType.fixed,
        elevation: DimensionConstants.elevationMedium,
      ),

      drawerTheme: const DrawerThemeData(
        backgroundColor: ColorConstants.grey900,
        elevation: DimensionConstants.elevationHigh,
      ),

      dialogTheme: DialogTheme(
        backgroundColor: ColorConstants.grey800,
        elevation: DimensionConstants.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusLarge),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: ColorConstants.grey800,
        elevation: DimensionConstants.elevationHigh,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DimensionConstants.radiusLarge),
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: ColorConstants.grey700,
        deleteIconColor: ColorConstants.grey400,
        disabledColor: ColorConstants.grey800,
        selectedColor: ColorConstants.red400,
        secondarySelectedColor: ColorConstants.red300,
        brightness: Brightness.dark,
        padding: const EdgeInsets.symmetric(
          horizontal: DimensionConstants.paddingSmall,
          vertical: 4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
        ),
      ),
    );
  }

  // 📝 SISTEMA DE TIPOGRAFÍA RESPONSIVE
  static TextTheme buildTextTheme(Brightness brightness) {
    final Color textColor =
        brightness == Brightness.light
            ? ColorConstants.textPrimaryColor
            : ColorConstants.grey100;
    final Color secondaryTextColor =
        brightness == Brightness.light
            ? ColorConstants.textSecondaryColor
            : ColorConstants.grey400;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryTextColor,
        letterSpacing: 0.4,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
        letterSpacing: 0.5,
      ),
    );
  }

  // 🎯 MÉTODOS UTILITY PARA TEMAS
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color getContrastColor(BuildContext context) {
    return isDarkMode(context)
        ? ColorConstants.grey100
        : ColorConstants.textPrimaryColor;
  }

  static Color getBackgroundColor(BuildContext context) {
    return isDarkMode(context)
        ? ColorConstants.grey900
        : ColorConstants.backgroundColor;
  }

  static Color getPrimaryColor(BuildContext context) {
    return isDarkMode(context)
        ? ColorConstants.red400
        : ColorConstants.primaryColor;
  }

  static Color getSurfaceColor(BuildContext context) {
    return isDarkMode(context)
        ? ColorConstants.grey800
        : ColorConstants.surfaceColor;
  }

  static Color getCardColor(BuildContext context) {
    return isDarkMode(context) ? ColorConstants.grey800 : Colors.white;
  }

  // 📱 RESPONSIVE HELPERS
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final multiplier =
        ResponsiveConstants.isDesktop(context)
            ? 1.1
            : ResponsiveConstants.isTablet(context)
            ? 1.05
            : 1.0;
    return baseSize * multiplier;
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    return EdgeInsets.all(ResponsiveConstants.getHorizontalMargin(context));
  }

  static double getResponsiveIconSize(BuildContext context) {
    return ResponsiveConstants.isDesktop(context)
        ? DimensionConstants.iconSize * 1.2
        : ResponsiveConstants.isTablet(context)
        ? DimensionConstants.iconSize * 1.1
        : DimensionConstants.iconSize;
  }

  // 🎨 THEME SPECIFIC HELPERS
  static TextStyle getHeadlineStyle(BuildContext context, {double? fontSize}) {
    final theme = Theme.of(context);
    return theme.textTheme.headlineMedium!.copyWith(
      fontSize:
          fontSize != null ? getResponsiveFontSize(context, fontSize) : null,
      color: getContrastColor(context),
    );
  }

  static TextStyle getBodyStyle(BuildContext context, {double? fontSize}) {
    final theme = Theme.of(context);
    return theme.textTheme.bodyMedium!.copyWith(
      fontSize:
          fontSize != null ? getResponsiveFontSize(context, fontSize) : null,
      color: getContrastColor(context),
    );
  }

  static BoxDecoration getCardDecoration(BuildContext context) {
    return BoxDecoration(
      color: getCardColor(context),
      borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
      boxShadow: [
        BoxShadow(
          color:
              isDarkMode(context)
                  ? Colors.black26
                  : Colors.grey.withOpacity(0.1),
          blurRadius: DimensionConstants.elevationLow,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static LinearGradient getPrimaryGradient(BuildContext context) {
    return isDarkMode(context)
        ? ColorConstants.blackToRedGradient
        : ColorConstants.primaryGradient;
  }
}
