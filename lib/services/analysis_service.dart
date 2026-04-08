import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/analysis_models.dart';

class AnalysisService {
  static const String baseUrl = 'http://10.0.2.2:5000';
  // For Windows desktop testing, replace with:
  // static const String baseUrl = 'http://localhost:5000/api/analyze';

  static Future<AnalysisResultModel> analyzePrompt(String prompt) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/api/analyze'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'prompt': prompt}),
        )
        .timeout(const Duration(seconds: 120));

    if (response.statusCode != 200) {
      throw Exception('Backend error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return AnalysisResultModel.fromBackendJson(data);
  }
}
