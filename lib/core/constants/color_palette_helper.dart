// 🎨 Color Palette Helper
// Helpers y ejemplos para usar la paleta rojo-blanco-negro de LETUSHOPS

import 'package:flutter/material.dart';
import 'color_constants.dart';

class ColorPaletteHelper {
  // 🎯 Obtener color de stock según nivel
  static Color getStockLevelColor(int stock) {
    if (stock == 0) return ColorConstants.errorColor;
    if (stock <= 10) return ColorConstants.stockLowColor;
    if (stock <= 50) return ColorConstants.stockMediumColor;
    return ColorConstants.stockHighColor;
  }

  // 📊 Obtener color de texto basado en el fondo
  static Color getContrastingTextColor(Color backgroundColor) {
    // Calcular luminancia para determinar si usar texto claro u oscuro
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5
        ? ColorConstants.textPrimaryColor
        : ColorConstants.textOnPrimaryColor;
  }

  // 🔴 Obtener tonalidad de rojo según intensidad
  static Color getRedShade(double intensity) {
    // intensity entre 0.0 (más claro) y 1.0 (más oscuro)
    final colors = [
      ColorConstants.red50,
      ColorConstants.red100,
      ColorConstants.red200,
      ColorConstants.red300,
      ColorConstants.red400,
      ColorConstants.red500,
      ColorConstants.red600,
      ColorConstants.red700,
      ColorConstants.red800,
      ColorConstants.red900,
    ];

    final index = (intensity * (colors.length - 1)).round();
    return colors[index.clamp(0, colors.length - 1)];
  }

  // ⚫ Obtener tonalidad de gris según intensidad
  static Color getGreyShade(double intensity) {
    // intensity entre 0.0 (más claro) y 1.0 (más oscuro)
    final colors = [
      ColorConstants.grey50,
      ColorConstants.grey100,
      ColorConstants.grey200,
      ColorConstants.grey300,
      ColorConstants.grey400,
      ColorConstants.grey500,
      ColorConstants.grey600,
      ColorConstants.grey700,
      ColorConstants.grey800,
      ColorConstants.grey900,
    ];

    final index = (intensity * (colors.length - 1)).round();
    return colors[index.clamp(0, colors.length - 1)];
  }

  // 🎨 Crear color con transparencia
  static Color withAlpha(Color color, double alpha) {
    return color.withOpacity(alpha.clamp(0.0, 1.0));
  }

  // 🌗 Tema claro y oscuro
  static ThemeData getLightTheme() {
    return ThemeData(
      primarySwatch:
          MaterialColor(ColorConstants.primaryColor.value, const <int, Color>{
            50: ColorConstants.red50,
            100: ColorConstants.red100,
            200: ColorConstants.red200,
            300: ColorConstants.red300,
            400: ColorConstants.red400,
            500: ColorConstants.red500,
            600: ColorConstants.red600,
            700: ColorConstants.red700,
            800: ColorConstants.red800,
            900: ColorConstants.red900,
          }),
      primaryColor: ColorConstants.primaryColor,
      scaffoldBackgroundColor: ColorConstants.backgroundColor,
      cardColor: ColorConstants.cardColor,
      dividerColor: ColorConstants.dividerColor,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: ColorConstants.textPrimaryColor),
        headlineMedium: TextStyle(color: ColorConstants.textPrimaryColor),
        headlineSmall: TextStyle(color: ColorConstants.textPrimaryColor),
        bodyLarge: TextStyle(color: ColorConstants.textPrimaryColor),
        bodyMedium: TextStyle(color: ColorConstants.textSecondaryColor),
        bodySmall: TextStyle(color: ColorConstants.textSecondaryColor),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: ColorConstants.primaryColor,
      scaffoldBackgroundColor: ColorConstants.grey900,
      cardColor: ColorConstants.grey800,
      dividerColor: ColorConstants.grey600,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: ColorConstants.surfaceColor),
        headlineMedium: TextStyle(color: ColorConstants.surfaceColor),
        headlineSmall: TextStyle(color: ColorConstants.surfaceColor),
        bodyLarge: TextStyle(color: ColorConstants.surfaceColor),
        bodyMedium: TextStyle(color: ColorConstants.grey300),
        bodySmall: TextStyle(color: ColorConstants.grey400),
      ),
    );
  }

  // 📋 Paleta de colores para UI específica
  static const Map<String, Color> uiColors = {
    'appBar': ColorConstants.primaryColor,
    'bottomNav': ColorConstants.surfaceColor,
    'floatingActionButton': ColorConstants.primaryColor,
    'button': ColorConstants.primaryColor,
    'buttonDisabled': ColorConstants.grey400,
    'input': ColorConstants.surfaceColor,
    'inputBorder': ColorConstants.grey300,
    'inputFocused': ColorConstants.primaryColor,
    'card': ColorConstants.cardColor,
    'cardShadow': ColorConstants.shadowColor,
    'divider': ColorConstants.dividerColor,
    'icon': ColorConstants.grey600,
    'iconActive': ColorConstants.primaryColor,
  };

  // 🎯 Colores para estados de la aplicación
  static const Map<String, Color> statusColors = {
    'loading': ColorConstants.grey500,
    'success': ColorConstants.successColor,
    'error': ColorConstants.errorColor,
    'warning': ColorConstants.warningColor,
    'info': ColorConstants.infoColor,
    'disabled': ColorConstants.grey400,
    'selected': ColorConstants.primaryLightColor,
    'highlighted': ColorConstants.searchHighlight,
  };

  // 📊 Función para generar paleta de colores para gráficos
  static List<Color> generateChartPalette(int count) {
    final baseColors = ColorConstants.chartColors;
    final result = <Color>[];

    for (int i = 0; i < count; i++) {
      if (i < baseColors.length) {
        result.add(baseColors[i]);
      } else {
        // Generar variaciones si necesitamos más colores
        final baseIndex = i % baseColors.length;
        final variation = (i / baseColors.length).floor();
        final alpha = 1.0 - (variation * 0.2);
        result.add(baseColors[baseIndex].withOpacity(alpha.clamp(0.3, 1.0)));
      }
    }

    return result;
  }
}
