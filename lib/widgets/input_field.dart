// lib/widgets/input_field.dart

import 'package:flutter/material.dart';


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