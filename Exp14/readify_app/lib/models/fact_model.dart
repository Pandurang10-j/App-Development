class FactModel {
  final String text;
  final String? source;

  FactModel({
    required this.text,
    this.source,
  });

  factory FactModel.fromJson(Map<String, dynamic> json) {
    return FactModel(
      text: json['text'] ?? '',
      source: json['source'],
    );
  }
}