import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class to handle API operations for the quiz app.
class ApiService {
  // Base URL for the quiz API.
  static const String _baseUrl = "https://api.jsonserve.com/Uw5CrX";

  /// Fetches quiz data from the API.
  ///
  /// Returns a map containing the quiz questions.
  /// Throws an exception if the API call fails.
  static Future<Map<String, dynamic>> fetchQuizData() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        // Decode and return JSON response.
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load quiz data");
      }
    } catch (e) {
      // Handle errors during API call.
      throw Exception("Error: $e");
    }
  }
}
