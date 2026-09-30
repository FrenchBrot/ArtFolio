// lib/widgets/tag_chip.dart
import 'package:flutter/material.dart';

/// Selectable pill chip for tags/categories. Styling comes from
/// [ChipThemeData] in lib/theme/app_theme.dart.
///
/// Params (design system v2): label, selected, onTap.
class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}