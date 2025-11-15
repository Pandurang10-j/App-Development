class ArticleModel {
  final int id;
  final String title;
  final String? summary;
  final String? imageUrl;
  final String? publishedAt;

  ArticleModel({
    required this.id,
    required this.title,
    this.summary,
    this.imageUrl,
    this.publishedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled',
      summary: json['summary'],
      imageUrl: json['image_url'],
      publishedAt: json['published_at'],
    );
  }
}