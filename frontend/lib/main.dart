import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/theme.dart';
import 'providers/analysis_provider.dart';
import 'providers/history_provider.dart';
import 'screens/capture_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/results_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnalysisProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const FoodLensApp(),
    ),
  );
}

class FoodLensApp extends StatelessWidget {
  const FoodLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodLens',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/capture': (_) => const CaptureScreen(),
        '/loading': (_) => const LoadingScreen(),
        '/results': (_) => const ResultsScreen(),
        '/history': (_) => const HistoryScreen(),
      },
    );
  }
}
