// lib/widgets/pin_masonry_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/pin.dart';
import '../theme/app_spacing.dart';
import 'pin_card.dart';


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

 
  final EdgeInsetsGeometry padding;

 
  final ScrollController? controller;


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