import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';

class BackgroundLayer extends StatelessWidget {
  const BackgroundLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Base Background (cream for light, dark for dark)
        Container(
          color: AppColors.background(context),
        ),

        // Gradient & Glow (dark mode only)
        if (isDark) ...[
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
        ],

        // Noise Texture (from HTML design - 0.4 opacity for light mode)
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: isDark ? 0.03 : 0.4,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCjY5fBO1w18tkHxw5s1BwXR-S7CKnRtxI-WeXwcdt4JGqdtVu4Cni88Hpyjy8GQ-sE5dcAU2Ua4G-66QAwUdAWLaOnrubV5nAOlFJPjRscq20YC3_sEduDpiZE2tYVC5eHo-ZIabvMlm0ECWkrNxCkpaMgLBUhP_p1li5OlSOQ06I36AXP0ylBxpVfXTDLNGrMpBbeUbND7JE3WhS9DqZ2fafUv-5BJg28SzYpke3oC81YzeA3sNVpiNYPmgqRpCGNZAZrRWwxSIo',
                fit: BoxFit.none,
                repeat: ImageRepeat.repeat,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
