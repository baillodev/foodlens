import 'package:flutter/foundation.dart';

import '../models/analysis_result.dart';
import '../models/history_entry.dart';
import '../services/api_service.dart';

class HistoryProvider extends ChangeNotifier {
  List<HistoryEntry> _entries = [];
  bool _isLoading = false;
  String? _error;

  List<HistoryEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _entries = await ApiService.getHistory();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<AnalysisResult?> fetchDetail(int id) async {
    try {
      return await ApiService.getHistoryDetail(id);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return null;
    }
  }
}
