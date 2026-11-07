import 'package:flutter/material.dart';

/// Reusable Responsive Layout Helper
/// Memenuhi ketentuan UTS: Minimal 2 kondisi layout (compact & wide/expanded)
/// Menggunakan MediaQuery dan LayoutBuilder
class ResponsiveLayout extends StatelessWidget {
  final Widget compact;
  final Widget? wide;

  const ResponsiveLayout({
    super.key,
    required this.compact,
    this.wide,
  });

  static const double compactBreakpoint = 600.0;
  static const double wideBreakpoint = 1000.0;

  static bool isCompact(BuildContext context) =>
      MediaQuery.of(context).size.width < compactBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= compactBreakpoint && width < wideBreakpoint;
  }

  static bool isWide(BuildContext context) =>
      MediaQuery.of(context).size.width >= compactBreakpoint;

  /// Menghitung jumlah kolom grid secara dinamis berdasarkan lebar layar
  static int getGridCrossAxisCount(BuildContext context, {int compactCount = 2, int wideCount = 3, int desktopCount = 4}) {
    final width = MediaQuery.of(context).size.width;
    if (width >= wideBreakpoint) return desktopCount;
    if (width >= compactBreakpoint) return wideCount;
    return compactCount;
  }

  /// Menghitung padding horizontal secara responsif
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= wideBreakpoint) {
      return EdgeInsets.symmetric(horizontal: (width - 960) / 2, vertical: 16);
    } else if (width >= compactBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= compactBreakpoint && wide != null) {
          return wide!;
        }
        return compact;
      },
    );
  }
}
