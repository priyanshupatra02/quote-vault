import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/features/discover/controller/state/quote_editor_state.dart';
import 'package:quote_vault/features/discover/view/widgets/editor_controls.dart';

final quoteEditorProvider = StateNotifierProvider<QuoteEditorNotifier, QuoteEditorState>((ref) {
  return QuoteEditorNotifier();
});

class QuoteEditorNotifier extends StateNotifier<QuoteEditorState> {
  QuoteEditorNotifier() : super(const QuoteEditorState());

  // Background Presets (Moved from Page)
  static final List<BoxDecoration> backgrounds = [
    // 0: Deep Purple Gradient (Default)
    const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF5417cf), Color(0xFF2c0b6e)],
      ),
    ),
    // 1: Midnight Aurora (Gradient)
    const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
      ),
    ),
    // 2: Clean White (Dark Text)
    const BoxDecoration(color: Colors.white),
    // 3: Minimal Dark
    const BoxDecoration(color: Color(0xFF1A1C1E)),
    // 4: Northern Lights (Gradient)
    const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [Color(0xFF00c6ff), Color(0xFF0072ff)],
      ),
    ),
    // 5: Sunset Vibes (Mixed Gradient)
    const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFF9A9E), Color(0xFFFECFEF), Color(0xFF9999FF)],
      ),
    ),
    // 6: Ocean Depths (Mixed Gradient)
    const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
      ),
    ),
    // 7: Berry Fusion (Mixed Gradient)
    const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
      ),
    ),
    // 8: Golden Hour
    const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFf6d365), Color(0xFFfda085)],
      ),
    ),
  ];

  void updateFont(String font) {
    state = state.copyWith(selectedFont: font);
  }

  void updateTextSize(double size) {
    state = state.copyWith(textSize: size);
  }

  void startSaving() {
    state = state.copyWith(isSaving: true);
  }

  void stopSaving() {
    state = state.copyWith(isSaving: false);
  }

  void shuffle() {
    final random = Random();
    final nextIndex = (state.backgroundIndex + 1) % backgrounds.length;
    final fonts = EditorControls.fonts;
    final nextFont = fonts[random.nextInt(fonts.length)];

    // Auto-adjust text color based on background
    Color nextColor = Colors.white;
    if (nextIndex == 2) {
      // White background index
      nextColor = const Color(0xFF1A1C1E);
    }

    state = state.copyWith(
      backgroundIndex: nextIndex,
      selectedFont: nextFont,
      textColor: nextColor,
    );
  }
}
