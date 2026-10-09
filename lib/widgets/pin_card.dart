// lib/widgets/pin_card.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';


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
        borderRadius: BorderRadius.circular(16), 
        child: Container(
          color: AppColors.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [

                  Hero(
                    tag: imageUrl,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: double.infinity,
                        height: 140,
                        color: AppColors.background,
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: double.infinity,
                        height: 140,
                        color: AppColors.background,
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.xs,
                    right: AppSpacing.xs,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: onSaveTap,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            size: 16,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(creatorName, style: textTheme.labelSmall),
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