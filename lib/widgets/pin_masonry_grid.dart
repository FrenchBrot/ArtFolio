// lib/widgets/pin_masonry_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/pin.dart';
import '../theme/app_spacing.dart';
import 'pin_card.dart';

/// Two-column masonry layout of [PinCard]s (Pinterest mobile style).
///
/// Takes data and callbacks only, no state:
///  - [pins]      what to show
///  - [onPinTap]  called with the tapped pin
///  - [onSaveTap] optional; called with the pin whose save button was tapped
///
/// Spacing follows the design system: 8px gutters between tiles
/// ([AppSpacing.sm]) and 16px screen-edge padding ([AppSpacing.md]).
///
/// Do not wrap the cards in fixed-height boxes. Each card sizes itself
/// from its image, and that is what produces the staggered look.
class PinMasonryGrid extends StatelessWidget {
  const PinMasonryGrid({
    super.key,
    required this.pins,
    required this.onPinTap,
    this.onSaveTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.controller,
    this.physics,
    this.shrinkWrap = false,
  });

  final List<Pin> pins;
  final ValueChanged<Pin> onPinTap;
  final ValueChanged<Pin>? onSaveTap;

  /// Defaults to 16px on every side. Override per screen if needed.
  final EdgeInsetsGeometry padding;

  /// Pass a controller if the parent needs the scroll position.
  final ScrollController? controller;

  /// Set to `NeverScrollableScrollPhysics()` together with
  /// `shrinkWrap: true` when the grid sits inside another scroll view.
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  static const int _columns = 2; // mobile only

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      crossAxisCount: _columns,
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      itemCount: pins.length,
      itemBuilder: (context, index) {
        final pin = pins[index];
        return PinCard(
          key: ValueKey(pin.id),
          imageUrl: pin.imageUrl,
          title: pin.title,
          creatorName: pin.creatorName,
          isSaved: pin.isSaved,
          onTap: () => onPinTap(pin),
          onSaveTap: () => onSaveTap?.call(pin),
        );
      },
    );
  }
}