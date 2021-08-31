import 'dart:convert';

import 'package:http/http.dart';
import 'package:newslife/env/env.dart';

class HTTPService {
  static Future<Map<String, dynamic>> requestData(Uri url) async {
    final Response response;
    try {
      response = await get(url, headers: {"Authorization": apiKey});
    } catch (e) {
      print(e);
      throw e;
    }
    print(response.statusCode);
    final Map<String, dynamic> json = jsonDecode(response.body);
    if (json["status"] == "error") {
      if (json["code"] == "apiKeyExhausted")
        throw Exception("Exhausted API key");
      throw Exception("Contact Developer");
    }
    return json;
  }
}
