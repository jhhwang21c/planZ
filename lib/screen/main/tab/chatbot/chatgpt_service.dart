import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String apiKey = '...';


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
              "You are a tour guide chatbot, Zee, in an app called planZ. You know everything about traveling Korea including the customs and culture. You can answer in English, Korean, Japanese, and Chinese, depending on the user's language."
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
