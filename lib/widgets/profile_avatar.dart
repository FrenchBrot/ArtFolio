// lib/widgets/profile_avatar.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Circular profile photo, used for the artist and (if added later) any
/// other user photo.
///
/// Params (design system v2): imageUrl, radius.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 20,
  });

  final String imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final diameter = radius * 2;
    return ClipOval(
      child: imageUrl.isEmpty
          ? _fallback(diameter)
          : CachedNetworkImage(
              imageUrl: imageUrl,
              width: diameter,
              height: diameter,
              fit: BoxFit.cover,
              placeholder: (context, url) => _fallback(diameter),
              errorWidget: (context, url, error) => _fallback(diameter),
            ),
    );
  }

  Widget _fallback(double diameter) {
    return Container(
      width: diameter,
      height: diameter,
      color: AppColors.background,
      child: Icon(
        Icons.person,
        size: diameter * 0.6,
        color: AppColors.onSurface,
      ),
    );
  }
}