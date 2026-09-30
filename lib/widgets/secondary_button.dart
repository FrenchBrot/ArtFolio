// lib/widgets/secondary_button.dart
import 'package:flutter/material.dart';

/// Outlined action button. Styling comes from [OutlinedButtonThemeData]
/// in lib/theme/app_theme.dart.
///
/// Params (design system v2): label, onPressed.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}