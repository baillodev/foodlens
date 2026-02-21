import 'package:flutter/material.dart';

import '../config/theme.dart';
import '../models/nutrition.dart';

class NutritionTable extends StatelessWidget {
  final Nutrition nutrition;

  const NutritionTable({super.key, required this.nutrition});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Valeurs nutritionnelles',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _NutritionRow(
              label: 'Calories',
              value: '${nutrition.calories.toStringAsFixed(0)} kcal',
              color: AppTheme.caloriesColor,
            ),
            const Divider(height: 1),
            _NutritionRow(
              label: 'Proteines',
              value: '${nutrition.protein.toStringAsFixed(1)} g',
              color: AppTheme.proteinColor,
            ),
            const Divider(height: 1),
            _NutritionRow(
              label: 'Glucides',
              value: '${nutrition.totalCarbs.toStringAsFixed(1)} g',
              color: AppTheme.carbsColor,
            ),
            const Divider(height: 1),
            _NutritionRow(
              label: 'Lipides',
              value: '${nutrition.totalFat.toStringAsFixed(1)} g',
              color: AppTheme.fatColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _NutritionRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 15),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
