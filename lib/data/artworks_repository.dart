// lib/data/artworks_repository.dart
import '../constants/artist.dart';
import '../main.dart' show supabase;
import '../models/pin.dart';


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