import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../models/analysis_result.dart';
import '../providers/analysis_provider.dart';
import '../widgets/food_item_card.dart';
import '../widgets/macro_pie_chart.dart';
import '../widgets/nutrition_table.dart';

class ResultsScreen extends StatelessWidget {
  final AnalysisResult? resultOverride;

  const ResultsScreen({super.key, this.resultOverride});

  @override
  Widget build(BuildContext context) {
    final result =
        resultOverride ?? context.watch<AnalysisProvider>().result;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resultats')),
        body: const Center(child: Text('Aucun resultat disponible')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Resultats')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: result.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, __, ___) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, size: 48),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (!result.isFood) ...[
              Card(
                color: AppTheme.errorColor.withOpacity(0.1),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: AppTheme.errorColor),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Aucun aliment detecte dans cette image.',
                          style: TextStyle(color: AppTheme.errorColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Text(
                'Aliments detectes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              ...result.foods.map((food) => FoodItemCard(food: food)),
              const SizedBox(height: 16),
              NutritionTable(nutrition: result.totalNutrition),
              const SizedBox(height: 16),
              MacroPieChart(nutrition: result.totalNutrition),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                ),
                icon: const Icon(Icons.home),
                label: const Text('Retour a l\'accueil'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
