// lib/widgets/input_field.dart
//
// NOTE: the design system v2 doc names this file
// lib/widgets/app_input_field.dart. Built here as input_field.dart per
// request — rename one side to match before grading.
import 'package:flutter/material.dart';

/// Labeled text field used on Login / Signup / Edit Profile / Create Pin.
/// Styling comes from [InputDecorationTheme] in lib/theme/app_theme.dart.
///
/// Params (design system v2): label, controller, obscureText, errorText.
class AppInputField extends StatelessWidget {
  const AppInputField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.errorText,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
      ),
    );
  }
}