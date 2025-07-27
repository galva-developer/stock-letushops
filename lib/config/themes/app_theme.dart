// 🎨 App Theme Configuration
// Configuración de temas para Stock LetuShops

import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

class AppTheme {
  // Tema principal de la aplicación
  static ThemeData get lightTheme {
    return ThemeData(
      // Configuración del color scheme con paleta rojo-blanco-negro
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorConstants.primaryColor,
        brightness: Brightness.light,
        primary: ColorConstants.primaryColor,
        onPrimary: ColorConstants.textOnPrimaryColor,
        secondary: ColorConstants.secondaryColor,
        onSecondary: ColorConstants.textOnPrimaryColor,
        surface: ColorConstants.surfaceColor,
        onSurface: ColorConstants.textPrimaryColor,
        background: ColorConstants.backgroundColor,
        onBackground: ColorConstants.textPrimaryColor,
        error: ColorConstants.errorColor,
        onError: ColorConstants.textOnPrimaryColor,
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorConstants.primaryColor,
        foregroundColor: ColorConstants.textOnPrimaryColor,
        elevation: DimensionConstants.elevationMedium,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: ColorConstants.textOnPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Configuración de botones
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.primaryColor,
          foregroundColor: ColorConstants.textOnPrimaryColor,
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

      // Configuración de cards
      cardTheme: CardTheme(
        color: ColorConstants.cardColor,
        elevation: DimensionConstants.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
        ),
        margin: const EdgeInsets.all(DimensionConstants.marginSmall),
      ),

      // Configuración de inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorConstants.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
          borderSide: const BorderSide(color: ColorConstants.grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
          borderSide: const BorderSide(color: ColorConstants.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
          borderSide: const BorderSide(
            color: ColorConstants.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
          borderSide: const BorderSide(color: ColorConstants.errorColor),
        ),
        contentPadding: const EdgeInsets.all(DimensionConstants.paddingMedium),
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ColorConstants.surfaceColor,
        selectedItemColor: ColorConstants.primaryColor,
        unselectedItemColor: ColorConstants.grey500,
        type: BottomNavigationBarType.fixed,
        elevation: DimensionConstants.elevationMedium,
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ColorConstants.primaryColor,
        foregroundColor: ColorConstants.textOnPrimaryColor,
        elevation: DimensionConstants.elevationMedium,
      ),

      // Configuración de iconos
      iconTheme: const IconThemeData(
        color: ColorConstants.grey600,
        size: DimensionConstants.iconSize,
      ),

      // Configuración de divisores
      dividerTheme: const DividerThemeData(
        color: ColorConstants.dividerColor,
        thickness: 1,
        space: 1,
      ),

      // Splash color para interacciones
      splashColor: ColorConstants.primaryLightColor.withOpacity(0.3),
      highlightColor: ColorConstants.primaryLightColor.withOpacity(0.1),
    );
  }

  // Tema oscuro (para futuras implementaciones)
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorConstants.primaryColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: ColorConstants.grey900,
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorConstants.grey900,
        foregroundColor: ColorConstants.surfaceColor,
      ),
    );
  }
}
