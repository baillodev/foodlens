class HistoryEntry {
  final int id;
  final String imageUrl;
  final String foodSummary;
  final double totalCalories;
  final DateTime analyzedAt;

  HistoryEntry({
    required this.id,
    required this.imageUrl,
    required this.foodSummary,
    required this.totalCalories,
    required this.analyzedAt,
  });

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      id: json['id'] as int,
      imageUrl: json['image_url'] as String,
      foodSummary: json['food_summary'] as String,
      totalCalories: (json['total_calories'] as num).toDouble(),
      analyzedAt: DateTime.parse(json['analyzed_at'] as String),
    );
  }
}
