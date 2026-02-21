class ApiConfig {
  // Android emulator -> localhost
  // Pour un appareil physique, remplacer par l'IP locale du PC
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  static const String analyzeEndpoint = '$baseUrl/analyze';
  static const String historyEndpoint = '$baseUrl/history';
  static const String healthEndpoint = '$baseUrl/health';
}
