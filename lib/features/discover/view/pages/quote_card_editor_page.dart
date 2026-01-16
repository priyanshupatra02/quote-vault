import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/data/model/quote_model.dart';
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
    // 1: Dark Overlay + Image
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
    // 4: Nature Green
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

  // Font Options
  final List<String> _fonts = ['Inter', 'Playfair Display', 'Merriweather', 'Roboto', 'Lora'];

  // Map font name to GoogleFonts style
  TextStyle _getFontStyle(String fontName) {
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

  void _shuffle() {
    HapticFeedback.lightImpact();
    setState(() {
      _backgroundIndex = (_backgroundIndex + 1) % _backgrounds.length;
      _selectedFont = _fonts[DateTime.now().millisecond % _fonts.length];

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
                      backgroundColor: AppColors.primary,
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Stack(
                  children: [
                    // The Card
                    Hero(
                      tag: 'quote_card_preview',
                      child: RepaintBoundary(
                        key: _globalKey,
                        child: AspectRatio(
                          aspectRatio: 4 / 5,
                          child: Container(
                            decoration: _backgrounds[_backgroundIndex].copyWith(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Content
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Quote
                                        Text(
                                          widget.quote.content,
                                          textAlign: TextAlign.center,
                                          style: _getFontStyle(_selectedFont).copyWith(
                                            fontSize: _textSize,
                                            fontWeight: FontWeight.bold,
                                            color: _textColor,
                                            height: 1.4,
                                          ),
                                        ),
                                        const SizedBox(height: 32),
                                        // Separator
                                        Container(
                                          height: 2,
                                          width: 40,
                                          color: _textColor.withOpacity(0.3),
                                        ),
                                        const SizedBox(height: 20),
                                        // Author
                                        Text(
                                          widget.quote.author.toUpperCase(),
                                          style: _getFontStyle(_selectedFont).copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: _textColor.withOpacity(0.8),
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Branding
                                Positioned(
                                  bottom: 24,
                                  right: 0,
                                  left: 0,
                                  child: Center(
                                    child: Text(
                                      'QuoteVault',
                                      style: GoogleFonts.inter(
                                        color: _textColor.withOpacity(0.4),
                                        fontSize: 12,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Shuffle Button (Bottom Right of canvas area)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: FloatingActionButton.extended(
                        onPressed: _shuffle,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        elevation: 4,
                        icon: const Icon(Icons.shuffle),
                        label: const Text('Shuffle', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Bottom Controls
          SafeArea(
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
                      Text('${_textSize.toInt()}px',
                          style: TextStyle(
                              color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
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
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: AppColors.textSecondary(context).withOpacity(0.2),
                            thumbColor: Colors.white,
                            overlayColor: AppColors.primary.withOpacity(0.1),
                            thumbShape:
                                const RoundSliderThumbShape(enabledThumbRadius: 10, elevation: 2),
                          ),
                          child: Slider(
                            value: _textSize,
                            min: 16,
                            max: 48,
                            onChanged: (v) => setState(() => _textSize = v),
                          ),
                        ),
                      ),
                      Text('A',
                          style: TextStyle(
                              color: AppColors.text(context),
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
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
                      itemCount: _fonts.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (ctx, index) {
                        final font = _fonts[index];
                        final isSelected = _selectedFont == font;

                        return GestureDetector(
                          onTap: () => setState(() => _selectedFont = font),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 80,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.05)
                                  : AppColors.background(context),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textSecondary(context).withOpacity(0.2),
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Aa',
                                    style: _getFontStyle(font).copyWith(
                                      fontSize: 24,
                                      color: AppColors.text(context),
                                    )),
                                const SizedBox(height: 4),
                                Text(
                                  font.split(' ')[0], // First word only for space
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textSecondary(context),
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
          ),
        ],
      ),
    );
  }

  TextStyle _labelStyle(BuildContext context) {
    return AppTextStyles.sectionLabel.copyWith(
      color: AppColors.textSecondary(context),
    );
  }
}
