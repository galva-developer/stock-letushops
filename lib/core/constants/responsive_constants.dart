// 📱 Responsive Constants
// Constantes específicas para diseño responsive en diferentes dispositivos

import 'package:flutter/material.dart';

class ResponsiveConstants {
  // 📐 Breakpoints para diferentes dispositivos
  static const double mobileWidth = 480.0;
  static const double tabletWidth = 768.0;
  static const double desktopWidth = 1024.0;
  static const double largeDesktopWidth = 1440.0;
  static const double extraLargeDesktopWidth = 1920.0;

  // 📏 Alturas específicas de dispositivos
  static const double mobileHeight = 812.0; // iPhone típico
  static const double tabletHeight = 1024.0; // iPad típico
  static const double desktopHeight = 768.0; // Desktop típico

  // 🎯 Detectores de dispositivo
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileWidth;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileWidth && width < desktopWidth;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopWidth;
  }

  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= largeDesktopWidth;
  }

  // 📊 Grid System - Responsive
  static int getColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= largeDesktopWidth) return 5;
    if (width >= desktopWidth) return 4;
    if (width >= tabletWidth) return 3;
    return 2;
  }

  // 📱 Productos por fila según dispositivo
  static int getProductsPerRow(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= largeDesktopWidth) return 6;
    if (width >= desktopWidth) return 4;
    if (width >= tabletWidth) return 3;
    return 2;
  }

  // 📏 Márgenes adaptativos
  static double getHorizontalMargin(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= largeDesktopWidth) return 48.0;
    if (width >= desktopWidth) return 32.0;
    if (width >= tabletWidth) return 24.0;
    return 16.0;
  }

  static double getVerticalMargin(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return 24.0;
    if (width >= tabletWidth) return 20.0;
    return 16.0;
  }

  // 🎨 Tamaños de iconos adaptativos
  static double getIconSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return 28.0;
    if (width >= tabletWidth) return 26.0;
    return 24.0;
  }

  // 📝 Tamaños de fuente adaptativos
  static double getTitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return 24.0;
    if (width >= tabletWidth) return 22.0;
    return 20.0;
  }

  static double getSubtitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return 18.0;
    if (width >= tabletWidth) return 17.0;
    return 16.0;
  }

  static double getBodyFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return 16.0;
    if (width >= tabletWidth) return 15.0;
    return 14.0;
  }

  static double getCaptionFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return 14.0;
    if (width >= tabletWidth) return 13.0;
    return 12.0;
  }

  // 🎯 Tamaños de botones adaptativos
  static double getButtonHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return 52.0;
    if (width >= tabletWidth) return 50.0;
    return 48.0;
  }

  static double getButtonWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return 220.0;
    if (width >= tabletWidth) return 200.0;
    return 180.0;
  }

  // 📦 Tamaños de tarjetas adaptativos
  static double getCardHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return 140.0;
    if (width >= tabletWidth) return 130.0;
    return 120.0;
  }

  static double getProductCardHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return 240.0;
    if (width >= tabletWidth) return 220.0;
    return 200.0;
  }

  // 🖼️ Tamaños de imágenes adaptativos
  static double getProductImageSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return 120.0;
    if (width >= tabletWidth) return 110.0;
    return 100.0;
  }

  static double getAvatarSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return 48.0;
    if (width >= tabletWidth) return 44.0;
    return 40.0;
  }

  // 📐 Espaciados adaptativos
  static double getSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return 20.0;
    if (width >= tabletWidth) return 18.0;
    return 16.0;
  }

  static double getSmallSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return 12.0;
    if (width >= tabletWidth) return 10.0;
    return 8.0;
  }

  // 🏗️ Layout específicos
  static bool shouldUseDrawer(BuildContext context) {
    return MediaQuery.of(context).size.width < desktopWidth;
  }

  static bool shouldShowBottomNavigation(BuildContext context) {
    return MediaQuery.of(context).size.width < tabletWidth;
  }

  static bool shouldUseRail(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletWidth;
  }

  // 📱 Orientación
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // 🎯 Configuración de cámara adaptativa
  static double getCameraPreviewHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    if (width >= desktopWidth) return height * 0.6;
    if (width >= tabletWidth) return height * 0.5;
    return height * 0.4;
  }

  // 📊 Configuración de gráficos adaptativos
  static double getChartHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) return 400.0;
    if (width >= tabletWidth) return 350.0;
    return 300.0;
  }
}
