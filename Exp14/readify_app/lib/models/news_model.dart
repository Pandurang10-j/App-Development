class NewsModel {
  final String title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? source;
  final DateTime? publishedAt;

  NewsModel({
    required this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.source,
    this.publishedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? 'No Title',
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      source: json['source'] is Map ? json['source']['name'] : json['source'],
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'])
          : null,
    );
  }
}
