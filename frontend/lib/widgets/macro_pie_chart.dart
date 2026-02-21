import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../config/theme.dart';
import '../models/nutrition.dart';

class MacroPieChart extends StatelessWidget {
  final Nutrition nutrition;

  const MacroPieChart({super.key, required this.nutrition});

  @override
  Widget build(BuildContext context) {
    final total = nutrition.protein + nutrition.totalCarbs + nutrition.totalFat;
    if (total == 0) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Repartition des macros',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      value: nutrition.protein,
                      title:
                          '${(nutrition.protein / total * 100).toStringAsFixed(0)}%',
                      color: AppTheme.proteinColor,
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: nutrition.totalCarbs,
                      title:
                          '${(nutrition.totalCarbs / total * 100).toStringAsFixed(0)}%',
                      color: AppTheme.carbsColor,
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: nutrition.totalFat,
                      title:
                          '${(nutrition.totalFat / total * 100).toStringAsFixed(0)}%',
                      color: AppTheme.fatColor,
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Legend(color: AppTheme.proteinColor, label: 'Proteines'),
                _Legend(color: AppTheme.carbsColor, label: 'Glucides'),
                _Legend(color: AppTheme.fatColor, label: 'Lipides'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
