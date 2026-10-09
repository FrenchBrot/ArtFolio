// lib/widgets/board_card.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';


class BoardCard extends StatelessWidget {
  const BoardCard({
    super.key,
    required this.coverImageUrl,
    required this.title,
    required this.pinCount,
    required this.onTap,
  });

  final String coverImageUrl;
  final String title;
  final int pinCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: AppColors.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: CachedNetworkImage(
                  imageUrl: coverImageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: AppColors.background),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.background,
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text('$pinCount pins', style: textTheme.labelSmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}