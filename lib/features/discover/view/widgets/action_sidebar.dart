import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/data/model/quote_model.dart';
import 'package:quote_vault/features/discover/view/pages/quote_card_editor_page.dart';
import 'package:quote_vault/features/discover/view/widgets/quote_share_card.dart';
import 'package:quote_vault/features/favorites/controller/pod/favorites_pod.dart';
import 'package:quote_vault/features/settings/controller/user_stats_provider.dart';
import 'package:share_plus/share_plus.dart';

class ActionSidebar extends ConsumerStatefulWidget {
  final QuoteModel? currentQuote;

  const ActionSidebar({super.key, this.currentQuote});

  @override
  ConsumerState<ActionSidebar> createState() => _ActionSidebarState();
}

class _ActionSidebarState extends ConsumerState<ActionSidebar> {
  // Local optimistic state
  bool? _optimisticIsLiked;
  int? _optimisticLikeCount;

  @override
  void didUpdateWidget(covariant ActionSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset optimistic state when quote changes
    if (widget.currentQuote?.id != oldWidget.currentQuote?.id) {
      _optimisticIsLiked = null;
      _optimisticLikeCount = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final quote = widget.currentQuote;
    if (quote == null) return const SizedBox.shrink();

    // Determine current state: Use optimistic if available, otherwise source of truth
    final isFavoriteSource = ref.watch(isFavoriteProvider(quote.id));
    final isLiked = _optimisticIsLiked ?? isFavoriteSource;

    // Calculate display count
    // If we have an optimistic count, use it.
    // Otherwise use the quote's count.
    // We also need to handle the case where the source of truth (isFavoriteSource)
    // might be different from when we initialized the count, but for now
    // assuming quote.likesCount is the baseline.
    final displayCount = _optimisticLikeCount ?? quote.likesCount;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Like/Favorite Button
        SidebarActionButton(
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          label: displayCount.toString(),
          isLiked: isLiked,
          onTap: () => _handleLike(quote, isLiked, displayCount),
        ),
        const SizedBox(height: 20),

        // Share Button
        SidebarActionButton(
          icon: Icons.ios_share,
          label: 'Share',
          onTap: () => _handleShareInteract(context, ref),
        ),
      ],
    );
  }

  void _handleLike(QuoteModel quote, bool currentLikedState, int currentCount) {
    // 1. Optimistic Update
    setState(() {
      _optimisticIsLiked = !currentLikedState;
      _optimisticLikeCount =
          currentLikedState ? (currentCount - 1).clamp(0, 999999) : (currentCount + 1);
    });

    // 2. Haptic feedback immediately
    HapticFeedback.lightImpact();

    // 3. API Call in background
    ref.read(favoritesProvider.notifier).toggleFavorite(quote);

    // 4. Show snackbar
    ScaffoldMessenger.of(context).clearSnackBars(); // Clear existing to prevent stacking
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          !currentLikedState // use the NEW state (which is !current)
              ? 'Added to favorites'
              : 'Removed from favorites',
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleShareInteract(BuildContext context, WidgetRef ref) {
    if (widget.currentQuote == null) return;
    ref.read(userStatsProvider.notifier).incrementShare();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface(context),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(0.7)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Share Quote',
                      style: AppTextStyles.pageTitle(context).copyWith(
                        fontSize: 18,
                        color: AppColors.text(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Options
                _ShareOptionTile(
                  icon: Icons.text_fields_rounded,
                  title: 'Share as Text',
                  subtitle: 'Copy quote to clipboard or share directly',
                  iconColor: Colors.blue,
                  onTap: () {
                    Navigator.pop(ctx);
                    _shareAsText();
                  },
                ),
                const SizedBox(height: 10),
                _ShareOptionTile(
                  icon: Icons.image_rounded,
                  title: 'Share Quote Card',
                  subtitle: 'Beautiful image ready to post',
                  iconColor: Colors.purple,
                  onTap: () {
                    Navigator.pop(ctx);
                    _shareAsImage(context);
                  },
                ),
                const SizedBox(height: 10),
                _ShareOptionTile(
                  icon: Icons.auto_awesome_rounded,
                  title: 'Personalize & Save',
                  subtitle: 'Customize fonts, colors, and backgrounds',
                  iconColor: Colors.orange,
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuoteCardEditorPage(quote: widget.currentQuote!),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _shareAsText() {
    final shareText =
        '"${widget.currentQuote!.content}"\n\n— ${widget.currentQuote!.author}\n\nShared via QuoteVault';

    Share.share(
      shareText,
      subject: 'Quote by ${widget.currentQuote!.author}',
    );
    HapticFeedback.lightImpact();
  }

  void _shareAsImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _SharePreviewDialog(quote: widget.currentQuote!),
    );
  }
}

class _SharePreviewDialog extends StatefulWidget {
  final QuoteModel quote;

  const _SharePreviewDialog({required this.quote});

  @override
  State<_SharePreviewDialog> createState() => _SharePreviewDialogState();
}

class _SharePreviewDialogState extends State<_SharePreviewDialog> {
  final GlobalKey _globalKey = GlobalKey();
  bool _isGenerating = false;

  Future<void> _captureAndShare() async {
    setState(() => _isGenerating = true);
    try {
      // 1. Capture Image
      final boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      // Use higher pixel ratio for better quality
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // 2. Save to Temp File
      final directory = await getTemporaryDirectory();
      final imagePath =
          '${directory.path}/quote_vault_share_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(imagePath);
      await file.writeAsBytes(pngBytes);

      // 3. Share
      if (mounted) {
        final box = context.findRenderObject() as RenderBox?;
        await Share.shareXFiles(
          [XFile(imagePath)],
          text: 'Shared via QuoteVault',
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        );
        if (mounted) Navigator.pop(context); // Close dialog after share
      }
    } catch (e) {
      debugPrint('Error generating image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate image: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Preview Card
          RepaintBoundary(
            key: _globalKey,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: QuoteShareCard(
                quote: widget.quote.content,
                author: widget.quote.author,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isGenerating ? null : _captureAndShare,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _isGenerating
                  ? const SizedBox(
                      width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.share),
              label: Text(
                _isGenerating ? 'GENERATING...' : 'SHARE IMAGE',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
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

/// Premium styled option tile for the share bottom sheet
class _ShareOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  const _ShareOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.label(context).copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.subDetail(context).copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary(context).withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
