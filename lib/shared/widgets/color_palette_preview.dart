// 🎨 Color Palette Preview
// Widget para mostrar la nueva paleta de colores rojo-blanco-negro

import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import 'responsive_widget.dart';

class ColorPalettePreview extends StatelessWidget {
  const ColorPalettePreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paleta de Colores LETUSHOPS'),
        backgroundColor: ColorConstants.primaryColor,
        foregroundColor: ColorConstants.textOnPrimaryColor,
      ),
      backgroundColor: ColorConstants.backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('🔴 Colores Primarios', _buildPrimaryColors()),
            _buildSection('⚫ Escala de Grises', _buildGreyScale()),
            _buildSection('🔴 Escala de Rojos', _buildRedScale()),
            _buildSection('⚡ Colores de Estado', _buildStatusColors()),
            _buildSection('🎯 Colores de Stock', _buildStockColors()),
            _buildSection('🎨 Gradientes', _buildGradients()),
            _buildSection('📊 Colores de Gráficos', _buildChartColors()),
            _buildSection('🖼️ Ejemplo de UI', _buildUIExample()),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorConstants.textPrimaryColor,
            ),
          ),
        ),
        content,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPrimaryColors() {
    return Row(
      children: [
        _buildColorTile('Primary', ColorConstants.primaryColor),
        _buildColorTile('Primary Light', ColorConstants.primaryLightColor),
        _buildColorTile('Primary Dark', ColorConstants.primaryDarkColor),
      ],
    );
  }

  Widget _buildGreyScale() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildColorTile('Grey 50', ColorConstants.grey50, isSmall: true),
        _buildColorTile('Grey 100', ColorConstants.grey100, isSmall: true),
        _buildColorTile('Grey 200', ColorConstants.grey200, isSmall: true),
        _buildColorTile('Grey 300', ColorConstants.grey300, isSmall: true),
        _buildColorTile('Grey 400', ColorConstants.grey400, isSmall: true),
        _buildColorTile('Grey 500', ColorConstants.grey500, isSmall: true),
        _buildColorTile('Grey 600', ColorConstants.grey600, isSmall: true),
        _buildColorTile('Grey 700', ColorConstants.grey700, isSmall: true),
        _buildColorTile('Grey 800', ColorConstants.grey800, isSmall: true),
        _buildColorTile('Grey 900', ColorConstants.grey900, isSmall: true),
      ],
    );
  }

  Widget _buildRedScale() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildColorTile('Red 50', ColorConstants.red50, isSmall: true),
        _buildColorTile('Red 100', ColorConstants.red100, isSmall: true),
        _buildColorTile('Red 200', ColorConstants.red200, isSmall: true),
        _buildColorTile('Red 300', ColorConstants.red300, isSmall: true),
        _buildColorTile('Red 400', ColorConstants.red400, isSmall: true),
        _buildColorTile('Red 500', ColorConstants.red500, isSmall: true),
        _buildColorTile('Red 600', ColorConstants.red600, isSmall: true),
        _buildColorTile('Red 700', ColorConstants.red700, isSmall: true),
        _buildColorTile('Red 800', ColorConstants.red800, isSmall: true),
        _buildColorTile('Red 900', ColorConstants.red900, isSmall: true),
      ],
    );
  }

  Widget _buildStatusColors() {
    return Row(
      children: [
        _buildColorTile('Success', ColorConstants.successColor),
        _buildColorTile('Error', ColorConstants.errorColor),
        _buildColorTile('Warning', ColorConstants.warningColor),
        _buildColorTile('Info', ColorConstants.infoColor),
      ],
    );
  }

  Widget _buildStockColors() {
    return Row(
      children: [
        _buildColorTile('Stock Bajo', ColorConstants.stockLowColor),
        _buildColorTile('Stock Medio', ColorConstants.stockMediumColor),
        _buildColorTile('Stock Alto', ColorConstants.stockHighColor),
      ],
    );
  }

  Widget _buildGradients() {
    return Row(
      children: [
        _buildGradientTile('Primary', ColorConstants.primaryGradient),
        _buildGradientTile('Secondary', ColorConstants.secondaryGradient),
        _buildGradientTile('Red to White', ColorConstants.redToWhiteGradient),
        _buildGradientTile('Black to Red', ColorConstants.blackToRedGradient),
      ],
    );
  }

  Widget _buildChartColors() {
    return Row(
      children:
          ColorConstants.chartColors
              .asMap()
              .entries
              .map(
                (entry) => _buildColorTile(
                  'Chart ${entry.key + 1}',
                  entry.value,
                  isSmall: true,
                ),
              )
              .toList(),
    );
  }

  Widget _buildUIExample() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.cardColor,
        borderRadius: BorderRadius.circular(DimensionConstants.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.inventory,
                color: ColorConstants.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Producto de Ejemplo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.textPrimaryColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ColorConstants.stockHighColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'En Stock',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Este es un ejemplo de cómo se ve la nueva paleta de colores en la interfaz de usuario.',
            style: TextStyle(
              color: ColorConstants.textSecondaryColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.primaryColor,
                    foregroundColor: ColorConstants.textOnPrimaryColor,
                  ),
                  child: const Text('Botón Principal'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorConstants.primaryColor,
                    side: const BorderSide(color: ColorConstants.primaryColor),
                  ),
                  child: const Text('Botón Secundario'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorTile(String name, Color color, {bool isSmall = false}) {
    final size = isSmall ? 60.0 : 80.0;
    final textColor = ColorPaletteHelper.getContrastingTextColor(color);

    return Expanded(
      child: Container(
        height: size,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorConstants.dividerColor, width: 1),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              color: textColor,
              fontSize: isSmall ? 10 : 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildGradientTile(String name, LinearGradient gradient) {
    return Expanded(
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorConstants.dividerColor, width: 1),
        ),
        child: Center(
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
