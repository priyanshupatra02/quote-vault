import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';

class AnimatedMeshGradient extends StatefulWidget {
  const AnimatedMeshGradient({super.key});

  @override
  State<AnimatedMeshGradient> createState() => _AnimatedMeshGradientState();
}

class _AnimatedMeshGradientState extends State<AnimatedMeshGradient>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Animation values
  late Animation<double> _point1X; // Center-Middle X
  late Animation<double> _point2Y; // Right-Middle Y
  late Animation<double> _colorShift; // 0.0 to 1.0 for manual interpolation

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _point1X = Tween<double>(begin: 0.2, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _point2Y = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _colorShift = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine colors based on theme
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).primaryColor;

    // Define palette
    final Color c1 =
        isDark ? primary.withOpacity(0.3) : primary.withOpacity(0.15); // Top-left accent

    final Color c2 = isDark
        ? const Color(0xFF2c0b6e).withOpacity(0.4)
        : AppColors.lavenderSoft; // Secondary accent

    final Color c3 = isDark ? Colors.black.withOpacity(0.1) : Colors.white; // Base

    // Calculating dynamic color inside build to respond to theme changes
    // Interpolating between primary and gold/muted tones for a premium feel
    final dynamicColor = Color.lerp(
            primary.withOpacity(isDark ? 0.4 : 0.2),
            isDark ? AppColors.primary.withOpacity(0.3) : AppColors.primary.withOpacity(0.4),
            _colorShift.value) ??
        primary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _MeshGradientPainter(
            point1X: _point1X.value,
            point2Y: _point2Y.value,
            c1: c1,
            c2: c2,
            c3: c3,
            dynamicColor: dynamicColor,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _MeshGradientPainter extends CustomPainter {
  final double point1X;
  final double point2Y;
  final Color c1;
  final Color c2;
  final Color c3;
  final Color dynamicColor;

  _MeshGradientPainter({
    required this.point1X,
    required this.point2Y,
    required this.c1,
    required this.c2,
    required this.c3,
    required this.dynamicColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Defined points
    // Row 1
    final p0 = Offset(0, 0);
    final p1 = Offset(w * 0.5, 0);
    final p2 = Offset(w, 0);

    // Row 2
    final p3 = Offset(0, h * 0.4);
    final p4 = Offset(w * point1X, h * 0.5); // Animating Center
    final p5 = Offset(w, h * point2Y); // Animating Right Edge

    // Row 3
    final p6 = Offset(0, h);
    final p7 = Offset(w * 0.6, h);
    final p8 = Offset(w, h);

    final vertices = [
      p0,
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
      p8,
    ];

    // Colors Assignment
    // Using a softer, more organic distribution compliant with AppColors
    final colors = [
      c1, c3, c2, // Row 1: Primary(faint) - Base - Secondary
      c2, dynamicColor, c3, // Row 2: Secondary - Dynamic - Base
      c3, c1, c2, // Row 3: Base - Primary(faint) - Secondary
    ];

    final indices = [
      0, 1, 3, 1, 4, 3, // Quad 1
      1, 2, 4, 2, 5, 4, // Quad 2
      3, 4, 6, 4, 7, 6, // Quad 3
      4, 5, 7, 5, 8, 7, // Quad 4
    ];

    final vertexObj = Vertices(
      VertexMode.triangles,
      vertices,
      colors: colors,
      indices: indices,
    );

    final paint = Paint();
    // Using simple formatting for gradient
    canvas.drawVertices(vertexObj, BlendMode.dst, paint);
  }

  @override
  bool shouldRepaint(covariant _MeshGradientPainter oldDelegate) {
    return oldDelegate.point1X != point1X ||
        oldDelegate.point2Y != point2Y ||
        oldDelegate.dynamicColor != dynamicColor ||
        oldDelegate.c1 != c1; // Repaint if colors change (theme switch)
  }
}
