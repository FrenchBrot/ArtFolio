// lib/screens/home.dart
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';

import '../data/artworks_repository.dart';
import '../data/categories_repository.dart';
import '../models/category.dart';
import '../models/pin.dart';
import '../theme/app_spacing.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_skeleton.dart';
import '../widgets/pin_masonry_grid.dart';
import '../widgets/tag_chip.dart';
import '../widgets/top_navigation.dart';
import 'artwork_detail.dart';
import 'profile.dart';
import 'search.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onSearchTap, this.onProfileTap});


  final VoidCallback? onSearchTap;


  final VoidCallback? onProfileTap;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> _categories = const [];
  List<Pin> _pins = const [];
  String? _selectedCategoryId; // null = "All"
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEverything();
  }

  Future<void> _loadEverything() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      _categories = await fetchCategories();
      await _loadArtworks();
    } catch (error) {
      debugPrint('HomeScreen categories load error: $error');
      if (!mounted) return;
      setState(() {
        _error = 'Could not load your artwork. Pull down to try again.';
        _loading = false;
      });
    }
  }

  Future<void> _loadArtworks() async {
    try {
      final pins = await fetchArtworks(categoryId: _selectedCategoryId);
      if (!mounted) return;
      setState(() {
        _pins = pins;
        _loading = false;
      });
    } catch (error) {
      debugPrint('HomeScreen artworks load error: $error');
      if (!mounted) return;
      setState(() {
        _error = 'Could not load your artwork. Pull down to try again.';
        _loading = false;
      });
    }
  }

  void _onSelectCategory(String? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      _loading = true;
    });
    _loadArtworks();
  }

  void _defaultOnSearchTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
  }

  void _defaultOnProfileTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        onSearchTap: widget.onSearchTap ?? _defaultOnSearchTap,
        onProfileTap: widget.onProfileTap ?? _defaultOnProfileTap,
      ),
      body: RefreshIndicator(
        onRefresh: _loadEverything,
        child: Column(
          children: [
            _buildCategoryRow(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow() {
    if (_categories.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: TagChip(
              label: 'All',
              selected: _selectedCategoryId == null,
              onTap: () => _onSelectCategory(null),
            ),
          ),
          for (final category in _categories)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: TagChip(
                label: category.name,
                selected: _selectedCategoryId == category.id,
                onTap: () => _onSelectCategory(category.id),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return _buildLoadingGrid();

    if (_error != null) {
      return EmptyState(
        message: _error!,
        icon: Icons.wifi_off_outlined,
        actionLabel: 'Retry',
        onActionTap: _loadEverything,
      );
    }

    if (_pins.isEmpty) {
      return const EmptyState(
        message: 'No artwork here yet — add your first piece in Supabase '
            'to see it show up on this page.',
        icon: Icons.image_outlined,
      );
    }

    return PinMasonryGrid(
      pins: _pins,
      onPinTap: (pin) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ArtworkDetailScreen(pin: pin)),
        );
      },
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.count(
      padding: const EdgeInsets.all(AppSpacing.md),
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: 0.75,
      children: const [
        LoadingSkeleton(width: double.infinity, height: double.infinity),
        LoadingSkeleton(width: double.infinity, height: double.infinity),
        LoadingSkeleton(width: double.infinity, height: double.infinity),
        LoadingSkeleton(width: double.infinity, height: double.infinity),
      ],
    );
  }
}