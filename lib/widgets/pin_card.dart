// lib/widgets/pin_card.dart — one worked example, the rest follow the same shape
import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

class PinCard extends StatelessWidget {
  const PinCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.creatorName,
    required this.isSaved,
    required this.onTap,
    required this.onSaveTap,
  });

  final String imageUrl;
  final String title;
  final String creatorName;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onSaveTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16), // matches Pinterest's 12–20px card radius
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Image.network(imageUrl, fit: BoxFit.cover),
                Positioned(
                  top: AppSpacing.xs,
                  right: AppSpacing.xs,
                  child: IconButton(
                    icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                    onPressed: onSaveTap,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.bodyMedium),
                  Text(creatorName, style: textTheme.labelSmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}