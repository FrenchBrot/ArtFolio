// lib/screens/artwork_detail.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/pin.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../widgets/tag_chip.dart';

/// Artwork Detail: full-size image, title, description, and category.
///
/// Takes the [Pin] already fetched by whichever grid pushed this screen
/// (fetchArtworks now selects description and the related category name
/// alongside everything else), so opening a piece needs no extra
/// Supabase round trip — and no loading state, for the same reason.
class ArtworkDetailScreen extends StatelessWidget {
  const ArtworkDetailScreen({super.key, required this.pin});

  final Pin pin;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Same tag as the Hero wrapping the thumbnail in PinCard
            // (the image URL itself), so this animates in from wherever
            // it was tapped instead of just appearing.
            Hero(
              tag: pin.imageUrl,
              child: CachedNetworkImage(
                imageUrl: pin.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 320,
                  color: AppColors.background,
                ),
                errorWidget: (context, url, error) => Container(
                  height: 320,
                  color: AppColors.background,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    size: 48,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pin.title, style: textTheme.headlineSmall),
                  if (pin.categoryName != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    TagChip(
                      label: pin.categoryName!,
                      selected: true,
                      onTap: () {}, // informational here, not a filter
                    ),
                  ],
                  if (pin.description != null &&
                      pin.description!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(pin.description!, style: textTheme.bodyMedium),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}