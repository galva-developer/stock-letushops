// 🎨 Color Constants
// Paleta de colores para LETUSHOPS Stock App

import 'package:flutter/material.dart';

class ColorConstants {
  // 🔴 Colores primarios de LETUSHOPS (Rojo Base)
  static const Color primaryColor = Color(
    0xFFE53935,
  ); // Rojo principal LETUSHOPS
  static const Color primaryLightColor = Color(0xFFEF5350); // Rojo claro
  static const Color primaryDarkColor = Color(0xFFD32F2F); // Rojo oscuro

  // 🔸 Colores secundarios (Variaciones de rojo)
  static const Color secondaryColor = Color(0xFFFF5252); // Rojo brillante
  static const Color secondaryLightColor = Color(0xFFFF8A80); // Rojo muy claro
  static const Color secondaryDarkColor = Color(0xFFB71C1C); // Rojo muy oscuro

  // ⚡ Colores de estado
  static const Color successColor = Color(
    0xFF4CAF50,
  ); // Verde para éxito (mantener contraste)
  static const Color errorColor = Color(0xFFE53935); // Rojo para errores
  static const Color warningColor = Color(
    0xFFFF6B6B,
  ); // Rojo-naranja para advertencias
  static const Color infoColor = Color(0xFF757575); // Gris para información

  // 🖼️ Colores de fondo
  static const Color backgroundColor = Color(
    0xFFF5F5F5,
  ); // Blanco base especificado
  static const Color surfaceColor = Color(0xFFFFFFFF); // Blanco puro
  static const Color cardColor = Color(0xFFFAFAFA); // Blanco ligeramente gris

  // 📝 Colores de texto
  static const Color textPrimaryColor = Color(0xFF212121); // Negro especificado
  static const Color textSecondaryColor = Color(0xFF757575); // Gris medio
  static const Color textDisabledColor = Color(0xFFBDBDBD); // Gris claro
  static const Color textOnPrimaryColor = Color(
    0xFFFFFFFF,
  ); // Blanco para texto en rojo

  // 🎯 Colores específicos de la app
  static const Color cameraOverlayColor = Color(
    0x80212121,
  ); // Negro semitransparente
  static const Color stockLowColor = Color(0xFFE53935); // Rojo para stock bajo
  static const Color stockMediumColor = Color(
    0xFFFF8A65,
  ); // Rojo-naranja para stock medio
  static const Color stockHighColor = Color(
    0xFF81C784,
  ); // Verde suave para stock alto

  // 🌈 Colores adicionales de la paleta rojo-blanco-negro
  static const Color accentColor = Color(0xFFFF1744); // Rojo accent
  static const Color dividerColor = Color(
    0xFFE0E0E0,
  ); // Gris muy claro para divisores
  static const Color shadowColor = Color(
    0x1A212121,
  ); // Negro muy transparente para sombras
  static const Color overlayColor = Color(
    0x66212121,
  ); // Negro semitransparente para overlays

  // 🎨 Tonos de grises (complementarios al negro)
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121); // Negro base

  // 🔴 Tonos de rojos
  static const Color red50 = Color(0xFFFFEBEE);
  static const Color red100 = Color(0xFFFFCDD2);
  static const Color red200 = Color(0xFFEF9A9A);
  static const Color red300 = Color(0xFFE57373);
  static const Color red400 = Color(0xFFEF5350);
  static const Color red500 = Color(0xFFE53935); // Rojo base
  static const Color red600 = Color(0xFFE53935);
  static const Color red700 = Color(0xFFD32F2F);
  static const Color red800 = Color(0xFFC62828);
  static const Color red900 = Color(0xFFB71C1C);

  // 🎨 Gradientes actualizados
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryLightColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryColor, secondaryLightColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient redToWhiteGradient = LinearGradient(
    colors: [primaryColor, Color(0xFFF5F5F5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient blackToRedGradient = LinearGradient(
    colors: [Color(0xFF212121), primaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 🔍 Colores de filtros y overlays
  static const Color filterOverlay = Color(0x33E53935); // Rojo transparente
  static const Color searchHighlight = Color(
    0xFFFFEBEE,
  ); // Rojo muy claro para destacar
  static const Color selectedItem = Color(
    0xFFFFCDD2,
  ); // Rojo claro para selección

  // 📊 Colores para gráficos y charts
  static const List<Color> chartColors = [
    Color(0xFFE53935), // Rojo principal
    Color(0xFF757575), // Gris
    Color(0xFFEF5350), // Rojo claro
    Color(0xFF424242), // Gris oscuro
    Color(0xFFFF8A80), // Rojo muy claro
    Color(0xFF212121), // Negro
  ];
}
