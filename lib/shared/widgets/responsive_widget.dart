// 📱 Responsive Helper Widget
// Widget helper para facilitar el diseño responsive

import 'package:flutter/material.dart';
import '../../core/constants/responsive_constants.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  const ResponsiveWidget({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ResponsiveConstants.isLargeDesktop(context) && largeDesktop != null) {
      return largeDesktop!;
    }
    if (ResponsiveConstants.isDesktop(context) && desktop != null) {
      return desktop!;
    }
    if (ResponsiveConstants.isTablet(context) && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  const ResponsiveBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceType deviceType;

    if (ResponsiveConstants.isLargeDesktop(context)) {
      deviceType = DeviceType.largeDesktop;
    } else if (ResponsiveConstants.isDesktop(context)) {
      deviceType = DeviceType.desktop;
    } else if (ResponsiveConstants.isTablet(context)) {
      deviceType = DeviceType.tablet;
    } else {
      deviceType = DeviceType.mobile;
    }

    return builder(context, deviceType);
  }
}

enum DeviceType { mobile, tablet, desktop, largeDesktop }

class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;
  final T? largeDesktop;

  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  T getValue(BuildContext context) {
    if (ResponsiveConstants.isLargeDesktop(context) && largeDesktop != null) {
      return largeDesktop!;
    }
    if (ResponsiveConstants.isDesktop(context) && desktop != null) {
      return desktop!;
    }
    if (ResponsiveConstants.isTablet(context) && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

// Extensión para facilitar el uso
extension ResponsiveExtension on BuildContext {
  bool get isMobile => ResponsiveConstants.isMobile(this);
  bool get isTablet => ResponsiveConstants.isTablet(this);
  bool get isDesktop => ResponsiveConstants.isDesktop(this);
  bool get isLargeDesktop => ResponsiveConstants.isLargeDesktop(this);

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  double get horizontalMargin => ResponsiveConstants.getHorizontalMargin(this);
  double get verticalMargin => ResponsiveConstants.getVerticalMargin(this);
  double get spacing => ResponsiveConstants.getSpacing(this);
  double get smallSpacing => ResponsiveConstants.getSmallSpacing(this);

  int get columns => ResponsiveConstants.getColumns(this);
  int get productsPerRow => ResponsiveConstants.getProductsPerRow(this);
}
