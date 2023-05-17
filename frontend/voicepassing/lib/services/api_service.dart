import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:voicepassing/models/keyword_model.dart';
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
          jsonDecode(utf8.decode(response.bodyBytes))['results'];
      for (var result in resultInstances) {
        // debugPrint(result.toString());
        final instance = ResultModel.toJson(result);
        resultList.add(instance);
        // debugPrint(instance.toString());
      }
      return resultList;
    }
    throw Error();
  }

  static Future<KeywordModel> getKeywordSentence() async {
    final url = Uri.parse('$baseUrl/keyword');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return KeywordModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('failed to load data');
    }
  }

  static Future<List<double>> getCategoryNum() async {
    List<double> returnData = [0, 0, 0];
    final url = Uri.parse('$baseUrl/results/category');
    final response = await http.get(url);
    if (response.statusCode == 204) {
      return [0, 0, 0];
    } else if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)['result'];
      var countList = List<int>.from(jsonData['count']);
      returnData[0] = countList[0].toDouble();
      returnData[1] = countList[1].toDouble();
      returnData[2] = countList[2].toDouble();

      return returnData;
    }
    throw Error();
  }
}
