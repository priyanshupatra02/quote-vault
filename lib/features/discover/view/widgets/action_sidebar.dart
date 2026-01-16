import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/data/model/quote_model.dart';
import 'package:quote_vault/features/favorites/controller/pod/favorites_pod.dart';
import 'package:share_plus/share_plus.dart';

class ActionSidebar extends ConsumerWidget {
  final QuoteModel? currentQuote;

  const ActionSidebar({super.key, this.currentQuote});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite =
        currentQuote != null ? ref.watch(isFavoriteProvider(currentQuote!.id)) : false;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Like/Favorite Button
        SidebarActionButton(
          icon: isFavorite ? Icons.favorite : Icons.favorite_border,
          label: currentQuote?.likesCount.toString() ?? '0',
          isLiked: isFavorite,
          onTap: () => _handleLike(context, ref),
        ),
        const SizedBox(height: 20),

        // Save/Bookmark Button
        SidebarActionButton(
          icon: Icons.bookmark_border,
          label: 'Save',
          onTap: () => _handleSave(context, ref),
        ),
        const SizedBox(height: 20),

        // Share Button
        SidebarActionButton(
          icon: Icons.ios_share,
          label: 'Share',
          onTap: () => _handleShare(context),
        ),
      ],
    );
  }

  void _handleLike(BuildContext context, WidgetRef ref) {
    if (currentQuote == null) return;

    ref.read(favoritesProvider.notifier).toggleFavorite(currentQuote!);

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ref.read(isFavoriteProvider(currentQuote!.id))
              ? 'Removed from favorites'
              : 'Added to favorites',
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleSave(BuildContext context, WidgetRef ref) {
    if (currentQuote == null) return;

    // For now, just add to favorites (same as like)
    // In a full implementation, this would show a bottom sheet to select/create collection
    ref.read(favoritesProvider.notifier).addToFavorites(currentQuote!);

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saved to favorites'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleShare(BuildContext context) {
    if (currentQuote == null) return;

    final shareText =
        '"${currentQuote!.content}"\n\n— ${currentQuote!.author}\n\nShared via QuoteVault';

    Share.share(
      shareText,
      subject: 'Quote by ${currentQuote!.author}',
    );

    HapticFeedback.lightImpact();
  }
}

class SidebarActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLiked;
  final VoidCallback? onTap;

  const SidebarActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.isLiked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = AppColors.text(context);

    // Light mode: white/40 bg with backdrop blur (from HTML)
    // Dark mode: white/5 bg with backdrop blur
    final containerColor = isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.4);
    final borderColor = isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: containerColor,
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: ClipOval(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Center(
                  child: Icon(
                    isLiked ? Icons.favorite : icon,
                    color: isLiked ? Colors.red[400] : iconColor,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary(context).withOpacity(isDark ? 0.6 : 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
