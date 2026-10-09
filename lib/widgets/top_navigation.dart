// lib/widgets/top_navigation.dart

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'profile_avatar.dart';


class TopNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  const TopNavigationBar({
    super.key,
    required this.onSearchTap,
    required this.onProfileTap,
    this.avatarUrl,
  });

  final VoidCallback onSearchTap;
  final VoidCallback onProfileTap;
  final String? avatarUrl;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      titleSpacing: 12,
      title: GestureDetector(
        onTap: onSearchTap,
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 18, color: AppColors.onSurface),
              const SizedBox(width: 8),
              Text('Search', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: onProfileTap,
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ProfileAvatar(imageUrl: avatarUrl ?? '', radius: 16),
          ),
        ),
      ],
    );
  }
}