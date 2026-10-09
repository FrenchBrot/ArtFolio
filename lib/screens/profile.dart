// lib/screens/profile.dart
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/artist.dart';
import '../data/artworks_repository.dart';
import '../main.dart' show supabase;
import '../models/pin.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../widgets/circular_icon_button.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_skeleton.dart';
import '../widgets/pin_masonry_grid.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/secondary_button.dart';
import '../widgets/section_header.dart';
import 'artwork_detail.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _bio = '';
  String _profileImageUrl = '';
  String? _instagram;
  String? _kofi;
  String? _cara;
  String? _email;

  List<Pin> _pins = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final profileRow =
          await supabase.from('artist_profile').select().maybeSingle();
      final contactLinks =
          (profileRow?['contact_links'] as Map<String, dynamic>?) ??
              const {};
      final pins = await fetchArtworks();

      if (!mounted) return;
      setState(() {
        _bio = (profileRow?['bio'] as String?) ?? '';
        _profileImageUrl = (profileRow?['profile_image_url'] as String?) ?? '';
        _instagram = contactLinks['instagram'] as String?;
        _kofi = contactLinks['kofi'] as String?;
        _cara = contactLinks['cara'] as String?;
        _email = contactLinks['email'] as String?;
        _pins = pins;
        _loading = false;
      });
    } catch (error) {
      debugPrint('ProfileScreen load error: $error');
      if (!mounted) return;
      setState(() {
        _error = 'Could not load your profile. Pull down to try again.';
        _loading = false;
      });
    }
  }

  Future<void> _openLink(String value, {bool isEmail = false}) async {
    final uri = isEmail ? Uri(scheme: 'mailto', path: value) : Uri.parse(value);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open $value')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: _loading
              ? [_buildLoadingHeader()]
              : _error != null
                  ? [
                      const SizedBox(height: AppSpacing.lg),
                      EmptyState(
                        message: _error!,
                        icon: Icons.wifi_off_outlined,
                        actionLabel: 'Retry',
                        onActionTap: _loadProfile,
                      ),
                    ]
                  : _buildLoadedContent(context),
        ),
      ),
    );
  }

  List<Widget> _buildLoadedContent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return [
      Center(child: ProfileAvatar(imageUrl: _profileImageUrl, radius: 48)),
      const SizedBox(height: AppSpacing.md),
      Center(child: Text(artistDisplayName, style: textTheme.headlineSmall)),
      if (_bio.isNotEmpty) ...[
        const SizedBox(height: AppSpacing.xs),
        Text(_bio, textAlign: TextAlign.center, style: textTheme.bodyMedium),
      ],
      const SizedBox(height: AppSpacing.md),
      Center(child: _buildContactRow()),
      const SizedBox(height: AppSpacing.md),
      Center(
        child: SecondaryButton(
          label: 'Edit Profile',
          onPressed: () {
            // TODO: wire to an Edit Profile screen once it exists.
          },
        ),
      ),
      const SizedBox(height: AppSpacing.lg),
      const SectionHeader(title: 'Your work'),
      const SizedBox(height: AppSpacing.sm),
      if (_pins.isEmpty)
        const EmptyState(
          message: 'Nothing published yet — add a row to artworks in '
              'Supabase to see it here.',
          icon: Icons.image_outlined,
        )
      else
        PinMasonryGrid(
          pins: _pins,
          onPinTap: (pin) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ArtworkDetailScreen(pin: pin)),
            );
          },
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
    ];
  }

  Widget _buildContactRow() {
    final buttons = <Widget>[];

    void addButton(String? value, IconData icon, {bool isEmail = false}) {
      if (value == null || value.isEmpty) return;
      buttons.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: CircularIconButton(
            icon: icon,
            onPressed: () => _openLink(value, isEmail: isEmail),
          ),
        ),
      );
    }

    addButton(_instagram, Icons.camera_alt_outlined);
    addButton(_kofi, Icons.coffee_outlined);
    addButton(_cara, Icons.palette_outlined);
    addButton(_email, Icons.email_outlined, isEmail: true);

    if (buttons.isEmpty) return const SizedBox.shrink();
    return Row(mainAxisSize: MainAxisSize.min, children: buttons);
  }

  Widget _buildLoadingHeader() {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          LoadingSkeleton(
            width: 96,
            height: 96,
            borderRadius: BorderRadius.all(Radius.circular(48)),
          ),
          SizedBox(height: AppSpacing.md),
          LoadingSkeleton(
            width: 140,
            height: 16,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          SizedBox(height: AppSpacing.xs),
          LoadingSkeleton(
            width: 220,
            height: 12,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ],
      ),
    );
  }
}