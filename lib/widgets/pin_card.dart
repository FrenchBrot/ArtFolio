// lib/widgets/pin_card.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

/// One tile in [PinMasonryGrid]: image, bookmark button, title, creator.
///
/// Params (design system v2): imageUrl, title, creatorName, isSaved,
/// onTap, onSaveTap.
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
        borderRadius: BorderRadius.circular(16), // matches the 12–20px card radius
        child: Container(
          color: AppColors.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  // Hero tag is the image URL itself (unique per artwork)
                  // rather than a new id param, so this stays compatible
                  // with PinCard's documented parameter list. Matches the
                  // Hero(tag: pin.imageUrl, ...) in ArtworkDetailScreen.
                  Hero(
                    tag: imageUrl,
                    // width: double.infinity so the tile fills its grid
                    // column instead of collapsing to the image's natural
                    // size while it loads.
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