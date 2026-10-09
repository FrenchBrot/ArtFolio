// lib/widgets/empty_state.dart
import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import 'primary_button.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    required this.icon,
    this.actionLabel,
    this.onActionTap,
  });

  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 40,
              color: AppColors.onSurface.withOpacity(0.4),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(label: actionLabel!, onPressed: onActionTap),
            ],
          ],
        ),
      ),
    );
  }
}