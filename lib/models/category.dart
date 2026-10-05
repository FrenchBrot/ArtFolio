// lib/models/category.dart

/// One row of the `categories` table — the tags artworks are grouped
/// under, shown as [TagChip]s on Home and Search.
class Category {
  const Category({required this.id, required this.name});

  final String id;
  final String name;

  @override
  bool operator ==(Object other) => other is Category && other.id == id;

  @override
  int get hashCode => id.hashCode;
}