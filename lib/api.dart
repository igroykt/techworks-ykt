import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:techworks/config.dart';
import 'package:techworks/localization/ru.dart';
import 'package:techworks/model.dart';

class Api {
  static Future<List<PostModel>> fetchData() async {
    final response = await http.get(Uri.parse(URL), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $SECRET',
    });
    try {
      if (response.statusCode == 403) {
        throw HttpException('403');
      }
      final body = json.decode(response.body);
      return body.map<PostModel>(PostModel.fromJson).toList();
    } on SocketException {
      throw (MSG_NO_INET);
    } on FormatException {
      throw (MSG_BAD_RESP);
    }
  }
}
