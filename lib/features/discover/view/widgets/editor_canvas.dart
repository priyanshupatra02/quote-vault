import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quote_vault/data/model/quote_model.dart';

class EditorCanvas extends StatelessWidget {
  final GlobalKey repaintKey;
  final QuoteModel quote;
  final BoxDecoration background;
  final TextStyle fontStyle;
  final double textSize;
  final Color textColor;
  final VoidCallback onShuffle;

  const EditorCanvas({
    super.key,
    required this.repaintKey,
    required this.quote,
    required this.background,
    required this.fontStyle,
    required this.textSize,
    required this.textColor,
    required this.onShuffle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Stack(
          children: [
            // The Card
            Hero(
              tag: 'quote_card_preview',
              child: RepaintBoundary(
                key: repaintKey,
                child: AspectRatio(
                  aspectRatio: 4 / 5,
                  child: Container(
                    decoration: background.copyWith(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Content
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Quote
                                Text(
                                  quote.content,
                                  textAlign: TextAlign.center,
                                  style: fontStyle.copyWith(
                                    fontSize: textSize,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                // Separator
                                Container(
                                  height: 2,
                                  width: 40,
                                  color: textColor.withOpacity(0.3),
                                ),
                                const SizedBox(height: 20),
                                // Author
                                Text(
                                  quote.author.toUpperCase(),
                                  style: fontStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor.withOpacity(0.8),
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Branding
                        Positioned(
                          bottom: 24,
                          right: 0,
                          left: 0,
                          child: Center(
                            child: Text(
                              'QuoteVault',
                              style: GoogleFonts.inter(
                                color: textColor.withOpacity(0.4),
                                fontSize: 12,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Shuffle Button (Bottom Right of canvas area)
            Positioned(
              bottom: 0,
              right: 0,
              child: FloatingActionButton.extended(
                onPressed: onShuffle,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 4,
                icon: const Icon(Icons.shuffle),
                label: const Text('Shuffle', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
