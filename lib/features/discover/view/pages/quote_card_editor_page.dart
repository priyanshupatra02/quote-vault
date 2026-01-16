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
import 'package:quote_vault/features/discover/controller/pod/quote_editor_pod.dart';
import 'package:quote_vault/features/discover/view/widgets/editor_canvas.dart';
import 'package:quote_vault/features/discover/view/widgets/editor_controls.dart';
import 'package:share_plus/share_plus.dart';

class QuoteCardEditorPage extends ConsumerStatefulWidget {
  final QuoteModel quote;

  const QuoteCardEditorPage({super.key, required this.quote});

  @override
  ConsumerState<QuoteCardEditorPage> createState() => _QuoteCardEditorPageState();
}

class _QuoteCardEditorPageState extends ConsumerState<QuoteCardEditorPage> {
  final GlobalKey _globalKey = GlobalKey();

  void _shuffle() {
    HapticFeedback.lightImpact();
    ref.read(quoteEditorProvider.notifier).shuffle();
  }

  Future<void> _saveAndShare() async {
    final notifier = ref.read(quoteEditorProvider.notifier);
    notifier.startSaving();
    try {
      final boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final imagePath =
          '${directory.path}/quote_vault_personal_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(imagePath);
      await file.writeAsBytes(pngBytes);

      if (mounted) {
        final box = context.findRenderObject() as RenderBox?;
        await Share.shareXFiles(
          [XFile(imagePath)],
          text: 'Created with QuoteVault',
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        );
      }
    } catch (e) {
      debugPrint('Error saving image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save image: $e')),
        );
      }
    } finally {
      if (mounted) notifier.stopSaving();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final state = ref.watch(quoteEditorProvider);
    final notifier = ref.read(quoteEditorProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Column(
        children: [
          // 1. Navigation Bar
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: AppColors.textSecondary(context)),
                  ),

                  // Title
                  Text(
                    'Personalize Quote Card',
                    style: AppTextStyles.pageTitle(context).copyWith(
                      fontSize: 18,
                      color: AppColors.text(context),
                    ),
                  ),

                  // Save Button
                  ElevatedButton(
                    onPressed: state.isSaving ? null : _saveAndShare,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      elevation: 0,
                    ),
                    child: state.isSaving
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),

          // 2. Main Canvas Area
          Expanded(
            child: EditorCanvas(
              repaintKey: _globalKey,
              quote: widget.quote,
              background: QuoteEditorNotifier.backgrounds[state.backgroundIndex],
              fontStyle: EditorControls.getFontStyle(state.selectedFont),
              textSize: state.textSize,
              textColor: state.textColor,
              onShuffle: _shuffle,
            ),
          ),

          // 3. Bottom Controls
          EditorControls(
            textSize: state.textSize,
            onTextSizeChanged: notifier.updateTextSize,
            selectedFont: state.selectedFont,
            onFontChanged: notifier.updateFont,
          ),
        ],
      ),
    );
  }
}
