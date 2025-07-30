// 🎨 App Theme Configuration
// Configuración completa de temas para Stock LetuShops
// Incluye tema claro y oscuro con tipografías responsive y componentes estilizados

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/constants.dart';
import 'theme_extensions.dart';

/// Configuración principal de temas de la aplicación
///
/// Características implementadas:
/// ✅ Paleta rojo-blanco-negro según especificaciones
/// ✅ Tema claro y oscuro completos
/// ✅ Tipografías responsive adaptativas
/// ✅ Estilos de componentes (botones, cards, inputs)
/// ✅ Sistema de colores consistente
/// ✅ Configuración de componentes Material 3
class AppTheme {
  // Private constructor para evitar instanciación
  AppTheme._();

  // 🌅 TEMA CLARO PRINCIPAL
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // 🎨 Color Scheme - Paleta rojo-blanco-negro
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: ColorConstants.primaryColor, // Rojo principal
        onPrimary: ColorConstants.textOnPrimaryColor, // Blanco en rojo
        primaryContainer: ColorConstants.red100, // Rojo muy claro
        onPrimaryContainer: ColorConstants.red900, // Rojo muy oscuro

        secondary: ColorConstants.secondaryColor, // Rojo brillante
        onSecondary: ColorConstants.textOnPrimaryColor, // Blanco en secundario
        secondaryContainer: ColorConstants.red50, // Rojo extremo claro
        onSecondaryContainer: ColorConstants.red800, // Rojo oscuro

        tertiary: ColorConstants.grey600, // Gris medio
        onTertiary: ColorConstants.surfaceColor, // Blanco en gris
        tertiaryContainer: ColorConstants.grey100, // Gris muy claro
        onTertiaryContainer: ColorConstants.grey900, // Negro

        surface: ColorConstants.surfaceColor, // Blanco puro
        onSurface: ColorConstants.textPrimaryColor, // Negro
        surfaceVariant: ColorConstants.grey50, // Blanco grisáceo
        onSurfaceVariant: ColorConstants.grey700, // Gris oscuro

        background: ColorConstants.backgroundColor, // Blanco base
        onBackground: ColorConstants.textPrimaryColor, // Negro

        error: ColorConstants.errorColor, // Rojo error
        onError: ColorConstants.textOnPrimaryColor, // Blanco en error
        errorContainer: ColorConstants.red50, // Rojo muy claro
        onErrorContainer: ColorConstants.red900, // Rojo muy oscuro

