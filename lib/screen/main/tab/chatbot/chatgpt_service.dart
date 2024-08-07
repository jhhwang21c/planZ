import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String apiKey = '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';


  Future<String> sendMessageGPT(List<Map<String, String>> history, {required String message}) async {
    try {
      final response = await _dio.post(
        "https://api.openai.com/v1/chat/completions",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $apiKey',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
        data: {
          "model": 'gpt-4o-mini',
          "messages": [
            {
              "role": "system",
              "content":
              "You are a tour guide chatbot, Ziral. You can answer in English, Korean, Japanese, and Chinese, depending on the user's language."
            },
            ...history,
            {
              "role": "user",
              "content": message
            },
          ],
        },
      );

      final jsonResponse = response.data;

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }

      return jsonResponse["choices"][0]["message"]["content"];
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

}
