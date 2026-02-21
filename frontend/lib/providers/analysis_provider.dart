import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/analysis_result.dart';
import '../services/api_service.dart';

class AnalysisProvider extends ChangeNotifier {
  AnalysisResult? _result;
  bool _isLoading = false;
  String? _error;

  AnalysisResult? get result => _result;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> analyzeImage(File imageFile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _result = await ApiService.analyzeFood(imageFile);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _result = null;
    _error = null;
    notifyListeners();
  }
}
