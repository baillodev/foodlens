import 'package:flutter_test/flutter_test.dart';

import 'package:foodlens/models/nutrition.dart';
import 'package:foodlens/models/food_item.dart';
import 'package:foodlens/models/analysis_result.dart';
import 'package:foodlens/models/history_entry.dart';

void main() {
  group('Nutrition', () {
    test('fromJson parses correctly', () {
      final json = {
        'calories': 389.0,
        'protein': 16.0,
        'total_carbs': 33.0,
        'total_fat': 20.0,
      };
      final n = Nutrition.fromJson(json);
      expect(n.calories, 389.0);
      expect(n.protein, 16.0);
      expect(n.totalCarbs, 33.0);
      expect(n.totalFat, 20.0);
    });

    test('fromJson handles int values', () {
      final json = {
        'calories': 300,
        'protein': 10,
        'total_carbs': 40,
        'total_fat': 15,
      };
      final n = Nutrition.fromJson(json);
      expect(n.calories, 300.0);
      expect(n.protein, 10.0);
    });
  });

  group('FoodItem', () {
    test('fromJson parses correctly', () {
      final json = {
        'name': 'pizza',
        'group': 'pizza',
        'confidence_score': 85.0,
        'nutrition': {
          'calories': 300.0,
          'protein': 12.0,
          'total_carbs': 35.0,
          'total_fat': 14.0,
        },
        'serving_weight': null,
        'serving_unit': null,
      };
      final food = FoodItem.fromJson(json);
      expect(food.name, 'pizza');
      expect(food.group, 'pizza');
      expect(food.confidenceScore, 85.0);
      expect(food.nutrition.calories, 300.0);
      expect(food.servingWeight, isNull);
      expect(food.servingUnit, isNull);
    });

    test('fromJson with serving data', () {
      final json = {
        'name': 'rice',
        'group': 'grain',
        'confidence_score': 90.0,
        'nutrition': {
          'calories': 200.0,
          'protein': 4.0,
          'total_carbs': 45.0,
          'total_fat': 1.0,
        },
        'serving_weight': 150.0,
        'serving_unit': 'g',
      };
      final food = FoodItem.fromJson(json);
      expect(food.servingWeight, 150.0);
      expect(food.servingUnit, 'g');
    });
  });

  group('AnalysisResult', () {
    test('fromJson parses full response', () {
      final json = {
        'id': 1,
        'is_food': true,
        'image_url': 'https://example.com/img.jpg',
        'foods': [
          {
            'name': 'burger',
            'group': 'burger',
            'confidence_score': 92.0,
            'nutrition': {
              'calories': 540.0,
              'protein': 25.0,
              'total_carbs': 45.0,
              'total_fat': 28.0,
            },
            'serving_weight': null,
            'serving_unit': null,
          }
        ],
        'total_nutrition': {
          'calories': 540.0,
          'protein': 25.0,
          'total_carbs': 45.0,
          'total_fat': 28.0,
        },
        'analyzed_at': '2026-01-15T10:30:00',
      };
      final result = AnalysisResult.fromJson(json);
      expect(result.id, 1);
      expect(result.isFood, true);
      expect(result.foods.length, 1);
      expect(result.foods[0].name, 'burger');
      expect(result.totalNutrition.calories, 540.0);
    });

    test('fromJson with null id', () {
      final json = {
        'id': null,
        'is_food': false,
        'image_url': 'https://example.com/img.jpg',
        'foods': [],
        'total_nutrition': {
          'calories': 0.0,
          'protein': 0.0,
          'total_carbs': 0.0,
          'total_fat': 0.0,
        },
        'analyzed_at': '2026-01-15T10:30:00',
      };
      final result = AnalysisResult.fromJson(json);
      expect(result.id, isNull);
      expect(result.isFood, false);
      expect(result.foods, isEmpty);
    });
  });

  group('HistoryEntry', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 5,
        'image_url': 'https://example.com/img.jpg',
        'food_summary': 'pizza, salad',
        'total_calories': 650.0,
        'analyzed_at': '2026-02-10T14:00:00',
      };
      final entry = HistoryEntry.fromJson(json);
      expect(entry.id, 5);
      expect(entry.imageUrl, 'https://example.com/img.jpg');
      expect(entry.foodSummary, 'pizza, salad');
      expect(entry.totalCalories, 650.0);
    });
  });
}
