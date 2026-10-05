// lib/main.dart
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/app_shell.dart';
import 'theme/app_theme.dart';

/// Convenience accessor so other files can do
/// `import 'package:artfolio/main.dart' show supabase;`
/// instead of calling `Supabase.instance.client` everywhere.
late final SupabaseClient supabase;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabasePublishableKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'];

  if (supabaseUrl == null || supabaseUrl.isEmpty ||
      supabasePublishableKey == null || supabasePublishableKey.isEmpty) {
    throw StateError(
      'Missing SUPABASE_URL / SUPABASE_PUBLISHABLE_KEY. Copy .env.example '
      'to .env and fill in your Supabase project\'s values, and make sure '
      '.env is listed under pubspec.yaml -> flutter -> assets.',
    );
  }

  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabasePublishableKey,
  );
  supabase = Supabase.instance.client;

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const ArtFolioApp(),
    ),
  );
}

class ArtFolioApp extends StatelessWidget {
  const ArtFolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArtFolio',
      debugShowCheckedModeBanner: false,
      theme: appTheme, // light only — see design system v2, Step A
      useInheritedMediaQuery: true, // required by device_preview
      locale: DevicePreview.locale(context), // required by device_preview
      builder: DevicePreview.appBuilder, // required by device_preview
      home: const AppShell(),
    );
  }
}