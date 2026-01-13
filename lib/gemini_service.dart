import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  static final Uri _endpoint = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=$_apiKey',
  );

  static Future<String> generate(String prompt) async {
    final response = await http.post(
      _endpoint,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gemini API error ${response.statusCode}: ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded == null ||
        decoded['candidates'] == null ||
        decoded['candidates'].isEmpty) {
      throw Exception('Gemini returned no candidates');
    }

    final content = decoded['candidates'][0]['content'];
    if (content == null || content['parts'] == null) {
      throw Exception('Gemini response missing content');
    }

    final parts = content['parts'] as List;
    final buffer = StringBuffer();

    for (final part in parts) {
      if (part['text'] != null) {
        buffer.write(part['text']);
      }
    }

    final result = buffer.toString().trim();

    if (result.isEmpty) {
      throw Exception('Gemini returned empty text');
    }

    return result;
  }
}
