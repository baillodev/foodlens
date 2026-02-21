import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:foodlens/config/theme.dart';
import 'package:foodlens/models/food_item.dart';
import 'package:foodlens/models/nutrition.dart';
import 'package:foodlens/providers/analysis_provider.dart';
import 'package:foodlens/providers/history_provider.dart';
import 'package:foodlens/screens/home_screen.dart';
import 'package:foodlens/widgets/confidence_indicator.dart';
import 'package:foodlens/widgets/food_item_card.dart';
import 'package:foodlens/widgets/nutrition_table.dart';

Widget wrapWithProviders(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AnalysisProvider()),
      ChangeNotifierProvider(create: (_) => HistoryProvider()),
    ],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      home: child,
    ),
  );
}

void main() {
  group('HomeScreen', () {
    testWidgets('displays app title and buttons', (tester) async {
      await tester.pumpWidget(wrapWithProviders(const HomeScreen()));

      expect(find.text('FoodLens'), findsOneWidget);
      expect(find.text('Analyser un repas'), findsOneWidget);
      expect(find.text('Historique'), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);
    });

    testWidgets('displays restaurant icon', (tester) async {
      await tester.pumpWidget(wrapWithProviders(const HomeScreen()));

      expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
    });
  });

  group('ConfidenceIndicator', () {
    testWidgets('displays percentage text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ConfidenceIndicator(score: 85))),
      );

      expect(find.text('85%'), findsOneWidget);
    });

    testWidgets('shows green for high score', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ConfidenceIndicator(score: 90))),
      );

      final text = tester.widget<Text>(find.text('90%'));
      expect(text.style?.color, Colors.green);
    });

    testWidgets('shows orange for medium score', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ConfidenceIndicator(score: 60))),
      );

      final text = tester.widget<Text>(find.text('60%'));
      expect(text.style?.color, Colors.orange);
    });

    testWidgets('shows red for low score', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ConfidenceIndicator(score: 30))),
      );

      final text = tester.widget<Text>(find.text('30%'));
      expect(text.style?.color, Colors.red);
    });
  });

  group('FoodItemCard', () {
    testWidgets('displays food name and calories', (tester) async {
      final food = FoodItem(
        name: 'Pizza',
        group: 'pizza',
        confidenceScore: 85.0,
        nutrition: Nutrition(
          calories: 389,
          protein: 16,
          totalCarbs: 33,
          totalFat: 20,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: FoodItemCard(food: food))),
      );

      expect(find.text('Pizza'), findsOneWidget);
      expect(find.text('389 kcal'), findsOneWidget);
      expect(find.text('85%'), findsOneWidget);
    });
  });

  group('NutritionTable', () {
    testWidgets('displays all macro values', (tester) async {
      final nutrition = Nutrition(
        calories: 540,
        protein: 25,
        totalCarbs: 45,
        totalFat: 28,
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: NutritionTable(nutrition: nutrition))),
      );

      expect(find.text('540 kcal'), findsOneWidget);
      expect(find.text('25.0 g'), findsOneWidget);
      expect(find.text('45.0 g'), findsOneWidget);
      expect(find.text('28.0 g'), findsOneWidget);
    });
  });
}
