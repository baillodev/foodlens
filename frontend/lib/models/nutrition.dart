class Nutrition {
  final double calories;
  final double protein;
  final double totalCarbs;
  final double totalFat;

  Nutrition({
    required this.calories,
    required this.protein,
    required this.totalCarbs,
    required this.totalFat,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      totalCarbs: (json['total_carbs'] as num).toDouble(),
      totalFat: (json['total_fat'] as num).toDouble(),
    );
  }
}
