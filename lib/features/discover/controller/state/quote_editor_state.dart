import 'package:flutter/material.dart';

class QuoteEditorState {
  final String selectedFont;
  final double textSize;
  final Color textColor;
  final int backgroundIndex;
  final bool isSaving;

  const QuoteEditorState({
    this.selectedFont = 'Inter',
    this.textSize = 28.0,
    this.textColor = Colors.white,
    this.backgroundIndex = 0,
    this.isSaving = false,
  });

  QuoteEditorState copyWith({
    String? selectedFont,
    double? textSize,
    Color? textColor,
    int? backgroundIndex,
    bool? isSaving,
  }) {
    return QuoteEditorState(
      selectedFont: selectedFont ?? this.selectedFont,
      textSize: textSize ?? this.textSize,
      textColor: textColor ?? this.textColor,
      backgroundIndex: backgroundIndex ?? this.backgroundIndex,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuoteEditorState &&
        other.selectedFont == selectedFont &&
        other.textSize == textSize &&
        other.textColor == textColor &&
        other.backgroundIndex == backgroundIndex &&
        other.isSaving == isSaving;
  }

  @override
  int get hashCode {
    return selectedFont.hashCode ^
        textSize.hashCode ^
        textColor.hashCode ^
        backgroundIndex.hashCode ^
        isSaving.hashCode;
  }
}
