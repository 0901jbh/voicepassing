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

  static getPhoneNumber(phoneNumber) async {
    final url = Uri.parse('$baseUrl/phishings/$phoneNumber');
    final response = await http.get(url);
    if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Error();
  }

  // static Future<List<ResultModel>> getPhoneResult(phoneNumber) async {
  //   List<ResultModel> resultInstance = [];
  //   final url = Uri.parse('$baseUrl/phishings/$phoneNumber');
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     final results = jsonDecode(response.body);
  //     for (var result in results) {

  //     }
  //   }
  //   }
  //   throw Error();

  // }
}
