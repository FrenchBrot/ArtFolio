// lib/data/categories_repository.dart
import '../main.dart' show supabase;
import '../models/category.dart';

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