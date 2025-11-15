class ComicModel {
  final String title;
  final String? publisher;
  final int? year;
  final String? imageUrl;

  ComicModel({
    required this.title,
    this.publisher,
    this.year,
    this.imageUrl,
  });

  factory ComicModel.fromJson(Map<String, dynamic> json) {
    return ComicModel(
      title: json['title'] ?? 'Unknown Title',
      publisher: json['publisher'],
      year: json['year'],
      imageUrl: json['imageUrl'] ?? json['image'] ?? '',  // handles both cases
    );
  }
}
