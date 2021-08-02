import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class Show extends StatelessWidget {
  final String title;
  final String postdata;
  const Show({required this.title, required this.postdata});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: Html(data: postdata),
          )),
    );
  }
}
