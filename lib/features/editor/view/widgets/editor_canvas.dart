import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quote_vault/core/theme/app_colors.dart';

class EditorCanvas extends StatelessWidget {
  final String quoteText;
  final String author;
  final String backgroundUrl;
  final TextStyle textStyle;
  final double fontSize;

  const EditorCanvas({
    super.key,
    required this.quoteText,
    required this.author,
    required this.backgroundUrl,
    required this.textStyle,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), // rounded-2xl
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 40,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.network(
              backgroundUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: Colors.grey.shade900);
              },
            ),

            // Overlays
            Container(color: Colors.black.withOpacity(0.4)), // mix-blend-multiply approx
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                    Colors.black.withOpacity(0.2),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        '"$quoteText"',
                        textAlign: TextAlign.center,
                        style: textStyle.copyWith(
                          fontSize: fontSize,
                          color: Colors.white,
                          height: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Divider
                  Container(
                    width: 32,
                    height: 2,
                    color: AppColors.primary.withOpacity(0.8),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    '— $author',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 1.5, // tracking-widest
                    ),
                  ),
                  const SizedBox(height: 16), // Bottom padding balance
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
