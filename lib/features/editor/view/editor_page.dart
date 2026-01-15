import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/editor/view/widgets/editor_canvas.dart';
import 'package:quote_vault/features/editor/view/widgets/editor_toolbar.dart';
import 'package:quote_vault/features/editor/view/widgets/font_size_slider.dart';
import 'package:quote_vault/features/editor/view/widgets/typeface_selector.dart';

@RoutePage()
class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  // State
  double _fontSize = 42;
  TextStyle _currentFont = GoogleFonts.playfairDisplay();

  // Mock Content
  final String _quoteText = "The only way to do great work is to love what you do.";
  final String _author = "Steve Jobs";
  final String _imageUrl =
      "https://lh3.googleusercontent.com/aida-public/AB6AXuAbZf29aMeiHoDiaG3rG6QO4-I_NUJpdB-rZPiqbDOx4mx8rOfHK-dQXIHog4wmiDM9TKo_q54-nCPwbVWLKjIqBhsoTahtp6abqhvPwTfqM0J5wxI1UKn1XVBeYMQbMKASb9Q-nak5lYCG1q-UpqGlX_DZ3SmgFTpbhtVnawmtlysjzceGrunSAGkbbxfvFc0zkAlCXPg5lOcy4MA_aEOo7cfLrkJIuYqurfB6EFi-69gj5R_T_86F6LvcEt3bLvxo_xf0fUxEl8Q";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => context.router.pop(),
                    icon: Icon(Icons.close,
                        color: AppColors.text(context).withOpacity(0.7), size: 28),
                  ),
                  Text(
                    'Edit Quote',
                    style: AppTextStyles.display.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context),
                      letterSpacing: 0.5,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: AppColors.primary.withOpacity(0.4),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    ),
                    child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // Main Canvas Area
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Stack(
                    children: [
                      EditorCanvas(
                        quoteText: _quoteText,
                        author: _author,
                        backgroundUrl: _imageUrl,
                        textStyle: _currentFont,
                        fontSize: _fontSize,
                      ),

                      // Floating Shuffle Button
                      Positioned(
                        bottom: 24,
                        right: 24,
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            // Mock shuffle
                          },
                          backgroundColor: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF1F1C26).withOpacity(0.8)
                              : Colors.white.withOpacity(0.9),
                          elevation: 8,
                          label: Text('Shuffle',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, color: AppColors.text(context))),
                          icon: Icon(Icons.shuffle, size: 20, color: AppColors.text(context)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Controls Panel
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface(context),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                border: Border(
                    top: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white12
                            : Colors.black12)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Resizer Handle
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 4),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        FontSizeSlider(
                          value: _fontSize,
                          onChanged: (val) => setState(() => _fontSize = val),
                        ),
                        const SizedBox(height: 20),
                        TypefaceSelector(
                          selectedFont: _currentFont,
                          onFontSelected: (font) => setState(() => _currentFont = font),
                        ),
                      ],
                    ),
                  ),

                  const EditorToolbar(),
                  const SizedBox(height: 12), // iOS Home Indicator Spacing
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
