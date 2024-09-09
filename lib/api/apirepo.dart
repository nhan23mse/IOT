import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiRepository {
  static const _url = 'http://13.215.30.49:5000/api/';

  static dynamic post(
      {required String path, Map<String, dynamic> options = const {}}) async {
    final response = await http.post(
      Uri.parse(_url + path),
      body: jsonEncode(options),
      headers: {'Content-Type': 'application/json'},
    );
    final responseData = jsonDecode(response.body);
    return responseData;
  }

  static dynamic get(
      {required String path, Map<String, dynamic> options = const {}}) async {
    final response = await http.get(
      Uri.parse(_url + path),
    );
    final responseData = jsonDecode(response.body);
    return responseData;
  }

  static dynamic patch(
      {required String path,
        Map<String, dynamic> options = const {}}) async {
    final response = await http.patch(
      Uri.parse(_url + path),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(options),
    );
    final responseData = jsonDecode(response.body);
    return responseData;
  }

  static dynamic put(
      {required String path,
        Map<String, dynamic> options = const {}}) async {
    final response = await http.put(
      Uri.parse(_url + path),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(options),
    );
    final responseData = jsonDecode(response.body);
    return responseData;
  }
}
