class BookModel {
  final String title;
  final String? author;
  final String? genre;
  final String? publisher;
  final int? year;
  final int? pages;
  final String? imageUrl; // <-- ADDED

  BookModel({
    required this.title,
    this.author,
    this.genre,
    this.publisher,
    this.year,
    this.pages,
    this.imageUrl, // <-- ADDED
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      title: json['title'] ?? 'Untitled',
      author: json['author'],
      genre: json['genre'],
      publisher: json['publisher'],
      year: json['year'],
      pages: json['pages'],

      // supports multiple formats
      imageUrl: json['imageUrl'] ??
          json['image'] ??
          json['cover'] ??
          json['thumbnail'] ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'genre': genre,
      'publisher': publisher,
      'year': year,
      'pages': pages,
      'imageUrl': imageUrl,
    };
  }
}
