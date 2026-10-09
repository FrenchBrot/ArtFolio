// lib/screens/app_shell.dart
import 'package:flutter/material.dart';

import '../widgets/bottom_navigation_bar.dart';
import 'home.dart';
import 'profile.dart';
import 'search.dart';


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
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            onSearchTap: () => _onTap(_searchIndex),
            onProfileTap: () => _onTap(_profileIndex),
          ),
          const SearchScreen(),
          const SizedBox.shrink(), 
          const SizedBox.shrink(), 
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