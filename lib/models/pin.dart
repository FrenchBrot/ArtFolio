// lib/models/pin.dart

/// One item shown in the grid. Rename to `Artwork` later if you prefer;
/// just keep the field names in sync with PinCard.
class Pin {
  const Pin({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.creatorName,
    this.isSaved = false,
  });

  final String id;
  final String imageUrl;
  final String title;
  final String creatorName;
  final bool isSaved;

  Pin copyWith({
    String? id,
    String? imageUrl,
    String? title,
    String? creatorName,
    bool? isSaved,
  }) {
    return Pin(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      creatorName: creatorName ?? this.creatorName,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  bool operator ==(Object other) => other is Pin && other.id == id;

  @override
  int get hashCode => id.hashCode;
}