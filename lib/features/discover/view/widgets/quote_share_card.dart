import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class QuoteShareCard extends StatelessWidget {
  final String quote;
  final String author;
  final double aspectRatio;

  const QuoteShareCard({
    super.key,
    required this.quote,
    required this.author,
    this.aspectRatio = 4 / 5, // Default improved social media ratio (1080x1350)
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF5417cf), // Primary
              Color(0xFF2c0b6e), // Darker primary/purple
            ],
          ),
        ),
        child: Stack(
          children: [
            // Watermark / Branding
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.white54, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'QuoteVault',
                    style: AppTextStyles.label.copyWith(
                      color: Colors.white54,
                      fontSize: 14,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.format_quote, color: Colors.white24, size: 48),
                    const SizedBox(height: 24),
                    Text(
                      quote,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      height: 2,
                      width: 40,
                      color: Colors.white24,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      author.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
