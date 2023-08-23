import 'dart:async';

import 'package:http/http.dart' as http;

// class User{
//   static const String clientId = "NbzjRfinNefY4ce0WL4P";
//   static const String clientSecret ="1VLJaoivYz";
//
//
//   static const Map<String, String> userHeader = {
//     "X-Naver-Client-Id": User.clientId,
//     "X-Naver-Client-Secret": User.clientSecret,
//     "User-Agent": curl/7.49.1,
//     "Accept": "*/*"
//   };
//
// }

class ApiExamSearchBook {
  final String clientId;
  final String clientSecret;

  ApiExamSearchBook(this.clientId, this.clientSecret);

  Future<String> searchBook(String query) async {
    // String text = Uri.encodeComponent(query);
    String apiURL =
        "https://openapi.naver.com/v1/search/book.json?query=$query";

    Map<String, String> requestHeaders = {
      "X-Naver-Client-Id": clientId,
      "X-Naver-Client-Secret": clientSecret,
    };

    return await _get(apiURL, requestHeaders);
  }

  Future<String> _get(String apiUrl, Map<String, String> requestHeaders) async {
    final response = await http.get(Uri.parse(apiUrl), headers: requestHeaders);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
