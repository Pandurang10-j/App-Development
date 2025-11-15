class JokeModel {
  final int id;
  final String type;
  final String? setup;
  final String? delivery;
  final String? joke;

  JokeModel({
    required this.id,
    required this.type,
    this.setup,
    this.delivery,
    this.joke,
  });

  factory JokeModel.fromJson(Map<String, dynamic> json) {
    return JokeModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? 'single',
      setup: json['setup'],
      delivery: json['delivery'],
      joke: json['joke'],
    );
  }

  String get fullJoke {
    if (type == 'twopart') {
      return '$setup\n\n$delivery';
    }
    return joke ?? '';
  }
}