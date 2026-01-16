import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class QuoteResultCard extends StatelessWidget {
  final String text;
  final String author;

  const QuoteResultCard({
    super.key,
    required this.text,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
        boxShadow: [
          // Subtle shadow hint
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Bookmark Icon (Top Right)
          Positioned(
            right: 0,
            top: 0,
            child: Icon(
              Icons.bookmark_outline,
              color: Colors.grey.shade400,
              size: 20, // text-xl roughly
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 24.0), // space for bookmark
                child: Text(
                  '"$text"',
                  style: AppTextStyles.serif(context).copyWith(
                    fontSize: 18,
                    color: Colors.grey.shade100, // text-gray-100
                    height: 1.6, // leading-relaxed
                  ),
                ),
              ),
              const SizedBox(height: 12), // mb-3
              Row(
                children: [
                  Container(
                    width: 20, // w-5
                    height: 1, // h-[1px]
                    color: AppColors.primary.withOpacity(0.5),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    author.toUpperCase(),
                    style: AppTextStyles.display(context).copyWith(
                      fontSize: 11, // text-xs
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade500,
                      letterSpacing: 1.0, // tracking-wider
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
