import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class TypefaceSelector extends StatelessWidget {
  final TextStyle selectedFont;
  final ValueChanged<TextStyle> onFontSelected;

  const TypefaceSelector({
    super.key,
    required this.selectedFont,
    required this.onFontSelected,
  });

  @override
  Widget build(BuildContext context) {
    final fonts = [
      _FontOption(GoogleFonts.playfairDisplay(), 'Playfair'),
      _FontOption(GoogleFonts.merriweather(), 'Merriweather'),
      _FontOption(GoogleFonts.roboto(), 'Roboto'),
      _FontOption(GoogleFonts.inter(), 'Inter'),
      _FontOption(GoogleFonts.lora(), 'Lora'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TYPEFACE',
          style: AppTextStyles.display.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.text(context).withOpacity(0.4),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: fonts.length,
            separatorBuilder: (c, i) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final font = fonts[index];
              final isSelected = selectedFont.fontFamily == font.style.fontFamily;
              final isDark = Theme.of(context).brightness == Brightness.dark;

              return GestureDetector(
                onTap: () => onFontSelected(font.style),
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.2)
                        : (isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.black.withOpacity(0.05)),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.black.withOpacity(0.1)),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 0,
                            )
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Aa',
                        style: font.style.copyWith(
                          fontSize: 24,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.text(context).withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        font.name,
                        style: AppTextStyles.display.copyWith(
                          fontSize: 10,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.text(context).withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FontOption {
  final TextStyle style;
  final String name;

  _FontOption(this.style, this.name);
}
