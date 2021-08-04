import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:techworks/config.dart';
import 'package:techworks/model.dart';

class Failure {
  final String message;
  Failure(this.message);
  @override
  String toString() => message;
}

class Api {
  static Future<List<PostModel>> fetchData() async {
    final response = await http.get(Uri.parse(URL), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $SECRET',
    });
    try {
      if (response.statusCode == 403) {
        throw Failure('403');
      } else if (response.statusCode != 200) {
        throw Failure('500');
      }
      final body = json.decode(response.body);
      return body.map<PostModel>(PostModel.fromJson).toList();
    } on SocketException {
      throw Failure('523');
    }
  }
}
