import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String baseUrl = dotenv.env['BASE_URL']!;
  static Future getCaseNum() async {
    final url = Uri.parse('$baseUrl/results');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      return result;
    }

    throw Error();
  }
}
