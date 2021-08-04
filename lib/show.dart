import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:techworks/api.dart';
import 'package:techworks/config.dart';

class Show extends StatelessWidget {
  final String title;
  final String postdata;
  const Show({required this.title, required this.postdata});

  Future<Null> refreshList() async {
    await Future.delayed(Duration(microseconds: REFRESH_DURATION));
    Api.fetchData();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(onPressed: refreshList, icon: Icon(Icons.settings)),
          ],
        ),
        body: RefreshIndicator(
          color: Colors.white,
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Html(data: postdata),
              )),
          onRefresh: refreshList,
        ));
  }
}
