import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class EditorControls extends StatelessWidget {
  final double textSize;
  final ValueChanged<double> onTextSizeChanged;
  final String selectedFont;
  final ValueChanged<String> onFontChanged;

  const EditorControls({
    super.key,
    required this.textSize,
    required this.onTextSizeChanged,
    required this.selectedFont,
    required this.onFontChanged,
  });

  static const List<String> fonts = ['Inter', 'Playfair Display', 'Merriweather', 'Roboto', 'Lora'];

  static TextStyle getFontStyle(String fontName) {
    switch (fontName) {
      case 'Playfair Display':
        return GoogleFonts.playfairDisplay();
      case 'Merriweather':
        return GoogleFonts.merriweather();
      case 'Roboto':
        return GoogleFonts.roboto();
      case 'Lora':
        return GoogleFonts.lora();
      case 'Inter':
      default:
        return GoogleFonts.inter();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pull Handle
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary(context).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),

            // Size Row
            Row(
              children: [
                Text('SIZE', style: _labelStyle(context)),
                const Spacer(),
                Text('${textSize.toInt()}px',
                    style:
                        TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            Row(
              children: [
                Text('A',
                    style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      activeTrackColor: primaryColor,
                      inactiveTrackColor: AppColors.textSecondary(context).withOpacity(0.2),
                      thumbColor: Colors.white,
                      overlayColor: primaryColor.withOpacity(0.1),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10, elevation: 2),
                    ),
                    child: Slider(
                      value: textSize,
                      min: 16,
                      max: 48,
                      onChanged: onTextSizeChanged,
                    ),
                  ),
                ),
                Text('A',
                    style: TextStyle(
                        color: AppColors.text(context), fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),

            // Typeface Row
            Text('TYPEFACE', style: _labelStyle(context)),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: fonts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (ctx, index) {
                  final font = fonts[index];
                  final isSelected = selectedFont == font;

                  return GestureDetector(
                    onTap: () => onFontChanged(font),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 80,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primaryColor.withOpacity(0.05)
                            : AppColors.background(context),
                        border: Border.all(
                          color: isSelected
                              ? primaryColor
                              : AppColors.textSecondary(context).withOpacity(0.2),
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Aa',
                              style: getFontStyle(font).copyWith(
                                fontSize: 24,
                                color: AppColors.text(context),
                              )),
                          const SizedBox(height: 4),
                          Text(
                            font.split(' ')[0], // First word only for space
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? primaryColor : AppColors.textSecondary(context),
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
        ),
      ),
    );
  }

  TextStyle _labelStyle(BuildContext context) {
    return AppTextStyles.sectionLabel.copyWith(
      color: AppColors.textSecondary(context),
    );
  }
}
