// lib/models/pin.dart

/// One item shown in the grid, and the artwork shown on
/// ArtworkDetailScreen once tapped. Rename to `Artwork` later if you
/// prefer; just keep the field names in sync with PinCard and
/// ArtworkDetailScreen.
class Pin {
  const Pin({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.creatorName,
    this.description,
    this.categoryName,
    this.isSaved = false,
  });

  final String id;
  final String imageUrl;
  final String title;
  final String creatorName;

  /// The artworks.description column — nullable since the table allows
  /// it to be blank.
  final String? description;

  /// The name of the related categories row (joined via tag_id), null
  /// if the artwork has no category set.
  final String? categoryName;

  final bool isSaved;

  Pin copyWith({
    String? id,
    String? imageUrl,
    String? title,
    String? creatorName,
    String? description,
    String? categoryName,
    bool? isSaved,
  }) {
    return Pin(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      creatorName: creatorName ?? this.creatorName,
      description: description ?? this.description,
      categoryName: categoryName ?? this.categoryName,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  bool operator ==(Object other) => other is Pin && other.id == id;

  @override
  int get hashCode => id.hashCode;
}