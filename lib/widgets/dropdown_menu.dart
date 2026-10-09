// lib/widgets/dropdown_menu.dart

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';


class AppDropdownMenu extends StatelessWidget {
  const AppDropdownMenu({
    super.key,
    required this.options,
    required this.onSelected,
  });

  final List<String> options;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, color: AppColors.onSurface),
      color: AppColors.surface,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final option in options)
          PopupMenuItem<String>(
            value: option,
            child: Text(
              option,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
      ],
    );
  }
}