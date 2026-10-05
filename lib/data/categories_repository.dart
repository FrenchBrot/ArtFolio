// lib/data/categories_repository.dart
import '../main.dart' show supabase;
import '../models/category.dart';

/// Fetches every row of `categories`, ordered by name. Shared by Home's
/// and Search's filter-chip rows so both query it the same way.
Future<List<Category>> fetchCategories() async {
  final rows = await supabase
      .from('categories')
      .select('id, name')
      .order('name');

  return [
    for (final row in rows)
      Category(id: row['id'] as String, name: row['name'] as String),
  ];
}