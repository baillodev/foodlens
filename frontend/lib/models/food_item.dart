import 'nutrition.dart';

class FoodItem {
  final String name;
  final String group;
  final double confidenceScore;
  final Nutrition nutrition;
  final double? servingWeight;
  final String? servingUnit;

  FoodItem({
    required this.name,
    required this.group,
    required this.confidenceScore,
    required this.nutrition,
    this.servingWeight,
    this.servingUnit,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'] as String,
      group: json['group'] as String,
      confidenceScore: (json['confidence_score'] as num).toDouble(),
      nutrition: Nutrition.fromJson(json['nutrition'] as Map<String, dynamic>),
      servingWeight: (json['serving_weight'] as num?)?.toDouble(),
      servingUnit: json['serving_unit'] as String?,
    );
  }
}