        outline: ColorConstants.grey300, // Bordes
        outlineVariant: ColorConstants.grey200, // Bordes suaves
        shadow: ColorConstants.shadowColor, // Sombras
        scrim: ColorConstants.overlayColor, // Overlays
        inverseSurface: ColorConstants.grey900, // Superficie inversa
        onInverseSurface: ColorConstants.surfaceColor, // Texto en inversa
        inversePrimary: ColorConstants.red200, // Primario inverso
      ),

      // 📝 Typography System - Responsive
      textTheme: ThemeExtensions.buildTextTheme(Brightness.light),

      // 🎯 AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: ColorConstants.primaryColor,
        foregroundColor: ColorConstants.textOnPrimaryColor,
        elevation: DimensionConstants.elevationMedium,
        centerTitle: true,
        scrolledUnderElevation: DimensionConstants.elevationLow,
        shadowColor: ColorConstants.shadowColor,
        surfaceTintColor: ColorConstants.primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: ColorConstants.primaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: const TextStyle(
          color: ColorConstants.textOnPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        toolbarTextStyle: const TextStyle(
          color: ColorConstants.textOnPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: const IconThemeData(
          color: ColorConstants.textOnPrimaryColor,
          size: DimensionConstants.iconSize,
        ),
        actionsIconTheme: const IconThemeData(
          color: ColorConstants.textOnPrimaryColor,
          size: DimensionConstants.iconSize,
        ),
      ),

      // 🔘 Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.primaryColor,
          foregroundColor: ColorConstants.textOnPrimaryColor,
          disabledBackgroundColor: ColorConstants.grey300,
          disabledForegroundColor: ColorConstants.textDisabledColor,
          elevation: DimensionConstants.elevationMedium,
          shadowColor: ColorConstants.shadowColor,
          surfaceTintColor: ColorConstants.primaryLightColor,
          minimumSize: const Size(
            DimensionConstants.buttonWidth,
            DimensionConstants.buttonHeight,
          ),
          maximumSize: const Size(
            double.infinity,
            DimensionConstants.buttonHeight,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: DimensionConstants.paddingLarge,
            vertical: DimensionConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              DimensionConstants.radiusMedium,
            ),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorConstants.primaryColor,
          disabledForegroundColor: ColorConstants.textDisabledColor,
          side: const BorderSide(
            color: ColorConstants.primaryColor,
            width: 1.5,
          ),
          minimumSize: const Size(
            DimensionConstants.buttonWidth,
            DimensionConstants.buttonHeight,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: DimensionConstants.paddingLarge,
            vertical: DimensionConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              DimensionConstants.radiusMedium,
            ),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorConstants.primaryColor,
          disabledForegroundColor: ColorConstants.textDisabledColor,
          minimumSize: const Size(0, DimensionConstants.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: DimensionConstants.paddingMedium,
            vertical: DimensionConstants.paddingSmall,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DimensionConstants.radiusSmall),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // 🃏 Card Theme
      cardTheme: CardTheme(
        color: ColorConstants.cardColor,
        shadowColor: ColorConstants.shadowColor,
        surfaceTintColor: ColorConstants.surfaceColor,
        elevation: DimensionConstants.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
        ),
        margin: const EdgeInsets.all(DimensionConstants.marginSmall),
        clipBehavior: Clip.antiAliasWithSaveLayer,
      ),

      // 📝 Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorConstants.surfaceColor,
        contentPadding: const EdgeInsets.all(DimensionConstants.paddingMedium),

        // Borders
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
          borderSide: const BorderSide(
            color: ColorConstants.grey300,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
          borderSide: const BorderSide(
            color: ColorConstants.grey300,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
          borderSide: const BorderSide(
            color: ColorConstants.primaryColor,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
          borderSide: const BorderSide(
            color: ColorConstants.errorColor,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
          borderSide: const BorderSide(
            color: ColorConstants.errorColor,
            width: 2.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
          borderSide: const BorderSide(
            color: ColorConstants.grey200,
            width: 1.0,
          ),
        ),

        // Labels y hints
        labelStyle: const TextStyle(
          color: ColorConstants.textSecondaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        floatingLabelStyle: const TextStyle(
          color: ColorConstants.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: const TextStyle(
          color: ColorConstants.textDisabledColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: const TextStyle(
          color: ColorConstants.errorColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        helperStyle: const TextStyle(
          color: ColorConstants.textSecondaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),

        // Icons
        prefixIconColor: ColorConstants.grey600,
        suffixIconColor: ColorConstants.grey600,
      ),

      // 🧭 Bottom Navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ColorConstants.surfaceColor,
        selectedItemColor: ColorConstants.primaryColor,
        unselectedItemColor: ColorConstants.grey500,
        type: BottomNavigationBarType.fixed,
        elevation: DimensionConstants.elevationMedium,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // 🎯 Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ColorConstants.primaryColor,
        foregroundColor: ColorConstants.textOnPrimaryColor,
        elevation: DimensionConstants.elevationMedium,
        focusElevation: DimensionConstants.elevationHigh,
        hoverElevation: DimensionConstants.elevationHigh,
        splashColor: ColorConstants.primaryLightColor,
        shape: CircleBorder(),
      ),

      // 🔗 Icon Theme
      iconTheme: const IconThemeData(
        color: ColorConstants.grey600,
        size: DimensionConstants.iconSize,
      ),
      primaryIconTheme: const IconThemeData(
        color: ColorConstants.textOnPrimaryColor,
        size: DimensionConstants.iconSize,
      ),

      // 📏 Divider Theme
      dividerTheme: const DividerThemeData(
        color: ColorConstants.dividerColor,
        thickness: 1,
        space: 1,
      ),

      // 🎨 Additional Properties
      splashColor: ColorConstants.primaryLightColor.withOpacity(0.3),
      highlightColor: ColorConstants.primaryLightColor.withOpacity(0.1),
      focusColor: ColorConstants.primaryColor.withOpacity(0.12),
      hoverColor: ColorConstants.primaryColor.withOpacity(0.04),

      // 📋 Lista Tiles
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: DimensionConstants.paddingMedium,
          vertical: DimensionConstants.paddingSmall,
        ),
        minLeadingWidth: 40,
        iconColor: ColorConstants.grey600,
        textColor: ColorConstants.textPrimaryColor,
        selectedColor: ColorConstants.primaryColor,
        selectedTileColor: ColorConstants.red50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(DimensionConstants.radiusSmall),
          ),
        ),
      ),

      // 🎛️ Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return ColorConstants.primaryColor;
          }
          return ColorConstants.grey400;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return ColorConstants.primaryLightColor;
          }
          return ColorConstants.grey300;
        }),
      ),

      // ✅ Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return ColorConstants.primaryColor;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(
          ColorConstants.textOnPrimaryColor,
        ),
        side: const BorderSide(color: ColorConstants.grey400, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusSmall),
        ),
      ),

      // 📊 Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ColorConstants.primaryColor,
        linearTrackColor: ColorConstants.grey200,
        circularTrackColor: ColorConstants.grey200,
      ),

      // 🎨 Tab Bar Theme
      tabBarTheme: const TabBarTheme(
        labelColor: ColorConstants.primaryColor,
        unselectedLabelColor: ColorConstants.grey600,
        indicatorColor: ColorConstants.primaryColor,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

      // 🎭 Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: ColorConstants.surfaceColor,
        elevation: DimensionConstants.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusLarge),
        ),
        titleTextStyle: const TextStyle(
          color: ColorConstants.textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: ColorConstants.textSecondaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),

      // 📱 Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: ColorConstants.surfaceColor,
        elevation: DimensionConstants.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DimensionConstants.radiusLarge),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
      ),

      // 📋 Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: ColorConstants.grey100,
        deleteIconColor: ColorConstants.grey600,
        disabledColor: ColorConstants.grey200,
        selectedColor: ColorConstants.red100,
        secondarySelectedColor: ColorConstants.red50,
        shadowColor: ColorConstants.shadowColor,
        checkmarkColor: ColorConstants.primaryColor,
        labelStyle: const TextStyle(
          color: ColorConstants.textPrimaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: ColorConstants.primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        brightness: Brightness.light,
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

  // 🌙 TEMA OSCURO
  static ThemeData get darkTheme => ThemeExtensions.darkTheme;

  // 🎯 UTILITY METHODS
  static bool isDarkMode(BuildContext context) =>
      ThemeExtensions.isDarkMode(context);
  static Color getContrastColor(BuildContext context) =>
      ThemeExtensions.getContrastColor(context);
  static Color getBackgroundColor(BuildContext context) =>
      ThemeExtensions.getBackgroundColor(context);
  static Color getPrimaryColor(BuildContext context) =>
      ThemeExtensions.getPrimaryColor(context);
  static double getResponsiveFontSize(BuildContext context, double baseSize) =>
      ThemeExtensions.getResponsiveFontSize(context, baseSize);
  static EdgeInsets getResponsivePadding(BuildContext context) =>
      ThemeExtensions.getResponsivePadding(context);
}
