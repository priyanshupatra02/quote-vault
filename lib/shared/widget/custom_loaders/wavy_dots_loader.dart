import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quote_vault/core/theme/app_colors.dart';

class WavyDotsLoader extends StatelessWidget {
  final Color? loaderColor;
  const WavyDotsLoader({super.key, this.loaderColor});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.waveDots(
      color: loaderColor ?? AppColors.goldMuted,
      size: 10,
    );
  }
}
