import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/analysis_result.dart';
import '../models/history_entry.dart';

class ApiService {
  static Future<AnalysisResult> analyzeFood(File imageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConfig.analyzeEndpoint),
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    final streamedResponse = await request.send().timeout(
          const Duration(seconds: 60),
        );
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return AnalysisResult.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    }

    final error = json.decode(response.body);
    throw Exception(error['detail'] ?? 'Erreur lors de l\'analyse');
  }

  static Future<List<HistoryEntry>> getHistory() async {
    final response = await http.get(
      Uri.parse(ApiConfig.historyEndpoint),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Erreur lors du chargement de l\'historique');
  }

  static Future<AnalysisResult> getHistoryDetail(int id) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.historyEndpoint}/$id'),
    );

    if (response.statusCode == 200) {
      return AnalysisResult.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception('Analyse non trouvee');
  }
}
