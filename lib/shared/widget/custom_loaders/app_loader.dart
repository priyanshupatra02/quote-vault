import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';


class AppLoader extends StatelessWidget {
  final Color androidBgColor;
  final Color iosBgColor;
  final Color progressColor;
  final double size;
  const AppLoader({
    super.key,
    this.androidBgColor = AppColors.kGrey800,
    this.iosBgColor = AppColors.kGrey400,
    this.progressColor = AppColors.kGrey400,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: 1,
        backgroundColor: androidBgColor,
        color: progressColor,
      ),
    );
  }
}
