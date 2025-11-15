class MangaModel {
  final int id;
  final String title;
  final String? imageUrl;
  final String? synopsis;
  final double? score;

  MangaModel({
    required this.id,
    required this.title,
    this.imageUrl,
    this.synopsis,
    this.score,
  });

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    return MangaModel(
      id: json['mal_id'] ?? 0,
      title: json['title'] ?? 'Untitled',
      imageUrl: json['images']?['jpg']?['image_url'],
      synopsis: json['synopsis'],
      score: json['score']?.toDouble(),
    );
  }
}