// lib/screens/search.dart
import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';

import '../data/artworks_repository.dart';
import '../data/categories_repository.dart';
import '../models/category.dart';
import '../models/pin.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_skeleton.dart';
import '../widgets/pin_masonry_grid.dart';
import '../widgets/tag_chip.dart';
import 'artwork_detail.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  List<Category> _categories = const [];
  List<Pin> _pins = const [];
  String? _selectedCategoryId;
  bool _hasSearched = false;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await fetchCategories();
      if (!mounted) return;
      setState(() => _categories = categories);
    } catch (error) {
      debugPrint('SearchScreen categories load error: $error');
    }
  }

  void _onQueryChanged(String _) {
    setState(() {}); 
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _runSearch);
  }

  void _clearQuery() {
    _searchController.clear();
    _debounce?.cancel();
    _runSearch();
  }

  void _onSelectCategory(String? categoryId) {
    setState(() => _selectedCategoryId = categoryId);
    _runSearch();
  }

  Future<void> _runSearch() async {
    final query = _searchController.text.trim();
    final categoryId = _selectedCategoryId;

    if (query.isEmpty && categoryId == null) {
      setState(() {
        _pins = const [];
        _hasSearched = false;
        _loading = false;
        _error = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _hasSearched = true;
      _error = null;
    });

    try {
      final pins = await fetchArtworks(
        categoryId: categoryId,
        searchQuery: query,
      );
      if (!mounted) return;
      setState(() {
        _pins = pins;
        _loading = false;
      });
    } catch (error) {
      debugPrint('SearchScreen query error: $error');
      if (!mounted) return;
      setState(() {
        _error = 'Search failed. Check your connection and try again.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildSearchAppBar(context),
      body: Column(
        children: [
          _buildCategoryRow(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildSearchAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      titleSpacing: 12,
      title: Container(
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
            Expanded(
              child: TextField(
                controller: _searchController,
                autofocus: true,
                textInputAction: TextInputAction.search,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: const InputDecoration(
                  hintText: 'Search artwork',
                  border: InputBorder.none,
                  isDense: true,
                ),
                onChanged: _onQueryChanged,
                onSubmitted: (_) {
                  _debounce?.cancel();
                  _runSearch();
                },
              ),
            ),
            if (_searchController.text.isNotEmpty)
              GestureDetector(
                onTap: _clearQuery,
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: AppColors.onSurface,
                ),
              ),
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
    if (!_hasSearched) {
      return const EmptyState(
        message: 'Search by title, or filter by category above.',
        icon: Icons.search,
      );
    }

    if (_loading) return _buildLoadingGrid();

    if (_error != null) {
      return EmptyState(
        message: _error!,
        icon: Icons.wifi_off_outlined,
        actionLabel: 'Retry',
        onActionTap: _runSearch,
      );
    }

    if (_pins.isEmpty) {
      return const EmptyState(
        message: 'No matching artwork — try a different title or category.',
        icon: Icons.search_off,
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