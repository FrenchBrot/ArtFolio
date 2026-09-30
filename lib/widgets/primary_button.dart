// lib/widgets/primary_button.dart
import 'package:flutter/material.dart';

/// Filled action button. Styling comes from [FilledButtonThemeData] in
/// lib/theme/app_theme.dart — no colors are set here.
///
/// Params (design system v2): label, onPressed, icon.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      );
    }
    return FilledButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}