class StoryModel {
  final int id;
  final String title;
  final String author;
  final String? genre;
  final String? description;
  final String? imageUrl; // <-- ADD THIS

  StoryModel({
    required this.id,
    required this.title,
    required this.author,
    this.genre,
    this.description,
    this.imageUrl, // <-- ADD THIS
  });

  /// Create object from JSON
  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled',
      author: json['author'] ?? 'Unknown',
      genre: json['genre'],
      description: json['description'],
      imageUrl: json['imageUrl'] ?? json['image'] ?? json['thumbnail'] ?? '', 
      // handles multiple formats safely
    );
  }

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'genre': genre,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  /// Allows modification of only certain fields
  StoryModel copyWith({
    int? id,
    String? title,
    String? author,
    String? genre,
    String? description,
    String? imageUrl,
  }) {
    return StoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return 'StoryModel(id: $id, title: $title, author: $author, genre: $genre, description: $description, imageUrl: $imageUrl)';
  }
}
