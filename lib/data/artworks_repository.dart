// lib/data/artworks_repository.dart
import '../constants/artist.dart';
import '../main.dart' show supabase;
import '../models/pin.dart';

/// Fetches rows from `artworks`, optionally filtered by category and/or
/// a case-insensitive title search. Shared by Home, Search, and Profile
/// so all three query the table the same way instead of each rolling
/// its own.
///
/// `categories(name)` is Supabase's foreign-key embedding: since
/// artworks.tag_id references categories.id, PostgREST follows that
/// relationship and nests the matching category's name directly in each
/// row, so ArtworkDetailScreen never needs a second query just to show
/// which category a piece belongs to.
Future<List<Pin>> fetchArtworks({
  String? categoryId,
  String? searchQuery,
}) async {
  final baseQuery = supabase
      .from('artworks')
      .select('id, title, description, image_url, categories(name)');

  final withCategory =
      categoryId == null ? baseQuery : baseQuery.eq('tag_id', categoryId);

  final trimmedQuery = searchQuery?.trim();
  final withSearch = (trimmedQuery == null || trimmedQuery.isEmpty)
      ? withCategory
      : withCategory.ilike('title', '%$trimmedQuery%');

  final rows = await withSearch.order('created_at', ascending: false);

  return [
    for (final row in rows)
      Pin(
        id: row['id'] as String,
        imageUrl: row['image_url'] as String,
        title: row['title'] as String,
        creatorName: artistDisplayName,
        description: row['description'] as String?,
        categoryName:
            (row['categories'] as Map<String, dynamic>?)?['name'] as String?,
      ),
  ];
}