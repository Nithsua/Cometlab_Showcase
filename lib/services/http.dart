import 'dart:convert';

import 'package:http/http.dart';

class HTTPService {
  static Future<Map<String, dynamic>> requestData(Uri url) async {
    final Response response = await get(url);
    final Map<String, dynamic> json = jsonDecode(response.body);
    return json;
  }
}
