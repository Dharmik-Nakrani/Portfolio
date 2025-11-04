import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BackToTopButton extends StatelessWidget {
  final VoidCallback onTap;
  const BackToTopButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      backgroundColor: AppColors.themeColor,
      onPressed: onTap,
      child: const Icon(Icons.arrow_upward, color: Colors.white),
    );
  }
}
