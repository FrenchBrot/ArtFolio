// lib/widgets/loading_skeleton.dart
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Placeholder block shown while real content (an image, a line of text)
/// is still loading. Pulses gently so a screen full of these doesn't read
/// as frozen — the animation is a self-contained visual effect, not state
/// passed in from a parent, so it doesn't break the "data and callbacks
/// only" rule from the design system doc.
///
/// Params (design system v2): width, height, borderRadius.
class LoadingSkeleton extends StatefulWidget {
  const LoadingSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  final double width;
  final double height;
  final BorderRadius borderRadius;

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: widget.borderRadius,
        ),
      ),
    );
  }
}