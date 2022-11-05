import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wordle/const/const_url.dart';

class GenerateService {
  static final GenerateService _genService = GenerateService._internal();
  factory GenerateService() => _genService;
  GenerateService._internal();

  Future request({
    Method method = Method.get,
    required String path,
  }) async {
    http.Response response;

    final uri = Uri.parse(generateWordUrl + path);
    switch (method) {
      case Method.get:
        response = await http.get(uri);
        break;
      case Method.delete:
        response = await http.delete(
          uri,
          encoding: utf8,
        );
        break;
      case Method.put:
        response = await http.put(
          uri,
          encoding: utf8,
        );
        break;
      default:
        response = await http.post(
          uri,
          encoding: utf8,
        );
        break;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body);
      if (json!= null) {
        final data = json;
        return data;
      } else {
        throw Exception('Server Error');
      }
    }
    throw Exception('Error : ${response.statusCode}');
  }
}

enum Method {
  get,
  post,
  put,
  delete,
}

final genService = GenerateService();
