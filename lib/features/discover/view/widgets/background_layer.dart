import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';

class BackgroundLayer extends StatelessWidget {
  const BackgroundLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Background
        Container(
          color: AppColors.backgroundDark,
        ),

        // Top Spotlight (Radial Gradient)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.premiumGradient,
            ),
          ),
        ),

        // Bottom Right Glow
        Positioned(
          bottom: -80,
          right: -80,
          child: Container(
            width: 256,
            height: 256,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.1),
            ),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),

        // Noise Texture
        Positioned.fill(
          child: Opacity(
            opacity: 0.03,
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCjwbG_XzNhyvOk0iverYxK_JQY2kscej8AftT1zEkmbta4BrYWankkOQuKMGMyK38zVGiPk1bSGVM6ObPj61jWzzU2DUjkfBl9Me_3wrArw4gj1FYFTBpTHY_KAAQXG3DIDMzjVuwn3V2cKAoLLzpGIjFYZ93j7i_uXxQ3jAUEfgSn-m16TZPhP8iGDm1JOXp94alZcWH1sOzj14cGw4nMV1jut0zuMEOt42XwIxw7L90gfv1paZ9Fnkjzb8L2ABtrBzk8jxaIgb8',
              fit: BoxFit.none,
              repeat: ImageRepeat.repeat,
            ),
          ),
        ),
      ],
    );
  }
}
