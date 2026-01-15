import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final bool isWide; // To handle the "Humor" card being full width

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment(0.4, -0.8), // 145deg roughly
          end: Alignment(-0.4, 0.8),
          colors: [
            Color.fromRGBO(255, 255, 255, 0.05),
            Color.fromRGBO(255, 255, 255, 0.01),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Blob
            Positioned(
              right: -24,
              top: -24,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withOpacity(0.2),
                ),
                child: Container(// Blur
                    // Note: In Flutter, BackdropFilter applies to what's BELOW it.
                    // for a glowing blob, usually ImageFilter.blur on the container itself isn't direct.
                    // We can use MaskFilter (outside) or stack a blur.
                    // Simplified approach: Just low opacity color, maybe add ImageFilter.blur
                    ),
              ),
            ),
            // Wide Card Gradient Overlay
            if (isWide)
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                width: 128,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        accentColor.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: isWide
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _buildIcon(),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildTitle(),
                                const SizedBox(height: 2),
                                _buildSubtitle(),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildIcon(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle(),
                            const SizedBox(height: 2),
                            _buildSubtitle(),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: isWide ? 48 : 40,
      height: isWide ? 48 : 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          color: accentColor.withOpacity(0.8), // approximate color-300
          size: isWide ? 24 : 20,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: AppTextStyles.serif.copyWith(
        fontSize: isWide ? 20 : 18,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      subtitle,
      style: AppTextStyles.display.copyWith(
        fontSize: isWide ? 11 : 10,
        color: Colors.white.withOpacity(0.5),
      ),
    );
  }
}
