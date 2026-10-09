// lib/models/pin.dart

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


  final String? description;


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