import 'package:flutter/material.dart';

import '../models/food_item.dart';
import 'confidence_indicator.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem food;

  const FoodItemCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.restaurant,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${food.nutrition.calories.toStringAsFixed(0)} kcal',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  if (food.servingUnit != null)
                    Text(
                      food.servingUnit!,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            ConfidenceIndicator(score: food.confidenceScore),
          ],
        ),
      ),
    );
  }
}
