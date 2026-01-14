import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class ActionSidebar extends StatelessWidget {
  const ActionSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildActionButton(
          icon: Icons.favorite,
          label: '12k',
          isLiked: true, // Example state
        ),
        const SizedBox(height: 24),
        _buildActionButton(
          icon: Icons.bookmark_border,
          label: 'Save',
        ),
        const SizedBox(height: 24),
        _buildActionButton(
          icon: Icons.ios_share, // or simple share
          label: 'Share',
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    bool isLiked = false,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.05),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: ClipOval(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Center(
                child: Icon(
                  icon,
                  color: isLiked ? Colors.red[400] : Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.buttonText.copyWith(
            color: Colors.white.withOpacity(0.6),
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
