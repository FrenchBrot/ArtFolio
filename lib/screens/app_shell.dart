// lib/screens/app_shell.dart
import 'package:flutter/material.dart';

import '../widgets/bottom_navigation_bar.dart';
import 'home.dart';
import 'profile.dart';
import 'search.dart';

/// Ties Home, Search, and Profile together behind [AppBottomNavBar].
///
/// AppBottomNavBar has five tabs — Home / Search / Create / Notifications
/// / Profile — because that's the full set in the design system v2 doc,
/// but ArtFolio only has screens for three of them. Create and
/// Notifications aren't really part of a single-admin portfolio (artwork
/// is added through the Supabase dashboard, not an in-app composer, and
/// there's no one else to notify you about). Tapping either shows a
/// short explanation instead of switching to a blank screen — remove
/// those two cases in [_onTap] if you build real screens for them later.
///
/// Each tab keeps a full Scaffold of its own (with its own AppBar), since
/// Home, Search, and Profile each need a different app bar. This
/// Scaffold only supplies the bottom nav bar and the IndexedStack that
/// swaps between them, so it has no AppBar of its own.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _homeIndex = 0;
  static const _searchIndex = 1;
  static const _createIndex = 2;
  static const _notificationsIndex = 3;
  static const _profileIndex = 4;

  int _currentIndex = _homeIndex;

  void _onTap(int index) {
    if (index == _createIndex || index == _notificationsIndex) {
      final label = index == _createIndex ? 'Create' : 'Notifications';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "$label isn't part of ArtFolio — add artwork through the "
            'Supabase dashboard instead.',
          ),
        ),
      );
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack mounts all five children up front and keeps them
      // alive offstage, so switching tabs preserves each screen's scroll
      // position and already-fetched data instead of rebuilding from
      // scratch every time.
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            onSearchTap: () => _onTap(_searchIndex),
            onProfileTap: () => _onTap(_profileIndex),
          ),
          const SearchScreen(),
          const SizedBox.shrink(), // Create — never actually shown
          const SizedBox.shrink(), // Notifications — never actually shown
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}