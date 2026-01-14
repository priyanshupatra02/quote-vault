import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF5417cf);
  static const Color backgroundLight = Color(0xFFf6f6f8);

  // Dark mode colors as per design
  static const Color backgroundDark = Color(0xFF161121);
  static const Color surfaceDark = Color(0xFF1f1a2e);

  // Gradients
  static const RadialGradient premiumGradient = RadialGradient(
    center: Alignment(0, -1), // Top center
    radius: 1.0,
    colors: [
      Color.fromRGBO(84, 23, 207, 0.25), // primary with 0.25 opacity
      Color.fromRGBO(22, 17, 33, 0), // backgroundDark with 0 opacity
    ],
    stops: [0.0, 0.7],
  );

  static const Color textDark = Colors.white;
  static const Color textLight = Color(0xFF1a202c); // slate-900 like
}
