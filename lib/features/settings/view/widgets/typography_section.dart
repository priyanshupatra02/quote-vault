import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class TypographySection extends StatefulWidget {
  const TypographySection({super.key});

  @override
  State<TypographySection> createState() => _TypographySectionState();
}

class _TypographySectionState extends State<TypographySection> {
  double _fontSize = 50;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 12),
          child: Text(
            'TYPOGRAPHY',
            style: AppTextStyles.label.copyWith(
              color: AppColors.textSecondary(context),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
            ),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Column(
            children: [
              // Preview Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                constraints: const BoxConstraints(minHeight: 140),
                decoration: BoxDecoration(
                  color: AppColors.background(context),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '"Simplicity is the ultimate sophistication."',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.display.copyWith(
                        fontSize: 18 + (_fontSize / 10), // Simple scaling logic
                        fontWeight: FontWeight.w500,
                        color: AppColors.text(context),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'LEONARDO DA VINCI',
                      style: AppTextStyles.label.copyWith(
                        fontSize: 10 + (_fontSize / 20),
                        color: AppColors.textSecondary(context),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Slider Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FONT SIZE ADJUSTMENT',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.textSecondary(context),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Slider
              Row(
                children: [
                  Icon(Icons.text_decrease, color: AppColors.textSecondary(context)),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 6,
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: isDark ? Colors.grey[700] : Colors.grey[200],
                        thumbColor: Colors.white,
                        overlayColor: AppColors.primary.withOpacity(0.2),
                      ),
                      child: Slider(
                        value: _fontSize,
                        min: 0,
                        max: 100,
                        onChanged: (val) {
                          setState(() {
                            _fontSize = val;
                          });
                        },
                      ),
                    ),
                  ),
                  Icon(Icons.text_increase, color: AppColors.textSecondary(context)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
