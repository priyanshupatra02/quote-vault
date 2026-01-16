import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'package:path_provider/path_provider.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/data/model/quote_model.dart';
import 'package:quote_vault/features/discover/view/widgets/editor_canvas.dart';
import 'package:quote_vault/features/discover/view/widgets/editor_controls.dart';
import 'package:share_plus/share_plus.dart';

class QuoteCardEditorPage extends StatefulWidget {
  final QuoteModel quote;

  const QuoteCardEditorPage({super.key, required this.quote});

  @override
  State<QuoteCardEditorPage> createState() => _QuoteCardEditorPageState();
}

class _QuoteCardEditorPageState extends State<QuoteCardEditorPage> {
  final GlobalKey _globalKey = GlobalKey();

  // State variables
  String _selectedFont = 'Inter';
  double _textSize = 28.0;
  Color _textColor = Colors.white;
  int _backgroundIndex = 0;
  bool _isSaving = false;

  // Background Presets
  final List<BoxDecoration> _backgrounds = [
    // 0: Deep Purple Gradient (Default)
    const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF5417cf), Color(0xFF2c0b6e)],
      ),
    ),
    // 1: Midnight Aurora (Gradient)
    const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
      ),
    ),
    // 2: Clean White (Dark Text)
    const BoxDecoration(color: Colors.white),
    // 3: Minimal Dark
    const BoxDecoration(color: Color(0xFF1A1C1E)),
    // 4: Northern Lights (Gradient)
    const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [Color(0xFF00c6ff), Color(0xFF0072ff)],
      ),
    ),
    // 5: Sunset Vibes (Mixed Gradient)
    const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFF9A9E), Color(0xFFFECFEF), Color(0xFF9999FF)],
      ),
    ),
    // 6: Ocean Depths (Mixed Gradient)
    const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
      ),
    ),
    // 7: Berry Fusion (Mixed Gradient)
    const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
      ),
    ),
    // 8: Golden Hour
    const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFf6d365), Color(0xFFfda085)],
      ),
    ),
  ];

  void _shuffle() {
    HapticFeedback.lightImpact();
    setState(() {
      _backgroundIndex = (_backgroundIndex + 1) % _backgrounds.length;
      final fonts = EditorControls.fonts;
      _selectedFont = fonts[DateTime.now().millisecond % fonts.length];

      // Auto-adjust text color based on background
      // Simple logic: if background 2 (White), text black. Else white.
      if (_backgroundIndex == 2) {
        _textColor = const Color(0xFF1A1C1E);
      } else {
        _textColor = Colors.white;
      }
    });
  }

  Future<void> _saveAndShare() async {
    setState(() => _isSaving = true);
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
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

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
                    style: AppTextStyles.pageTitle.copyWith(
                      fontSize: 18,
                      color: AppColors.text(context),
                    ),
                  ),

                  // Save Button
                  ElevatedButton(
                    onPressed: _isSaving ? null : _saveAndShare,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      elevation: 0,
                    ),
                    child: _isSaving
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
              background: _backgrounds[_backgroundIndex],
              fontStyle: EditorControls.getFontStyle(_selectedFont),
              textSize: _textSize,
              textColor: _textColor,
              onShuffle: _shuffle,
            ),
          ),

          // 3. Bottom Controls
          EditorControls(
            textSize: _textSize,
            onTextSizeChanged: (v) => setState(() => _textSize = v),
            selectedFont: _selectedFont,
            onFontChanged: (f) => setState(() => _selectedFont = f),
          ),
        ],
      ),
    );
  }
}
