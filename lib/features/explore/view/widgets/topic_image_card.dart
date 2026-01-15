import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class TopicImageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final IconData icon;
  final Color accentColor;

  const TopicImageCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // rounded-2xl
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: Colors.grey.shade900);
            },
          ),

          // Mix-blend overlay simulation (Color filter)
          Container(
            color: accentColor.withOpacity(0.6), // mix-blend-multiply approx
          ),

          // Gradient Overlay (bottom up)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black87, // from-black/80
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Icon Badge (Top Right)
          Positioned(
            top: 12,
            right: 12,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  color: Colors.white.withOpacity(0.1),
                  child: Icon(
                    icon,
                    size: 20,
                    color: Colors.white.withOpacity(0.9), // rough accent color light
                  ),
                ),
              ),
            ),
          ),

          // Content (Bottom Left)
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.display.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.display.copyWith(
                    fontSize: 12, // text-xs
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8), // accent color light
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
