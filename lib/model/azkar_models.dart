// azkar_models.dart
class AzkarResponse {
  final List<Azkar> data;

  AzkarResponse({required this.data});

  factory AzkarResponse.fromJson(Map<String, dynamic> json) {
    return AzkarResponse(
      data: (json['data'] as List).map((item) => Azkar.fromJson(item)).toList(),
    );
  }
}

class Azkar {
  final int id;
  final String title;
  final String content;
  final String category;

  Azkar({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
  });

  factory Azkar.fromJson(Map<String, dynamic> json) {
    return Azkar(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
    );
  }
}
