// lib/widgets/circular_icon_button.dart
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';


class CircularIconButton extends StatelessWidget {
  const CircularIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 40,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: AppColors.background,
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.primary),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Icon(
            icon,
            size: size * 0.5,
            color: AppColors.secondary,
          ),
        ),
      ),
    );
  }
}