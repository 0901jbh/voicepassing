import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:voicepassing/models/result_model.dart';

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

  static Future getPhoneNumber(phoneNumber) async {
    List<ResultModel> resultModelInstances = [];
    final url = Uri.parse('$baseUrl/phishings/$phoneNumber');
    final response = await http.get(url);
    if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 200) {
      final List<dynamic> resultList = jsonDecode(response.body)['resultList'];
      for (var result in resultList) {
        final instance = ResultModel.toJson(result);
        resultModelInstances.add(instance);
      }
      return resultModelInstances;
    }
    throw Error();
  }

  static Future<List<ResultModel>> getRecentResult(androidId) async {
    List<ResultModel> resultList = [];
    final url = Uri.parse('$baseUrl/results/$androidId');
    final response = await http.get(url);
    if (response.statusCode == 204) {
      return resultList;
    } else if (response.statusCode == 200) {
      final List<dynamic> resultInstances =
          jsonDecode(response.body)['results'];
      for (var result in resultInstances) {
        final instance = ResultModel.toJson(result);
        resultList.add(instance);
        debugPrint(instance.date.toString());
      }
      return resultList;
    }
    throw Error();
  }
}
