import 'food_item.dart';
import 'nutrition.dart';

class AnalysisResult {
  final int? id;
  final bool isFood;
  final String imageUrl;
  final List<FoodItem> foods;
  final Nutrition totalNutrition;
  final DateTime analyzedAt;

  AnalysisResult({
    this.id,
    required this.isFood,
    required this.imageUrl,
    required this.foods,
    required this.totalNutrition,
    required this.analyzedAt,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      id: json['id'] as int?,
      isFood: json['is_food'] as bool,
      imageUrl: json['image_url'] as String,
      foods: (json['foods'] as List<dynamic>)
          .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalNutrition:
          Nutrition.fromJson(json['total_nutrition'] as Map<String, dynamic>),
      analyzedAt: DateTime.parse(json['analyzed_at'] as String),
    );
  }
}
