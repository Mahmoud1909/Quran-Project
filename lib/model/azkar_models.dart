class Azkar {
  final String category;
  final String count;
  final String description;
  final String reference;
  final String content;

  Azkar({
    required this.category,
    required this.count,
    required this.description,
    required this.reference,
    required this.content,
  });

  factory Azkar.fromJson(Map<String, dynamic> json) {
    return Azkar(
      category: json['category'] as String,
      count: json['count'] as String,
      description: json['description'] as String,
      reference: json['reference'] as String,
      content: json['content'] as String,
    );
  }
}
