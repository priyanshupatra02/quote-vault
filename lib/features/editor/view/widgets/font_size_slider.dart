import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class FontSizeSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const FontSizeSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SIZE',
              style: AppTextStyles.display(context).copyWith(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.text(context).withOpacity(0.4),
                letterSpacing: 1.2,
              ),
            ),
            Text(
              '${value.toInt()}px',
              style: AppTextStyles.display(context).copyWith(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.text(context).withOpacity(0.4),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              'A',
              style: AppTextStyles.display(context).copyWith(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary(context), // gray-500
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF374151)
                      : Colors.grey.shade300,
                  thumbColor: Colors.white,
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10, elevation: 4),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                ),
                child: Slider(
                  value: value,
                  min: 16,
                  max: 64,
                  onChanged: onChanged,
                ),
              ),
            ),
            Text(
              'A',
              style: AppTextStyles.display(context).copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD1D5DB), // gray-300
              ),
            ),
          ],
        ),
      ],
    );
  }
}
